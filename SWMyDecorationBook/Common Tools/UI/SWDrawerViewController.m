//
//  SWDrawerViewController.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/20/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import "SWDrawerViewController.h"
#import "UIViewController+SWDrawerViewController.h"
#import "Masonry.h"
#import "SWUIDef.h"
#import "HexColor.h"
CGFloat const SWDrawerDefaultWidth = 280.0f;
CGFloat const SWDrawerDefaultAnimationVelocity = 840.0f;
CGFloat const SWDrawerDefaultShadowOpacity = 0.8f;
CGFloat const SWDrawerDefaultShadowRadius = 10.0f;
CGFloat const SWDrawerPanVelocityXAnimationThreshold = 200.0f;
CGFloat const SWDrawerMinAnimationDuration = 0.15f;
/** The percent of the possible overshoot width to use as the actual overshoot percentage. */
CGFloat const SWDrawerOvershootPercentage = 0.1f;
/** The amount of overshoot that is panned linearly. The remaining percentage nonlinearly asymptotes to the max percentage. */
CGFloat const SWDrawerOvershootLinearRangePercentage = 0.75f;

@interface SWDrawerCenterContainerView : UIView
@property(nonatomic, assign) SWDrawerSide openSide;
@end

@implementation SWDrawerCenterContainerView
// 利用hitTest 来确保当Drawer 被打开时，centerVC不会响应任何事件（tap 关闭Drawer 事件除外）
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView) {
        if (self.openSide != SWDrawerSideNone) {
            hitView = nil;
        }
    }
    return hitView;
}

@end

@interface SWDrawerViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView * childControllerContainerView;
@property(nonatomic, strong) SWDrawerCenterContainerView *centerContainerView;
@property (nonatomic, assign, getter = isAnimatingDrawer) BOOL animatingDrawer;
@property(nonatomic, assign) SWDrawerSide openSide;

@property (nonatomic, assign) CGRect startingPanRect;
@end

@implementation SWDrawerViewController
#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonSetup];
    }
    return self;
}

-(void)commonSetup{
    [self setMaximumLeftDrawerWidth:SWDrawerDefaultWidth];
    [self setAnimationVelocity:SWDrawerDefaultAnimationVelocity];
    [self setShowsShadow:YES];
    [self setShouldStretchDrawer:YES];

    // set shadow related default values
    [self setShadowOpacity:SWDrawerDefaultShadowOpacity];
    [self setShadowRadius:SWDrawerDefaultShadowRadius];
    [self setShadowOffset:CGSizeMake(0, -3)];
    [self setShadowColor:[UIColor colorWithHexString:SW_BLACK_COLOR]];
    
    // set defualt panVelocityXAnimationThreshold
    [self setPanVelocityXAnimationThreshold:SWDrawerPanVelocityXAnimationThreshold];
}

