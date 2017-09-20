//
//  UIViewController+SWDrawerViewController.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/20/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWDrawerViewController.h"
@interface UIViewController (SWDrawerViewController)
@property(nonatomic, strong, readonly) SWDrawerViewController *sw_drawerViewController;

@property(nonatomic, assign, readonly) CGRect sw_visibleDrawerFrame; // 这个属性可以直接获取side drawer的frame（基于其container view的frame及自身的maxSize 计算）
@end
