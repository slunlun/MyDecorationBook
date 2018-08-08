//
//  SWOrderListinCategoryViewController.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/8.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWShoppingOrderManager.h"

@interface SWOrderListinCategoryViewController : UIViewController
- (instancetype)initWithOrderList:(NSArray *)orderList inShoppingCategory:(SWShoppingOrderCategoryModle *)orderCategory;
@end