- (instancetype)initWithCenterViewController:(UIViewController *)centerViewController leftDrawerViewController:(UIViewController *)leftDrawerViewController {
    if (self = [super init]) {
        self.leftDrawerViewController = leftDrawerViewController;
        self.centerDrawerViewController = centerViewController;
    }
    return self;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self setupGestureRecognizers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.centerDrawerViewController beginAppearanceTransition:NO animated:animated];
    if (self.openSide == SWDrawerSideLeft) {
        [self.leftDrawerViewController beginAppearanceTransition:NO animated:animated];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setters
- (void)setAnimatingDrawer:(BOOL)animatingDrawer {
    _animatingDrawer = animatingDrawer;
    [self.view setUserInteractionEnabled:!animatingDrawer];
}

- (void)setOpenSide:(SWDrawerSide)openSide {
    if (_openSide != openSide) {
        _openSide = openSide;
        if (openSide == SWDrawerSideNone) {
            [self.leftDrawerViewController.view setHidden:YES];
        }
    }
}

- (void)setMaximumLeftDrawerWidth:(CGFloat)maximumLeftDrawerWidth{
    [self setMaximumLeftDrawerWidth:maximumLeftDrawerWidth animated:NO];
}

- (void)setMaximumLeftDrawerWidth:(CGFloat)maximumLeftDrawerWidth animated:(BOOL)animated
{
    CGFloat oldWidth = self.maximumLeftDrawerWidth;
    _maximumLeftDrawerWidth = maximumLeftDrawerWidth;
    
    CGFloat distance = ABS(oldWidth - maximumLeftDrawerWidth);
    NSTimeInterval timeDuration = [self animationDurationForAnimationDistance:distance];
    
    CGRect newFrame = self.centerContainerView.frame;
    newFrame.origin.x += maximumLeftDrawerWidth;
    
    if (self.openSide == SWDrawerSideLeft) {
        [UIView animateWithDuration:animated?timeDuration:0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            // set new frame for center view
            if (self.openSide == SWDrawerSideLeft) {
                self.centerContainerView.frame = newFrame;
                self.leftDrawerViewController.view.frame = self.sw_visibleDrawerFrame;
                
            }else{
                
            }
        } completion:^(BOOL finished) {
            
        }];
        
    }else{
        self.leftDrawerViewController.view.frame = self.sw_visibleDrawerFrame;
    }
   
}

- (void)setLeftDrawerViewController:(UIViewController *)leftDrawerViewController
{
    UIViewController *currentLeftDrawerViewController = [self sideDrawerViewControllerForSide:SWDrawerSideLeft];
    if ([currentLeftDrawerViewController isEqual:leftDrawerViewController]) {
        return;
    }
    
    if (currentLeftDrawerViewController != nil) {
        // If you are implementing a custom container controller, use this method to tell the child that its views are about to appear or disappear.
        [currentLeftDrawerViewController beginAppearanceTransition:NO animated:NO]; // 这里会触发currentLeftDrawerViewControllerd的viewWillDisapper，viewWillAppear之类的方法
        [currentLeftDrawerViewController.view removeFromSuperview];
        [currentLeftDrawerViewController endAppearanceTransition];
        
        [currentLeftDrawerViewController willMoveToParentViewController:nil]; // 同样类似上面，手动调用系统回调，通知viewController 将要被添加到／移除 与container VC
        [currentLeftDrawerViewController removeFromParentViewController];
    }
    
    _leftDrawerViewController = leftDrawerViewController;
    UIViewAutoresizing autoResizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    
    if (leftDrawerViewController) {
        [self addChildViewController:leftDrawerViewController];
        
        if (self.openSide == SWDrawerSideLeft
            && [self.childControllerContainerView.subviews containsObject:self.centerContainerView]) { // 若已经打开left drawer，则将新的leftVC的view直接添加到childControllerContainerView并显示
            [self.childControllerContainerView insertSubview:leftDrawerViewController.view belowSubview:self.centerContainerView];
            [leftDrawerViewController beginAppearanceTransition:YES animated:NO];
            [leftDrawerViewController endAppearanceTransition];
        }else{
            [self.childControllerContainerView addSubview:leftDrawerViewController.view];
            [self.childControllerContainerView bringSubviewToFront:leftDrawerViewController.view];
            leftDrawerViewController.view.hidden = YES;
        }
        
        [_leftDrawerViewController didMoveToParentViewController:self];
        _leftDrawerViewController.view.autoresizingMask = autoResizingMask;
        [_leftDrawerViewController.view setFrame:leftDrawerViewController.sw_visibleDrawerFrame];
    }
}

- (void)setCenterDrawerViewController:(UIViewController *)centerDrawerViewController
{
    [self setCenterDrawerViewController:centerDrawerViewController animated:NO];
}

