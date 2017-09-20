//
//  SWDrawerViewController.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/20/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import "SWDrawerViewController.h"
#import "UIViewController+SWDrawerViewController.h"

CGFloat const SWDrawerDefaultWidth = 280.0f;
CGFloat const SWDrawerDefaultAnimationVelocity = 840.0f;
CGFloat const SWDrawerDefaultShadowOpacity = 0.8f;
CGFloat const SWDrawerDefaultShadowRadius = 10.0f;
CGFloat const SWDrawerPanVelocityXAnimationThreshold = 200.0f;
CGFloat const SWDrawerMinAnimationDuration = 0.15f;



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

@interface SWDrawerViewController ()
@property (nonatomic, strong) UIView * childControllerContainerView;
@property(nonatomic, strong) SWDrawerCenterContainerView *centerContainerView;


@property(nonatomic, assign) SWDrawerSide openSide;
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
    [self setShadowColor:[UIColor blackColor]];
    
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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setters
- (void)setMaximumLeftDrawerWidth:(CGFloat)maximumLeftDrawerWidth{
    [self setMaximumLeftDrawerWidth:maximumLeftDrawerWidth animated:NO];
}

- (void)setMaximumLeftDrawerWidth:(CGFloat)maximumLeftDrawerWidth animated:(BOOL)animated
{
    CGFloat oldWidth = self.maximumLeftDrawerWidth;
    self.maximumLeftDrawerWidth = maximumLeftDrawerWidth;
    
    CGFloat distance = ABS(oldWidth - maximumLeftDrawerWidth);
    NSTimeInterval timeDuration = [self animationDurationForAnimationDistance:distance];
    
    CGRect newFrame = self.centerContainerView.frame;
    newFrame.origin.x += maximumLeftDrawerWidth;
    
    if (self.openSide == SWDrawerSideLeft) {
        [UIView animateWithDuration:animated?timeDuration:0 animations:^{
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
        }
    }
    
    [_leftDrawerViewController didMoveToParentViewController:self];
    _leftDrawerViewController.view.autoresizingMask = autoResizingMask;
    [_leftDrawerViewController.view setFrame:leftDrawerViewController.sw_visibleDrawerFrame];
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



@end
