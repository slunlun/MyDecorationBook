//
//  UIViewController+SWDrawerViewController.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/20/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import "UIViewController+SWDrawerViewController.h"

@implementation UIViewController (SWDrawerViewController)
- (SWDrawerViewController *)sw_drawerViewController {
    UIViewController *parentViewController = self.parentViewController;
    while (parentViewController) {
        if ([parentViewController isKindOfClass:[SWDrawerViewController class]]) {
            return (SWDrawerViewController *)parentViewController;
        }
        parentViewController = parentViewController.parentViewController;
    }
    return nil;
}

- (CGRect)sw_visibleDrawerFrame {
    // 若是leftDrawer, 则leftDrawer view的frame original
    if ([self isEqual:self.sw_drawerViewController.leftDrawerViewController] ||
        [self.navigationController isEqual:self.sw_drawerViewController.leftDrawerViewController]){
        CGRect rect = self.sw_drawerViewController.view.bounds;
        rect.size.width = self.sw_drawerViewController.maximumLeftDrawerWidth;
        return rect;
    }
    return CGRectNull;  // 与 CGRectZero 有何区别
}
@end