- (void)setCenterDrawerViewController:(UIViewController *)centerDrawerViewController animated:(BOOL)animated{
    
    if ([self.centerDrawerViewController isEqual:centerDrawerViewController]) {
        return;
    }
    
    if (_centerContainerView == nil) {
        CGRect centerContainerViewFrame = self.childControllerContainerView.bounds;
        if (_centerContainerView == nil) {
            _centerContainerView = [[SWDrawerCenterContainerView alloc] initWithFrame:centerContainerViewFrame];
            _centerContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            _centerContainerView.backgroundColor = [UIColor clearColor];
            _centerContainerView.openSide = self.openSide;
            [self.childControllerContainerView addSubview:_centerContainerView];
        }
    }
    
    UIViewController *oldCneterViewController = self.centerDrawerViewController;
    if (oldCneterViewController) {
        [oldCneterViewController willMoveToParentViewController:nil];
        //这里animiated 与 是否调用 beginAppearanceTransition／endAppearanceTransition 有何关系？
        if (animated == NO) {
            [oldCneterViewController beginAppearanceTransition:NO animated:NO];
        }
        
        [oldCneterViewController.view removeFromSuperview];
        
        if (animated == NO) {
            [oldCneterViewController endAppearanceTransition];
        }
        [oldCneterViewController removeFromParentViewController];
    }
    
    _centerDrawerViewController = centerDrawerViewController;
    
    [self addChildViewController:centerDrawerViewController];
    [self.centerDrawerViewController.view setFrame:self.childControllerContainerView.bounds];
    [self.centerContainerView addSubview:centerDrawerViewController.view];
    [self.childControllerContainerView bringSubviewToFront:self.centerContainerView];
    self.centerDrawerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    // 设置阴影
    [self updateShadowForCenterView];
    
    if (animated == NO) {
        if (self.view.window) {
            [self.centerDrawerViewController beginAppearanceTransition:NO animated:NO];
            [self.centerDrawerViewController endAppearanceTransition];
        }
        [self.centerDrawerViewController didMoveToParentViewController:self];
    }
    
}

