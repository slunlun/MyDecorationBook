//
//  AppDelegate.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/20/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWRedViewController.h"
#import "SWYellowViewController.h"
#import "SWBlueViewController.h"
#import "SWDrawerViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SWDrawerViewController *drawerVC;

@end

