//
//  SWDrawerViewController.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/20/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SWDrawerSide){
    SWDrawerSideNone = 0,
    SWDrawerSideLeft,
};


@interface SWDrawerViewController : UIViewController
- (instancetype)initWithCenterViewController:(UIViewController *)centerViewController leftDrawerViewController:(UIViewController *)leftDrawerViewController;

@property(nonatomic, assign) BOOL showShadow;
@property(nonatomic, assign) BOOL shouldStretchDrawer;
@end
