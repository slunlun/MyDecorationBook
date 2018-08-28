//
//  SWMarketCategoryViewController.h
//  SWMyDecorationBook
//
//  Created by ShiTeng on 2018/2/6.
//  Copyright © 2018年 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWMarketCategory.h"

@class SWMarketCategoryViewController;
@protocol SWMarketCategoryViewControllerDelegate<NSObject>
- (void)marketCategoryVC:(SWMarketCategoryViewController *)vc didClickMarketCategory:(SWMarketCategory *)marketCategory;
- (void)marketCategoryVC:(SWMarketCategoryViewController *)vc didUpdateMarketCategory:(SWMarketCategory *)marketCategory;
- (void)marketCategoryVC:(SWMarketCategoryViewController *)vc didDeleteMarketCategory:(SWMarketCategory *)marketCategory;
@end

@interface SWMarketCategoryViewController : UIViewController
@property(nonatomic, strong) UITableView *marketCategoryTableView;
@property(nonatomic, weak) id<SWMarketCategoryViewControllerDelegate> delegate;
@property(nonatomic, assign) BOOL isEditing;
@end