#pragma mark - Getters
-(UIView*)childControllerContainerView{
    if(_childControllerContainerView == nil){
        //Issue #152 (https://github.com/mutualmobile/MMDrawerController/issues/152)
        //Turns out we have two child container views getting added to the view during init,
        //because the first request self.view.bounds was kicking off a viewDidLoad, which
        //caused us to be able to fall through this check twice.
        //
        //The fix is to grab the bounds, and then check again that the child container view has
        //not been created.
        CGRect childContainerViewFrame = self.view.bounds;
        if(_childControllerContainerView == nil){
            _childControllerContainerView = [[UIView alloc] initWithFrame:childContainerViewFrame];
            [_childControllerContainerView setBackgroundColor:[UIColor clearColor]];
            [_childControllerContainerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
            [self.view addSubview:_childControllerContainerView];
        }
        
    }
    return _childControllerContainerView;
}

#pragma makr - Open/Close method
- (void)openDrawer:(SWDrawerSide)drawerSide animated:(BOOL)animated completion:(void(^)(BOOL finished))completion {
    [self openDrawer:drawerSide animated:animated velocity:self.animationVelocity animationOptions:UIViewAnimationOptionCurveEaseInOut completion:completion];
}

- (void)openDrawer:(SWDrawerSide)drawerSide animated:(BOOL)animated velocity:(CGFloat)velocity animationOptions:(UIViewAnimationOptions) options completion:(void(^)(BOOL finished))completion {
    if (self.isAnimatingDrawer) {
        completion(NO);
        return;
    }
    
    [self setAnimatingDrawer:animated];
    UIViewController *sideDrawerViewController = [self sideDrawerViewControllerForSide:drawerSide];
    if (self.openSide != drawerSide) {
        [self prepareToPresentDrawer:drawerSide animated:animated];
    }
    
    if(sideDrawerViewController){
        CGRect newFrame;
        CGRect oldFrame = self.centerContainerView.frame;
        if(drawerSide == SWDrawerSideLeft){
            newFrame = self.centerContainerView.frame;
            newFrame.origin.x = self.maximumLeftDrawerWidth;
        }
        
        
        CGFloat distance = ABS(CGRectGetMinX(oldFrame)-newFrame.origin.x);
        NSTimeInterval duration = MAX(distance/ABS(velocity),SWDrawerMinAnimationDuration);
        
        [UIView
         animateWithDuration:(animated?duration:0.0)
         delay:0.0
         options:options
         animations:^{
             [self.centerContainerView setFrame:newFrame];
             [self updateDrawerVisualStateForDrawerSide:drawerSide percentVisible:1.0];
         }
         completion:^(BOOL finished) {
             //End the appearance transition if it already wasn't open.
             if(drawerSide != self.openSide){
                 [sideDrawerViewController endAppearanceTransition];
             }
             [self setOpenSide:drawerSide];
             
             [self resetDrawerVisualStateForDrawerSide:drawerSide];
             [self setAnimatingDrawer:NO];
             if(completion){
                 completion(finished);
             }
         }];
    }
}

- (void)closeDrawerAnimated:(BOOL)animated completion:(void(^)(BOOL finished))completion {
    [self closeDrawerAnimated:animated velocity:self.animationVelocity animationOperations:UIViewAnimationOptionCurveEaseInOut completion:completion];
}

- (void)closeDrawerAnimated:(BOOL)animated velocity:(CGFloat)velocity animationOperations:(UIViewAnimationOptions) operations completion:(void(^)(BOOL finished)) completion {
    if (self.isAnimatingDrawer) {
        completion(NO);
        return;
    }
    
    [self setAnimatingDrawer:animated];
    
    CGRect newFrame = self.childControllerContainerView.bounds;  // 这里 childControllerContainerView 不会变更frame，类似于坐标原点的作用，用于归位centerContainerView
    CGFloat distance = CGRectGetMinX(self.centerContainerView.frame);
    NSTimeInterval timeInterval = MAX(distance/ABS(velocity), SWDrawerMinAnimationDuration);
    CGFloat percentVisible = 0.0f;
    BOOL leftDrawerVisible = CGRectGetMinX(self.centerContainerView.frame) > 0;
    SWDrawerSide visibleSide = SWDrawerSideNone;
    if(leftDrawerVisible){
        percentVisible = MAX(0.0, leftDrawerVisible/self.maximumLeftDrawerWidth);
        visibleSide = SWDrawerSideLeft;
    }
    
    UIViewController *leftDrawerViewController = [self sideDrawerViewControllerForSide:SWDrawerSideLeft];
    
    [leftDrawerViewController beginAppearanceTransition:NO animated:animated];
    
    [UIView animateWithDuration:timeInterval
                          delay:0.0
                        options:operations
                     animations:^{
                         self.centerContainerView.frame = newFrame;
                         [self updateDrawerVisualStateForDrawerSide:visibleSide percentVisible:percentVisible]; // TODO, 这里目前没有任何实现
        
    } completion:^(BOOL finished) {
        if (completion) {
            // 1. update isAnimation state
            [self setAnimatingDrawer:NO];
            // 2. update self.openSide
            [self setOpenSide:SWDrawerSideNone];
            // 3. reset visual drawer to unanimation state
            [self resetDrawerVisualStateForDrawerSide:visibleSide];
            completion(finished);
        }
    }];
    
    
}
#pragma mark - Gesture call backs
- (void)tapGetureCallBack:(UITapGestureRecognizer *)tapGesture {
    if(self.openSide != SWDrawerSideNone &&
       self.isAnimatingDrawer == NO){
        [self closeDrawerAnimated:YES completion:^(BOOL finished) {
            if (self.drawerSideChangedBlock) {
                self.drawerSideChangedBlock(SWDrawerSideNone);
            }
        }];
    }
}

- (void)panGestureCallBack:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (self.isAnimatingDrawer) {
                panGesture.enabled = NO;
                return;
            }else{
                self.startingPanRect = self.centerContainerView.frame;
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            self.view.userInteractionEnabled = NO;
            CGRect newFrame = self.startingPanRect;
            CGPoint translatePoint = [panGesture translationInView:self.centerContainerView];
            newFrame.origin.x = [self roundedOriginXForDrawerConstriants:CGRectGetMinX(self.startingPanRect)+translatePoint.x];
            newFrame = CGRectIntegral(newFrame);
            CGFloat xOffset = newFrame.origin.x;
            
            SWDrawerSide visibleSide = SWDrawerSideNone;
            CGFloat percentVisible = 0.0;
            NSLog(@"The offset is %lf", xOffset);
            if(xOffset > 0){ // 相对于起点，手指还在右侧 ,意味着leftDrawer 仍然可见
                visibleSide = SWDrawerSideLeft;
                percentVisible = xOffset/self.maximumLeftDrawerWidth;
            }else if(xOffset < 0) { // 相对于起点，手指在左侧，已经完全关闭了leftDraswer
           
                return;
            }
            
            // visibleSideDrawerViewController 为可见的drawerViewController
            UIViewController * visibleSideDrawerViewController = [self sideDrawerViewControllerForSide:visibleSide];
            
            if(self.openSide != visibleSide){ // 当前的openSide与滑动手势不一致 则 显示 该显示的 关闭 该关闭的
                // Handle disappearing the visible drawer
                UIViewController * sideDrawerViewController = [self sideDrawerViewControllerForSide:self.openSide];
                [sideDrawerViewController beginAppearanceTransition:NO animated:NO];
                [sideDrawerViewController endAppearanceTransition];
                
                // Drawer is about to become visible
                [self prepareToPresentDrawer:visibleSide animated:NO];
                [visibleSideDrawerViewController endAppearanceTransition];
                [self setOpenSide:visibleSide];
            }
            else if(visibleSide == SWDrawerSideNone){
                [self setOpenSide:SWDrawerSideNone];
            }
            
            [self updateDrawerVisualStateForDrawerSide:visibleSide percentVisible:percentVisible];
            
            // 现在更新centerView的位置
            [self.centerContainerView setCenter:CGPointMake(CGRectGetMidX(newFrame), CGRectGetMidY(newFrame))];
            newFrame = self.centerContainerView.frame;
            newFrame.origin.x = floor(newFrame.origin.x);
            newFrame.origin.y = floor(newFrame.origin.y);
            self.centerContainerView.frame = newFrame;
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:{
            
            self.startingPanRect = CGRectNull;
            // 根据用户的手势速度 自动 关闭 或 打开 drawer view controller
            CGPoint velocity = [panGesture velocityInView:self.childControllerContainerView];
            [self finishAnimationForPanGestureWithXVelocity:velocity.x completion:^(BOOL finished) {
                if(self.drawerSideChangedBlock){
                    self.drawerSideChangedBlock(self.openSide);
                }
            }];
            self.view.userInteractionEnabled = YES;
            break;
        }
            break;
        default:
            break;
    }
}

