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

typedef void(^SWDrawerSideDidChangedBlock)(SWDrawerSide drawSide);
#import "SWMarketCategoryViewController.h"
#import "SWShoppingItemHomePageVC.h"
@interface SWDrawerViewController : UIViewController<SWMarketCategoryViewControllerDelegate>
- (instancetype)initWithCenterViewController:(UIViewController *)centerViewController leftDrawerViewController:(UIViewController *)leftDrawerViewController;

-(void)setCenterViewController:(UIViewController *)centerViewController withCloseAnimation:(BOOL)closeAnimated completion:(void(^)(BOOL finished))completion;

-(void)setCenterViewController:(UIViewController *)newCenterViewController withFullCloseAnimation:(BOOL)fullCloseAnimated completion:(void(^)(BOOL finished))completion;

- (void)closeDrawerAnimated:(BOOL)animated completion:(void(^)(BOOL finished))completion;

@property(nonatomic, strong) UIViewController *leftDrawerViewController;
@property(nonatomic, strong) UIViewController *centerDrawerViewController;

@property(nonatomic, assign) BOOL showsShadow;

@property (nonatomic, assign) CGFloat shadowRadius;


@property (nonatomic, assign) CGFloat shadowOpacity;


@property (nonatomic, assign) CGSize shadowOffset;

@property (nonatomic, strong) UIColor * shadowColor;

@property(nonatomic, assign) BOOL shouldStretchDrawer;

@property(nonatomic, assign) CGFloat maximumLeftDrawerWidth;

@property(nonatomic, assign) CGFloat animationVelocity;
@property(nonatomic, assign) CGFloat panVelocityXAnimationThreshold;

@property(nonatomic, copy) SWDrawerSideDidChangedBlock drawerSideChangedBlock;
@end
