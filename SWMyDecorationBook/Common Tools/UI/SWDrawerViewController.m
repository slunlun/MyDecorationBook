//
//  SWDrawerViewController.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/20/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import "SWDrawerViewController.h"

@interface SWDrawerCenterContainerView : UIView
@property(nonatomic, assign) SWDrawerSide drawerSide;
@end

@implementation SWDrawerCenterContainerView
// 利用hitTest 来确保当Drawer 被打开时，centerVC不会响应任何事件（tap 关闭Drawer 事件除外）
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView) {
        if (self.drawerSide != SWDrawerSideNone) {
            hitView = nil;
        }
    }
    return hitView;
}

@end

@interface SWDrawerViewController ()
@property (nonatomic, strong) UIView * childControllerContainerView;
@property(nonatomic, strong) SWDrawerCenterContainerView *centerContainerView;
@property(nonatomic, strong) UIViewController *leftDrawerViewController;
@property(nonatomic, strong) UIViewController *centerDrawerViewController;

@property(nonatomic, assign) SWDrawerSide openSide;
@end

@implementation SWDrawerViewController
#pragma mark - Init
- (instancetype)initWithCenterViewController:(UIViewController *)centerViewController leftDrawerViewController:(UIViewController *)leftDrawerViewController {
    if (self = [super init]) {
        
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
        
        [currentLeftDrawerViewController willMoveToParentViewController:nil]; // 同样类似上面，手动调用系统会调，通知viewController 将要被添加到／移除 与container VC
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
    [_leftDrawerViewController.view setFrame:CGRectZero];
    
    
}

- (void)setCenterContainerView:(SWDrawerCenterContainerView *)centerContainerView
{
    
}
#pragma mark - Getters


#pragma mark - Helpers
- (UIViewController *)sideDrawerViewControllerForSide:(SWDrawerSide)drawerSide {
    if (drawerSide == SWDrawerSideNone) {
        return nil;
    }else if(drawerSide == SWDrawerSideLeft){
        return self.leftDrawerViewController;
    }
    return nil;
}


@end