#pragma mark - Animation helper
-(void)finishAnimationForPanGestureWithXVelocity:(CGFloat)xVelocity completion:(void(^)(BOOL finished))completion {
    CGFloat currentOriginX = CGRectGetMinX(self.centerContainerView.frame);
    CGFloat animationVelocity = MAX(ABS(xVelocity), self.panVelocityXAnimationThreshold * 2);
    if (self.openSide == SWDrawerSideLeft) {
        CGFloat midPoint = self.maximumLeftDrawerWidth / 2.0;
        if(xVelocity < -self.panVelocityXAnimationThreshold) {
            [self closeDrawerAnimated:YES velocity:animationVelocity animationOperations:UIViewAnimationOptionCurveEaseInOut completion:completion];
        }else if(xVelocity > self.panVelocityXAnimationThreshold) {
            [self openDrawer:SWDrawerSideLeft animated:YES velocity:animationVelocity animationOptions:UIViewAnimationOptionCurveEaseInOut completion:completion];
        }else if(currentOriginX < midPoint) {
            [self closeDrawerAnimated:YES completion:completion];
        }else{
            [self openDrawer:SWDrawerSideLeft animated:YES completion:completion];
        }
    }
}


-(void)updateDrawerVisualStateForDrawerSide:(SWDrawerSide)drawerSide percentVisible:(CGFloat)percentVisible{
   
    if(self.shouldStretchDrawer){ // 当拉动大于最大值时 是否显示拉伸动画（类似于scrollview）
        [self applyOvershootScaleTransformForDrawerSide:drawerSide percentVisible:percentVisible];
    }
}

- (void)applyOvershootScaleTransformForDrawerSide:(SWDrawerSide)drawerSide percentVisible:(CGFloat)percentVisible{
    
    if (percentVisible >= 1.f) {
        CATransform3D transform = CATransform3DIdentity;
        UIViewController * sideDrawerViewController = [self sideDrawerViewControllerForSide:drawerSide];
        if(drawerSide == SWDrawerSideLeft) {
            transform = CATransform3DMakeScale(percentVisible, 1.f, 1.f);
            transform = CATransform3DTranslate(transform, self.maximumLeftDrawerWidth*(percentVisible-1.f)/2, 0.f, 0.f);
        }
        sideDrawerViewController.view.layer.transform = transform;
    }
}


-(CGFloat)roundedOriginXForDrawerConstriants:(CGFloat)originX{
    
   if(originX > self.maximumLeftDrawerWidth){
        if (self.shouldStretchDrawer &&
            self.leftDrawerViewController) {
            CGFloat maxOvershoot = (CGRectGetWidth(self.centerContainerView.frame)-self.maximumLeftDrawerWidth)*SWDrawerOvershootPercentage;
            return originXForDrawerOriginAndTargetOriginOffset(originX, self.maximumLeftDrawerWidth, maxOvershoot);
        }
        else{
            return self.maximumLeftDrawerWidth;
        }
    }
    
    return originX;
}

static inline CGFloat originXForDrawerOriginAndTargetOriginOffset(CGFloat originX, CGFloat targetOffset, CGFloat maxOvershoot){
    CGFloat delta = ABS(originX - targetOffset);
    CGFloat maxLinearPercentage = SWDrawerOvershootLinearRangePercentage;
    CGFloat nonLinearRange = maxOvershoot * maxLinearPercentage;
    CGFloat nonLinearScalingDelta = (delta - nonLinearRange);
    CGFloat overshoot = nonLinearRange + nonLinearScalingDelta * nonLinearRange/sqrt(pow(nonLinearScalingDelta,2.f) + 15000);
    
    if (delta < nonLinearRange) {
        return originX;
    }
    else if (targetOffset < 0) {
        return targetOffset - round(overshoot);
    }
    else{
        return targetOffset + round(overshoot);
    }
}

-(void)prepareToPresentDrawer:(SWDrawerSide)drawer animated:(BOOL)animated{
  
    
    UIViewController * sideDrawerViewControllerToPresent = [self sideDrawerViewControllerForSide:drawer];
   
    [sideDrawerViewControllerToPresent.view setHidden:NO];
    [self resetDrawerVisualStateForDrawerSide:drawer];
    [sideDrawerViewControllerToPresent.view setFrame:sideDrawerViewControllerToPresent.sw_visibleDrawerFrame];
    [self updateDrawerVisualStateForDrawerSide:drawer percentVisible:0.0];
    [sideDrawerViewControllerToPresent beginAppearanceTransition:YES animated:animated];
}

-(void)resetDrawerVisualStateForDrawerSide:(SWDrawerSide)drawerSide{
    UIViewController * sideDrawerViewController = [self sideDrawerViewControllerForSide:drawerSide];
    
    [sideDrawerViewController.view.layer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
    [sideDrawerViewController.view.layer setTransform:CATransform3DIdentity];
    [sideDrawerViewController.view setAlpha:1.0];
}

#pragma mark - Helpers
- (UIViewController *)sideDrawerViewControllerForSide:(SWDrawerSide)drawerSide {
    if (drawerSide == SWDrawerSideNone) {
        return nil;
    }else if(drawerSide == SWDrawerSideLeft){
        return self.leftDrawerViewController;
    }
    return nil;
}

-(void)updateShadowForCenterView {
    UIView * centerView = self.centerContainerView;
    if(self.showsShadow){
        centerView.layer.masksToBounds = NO;
        centerView.layer.shadowRadius = self.shadowRadius;
        centerView.layer.shadowOpacity = self.shadowOpacity;
        centerView.layer.shadowOffset = self.shadowOffset;
        centerView.layer.shadowColor = [self.shadowColor CGColor];
        
        /** In the event this gets called a lot, we won't update the shadowPath
         unless it needs to be updated (like during rotation) */
        if (centerView.layer.shadowPath == NULL) {
            centerView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.centerContainerView.bounds] CGPath];
        }
        else{
            CGRect currentPath = CGPathGetPathBoundingBox(centerView.layer.shadowPath);
            if (CGRectEqualToRect(currentPath, centerView.bounds) == NO){
                centerView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.centerContainerView.bounds] CGPath];
            }
        }
    }
    else if (centerView.layer.shadowPath != NULL) {
        centerView.layer.shadowRadius = 0.f;
        centerView.layer.shadowOpacity = 0.f;
        centerView.layer.shadowOffset = CGSizeMake(0, -3);
        centerView.layer.shadowPath = NULL;
        centerView.layer.masksToBounds = YES;
    }
}

- (NSTimeInterval)animationDurationForAnimationDistance:(CGFloat)distance{
    NSTimeInterval duration = MAX(distance/self.animationVelocity, SWDrawerMinAnimationDuration);
    return duration;
}

- (void)setupGestureRecognizers {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGetureCallBack:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureCallBack:)];
    [self.view addGestureRecognizer:panGesture];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.openSide == SWDrawerSideNone) {
        return NO;
    }else{
        return YES;
    }
}

-(void)setCenterViewController:(UIViewController *)newCenterViewController withCloseAnimation:(BOOL)closeAnimated completion:(void(^)(BOOL finished))completion {
    if (self.openSide == SWDrawerSideNone) { //
        closeAnimated = NO;
    }
    
    BOOL forwardAppearanceMethodsToCenterViewController = ([self.centerDrawerViewController isEqual:newCenterViewController] == NO);
    [self setCenterDrawerViewController:newCenterViewController animated:closeAnimated];
    
    if(closeAnimated){
        [self updateDrawerVisualStateForDrawerSide:self.openSide percentVisible:1.0];
        if (forwardAppearanceMethodsToCenterViewController) {
            [self.centerDrawerViewController beginAppearanceTransition:YES animated:closeAnimated];
        }
        [self closeDrawerAnimated:closeAnimated completion:^(BOOL finished) {
            if (forwardAppearanceMethodsToCenterViewController) {
                [self.centerDrawerViewController endAppearanceTransition];
                [self.centerDrawerViewController didMoveToParentViewController:self];
            }
            
            if (completion) {
                completion(finished);
            }
        }];
    
    }else{
        if(completion){
            completion(YES);
        }
    }

}

-(void)setCenterViewController:(UIViewController *)newCenterViewController withFullCloseAnimation:(BOOL)fullCloseAnimated completion:(void(^)(BOOL finished))completion {

}

@end
