//
//  SWShoppingOrderManager.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/1.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWOrder.h"
@interface SWShoppingOrderCategoryMode : NSObject
@property(nonatomic, strong) NSString *orderCategoryID;
@property(nonatomic, strong) NSString *orderCategoryName;
@property(nonatomic, assign) CGFloat totalCost;
@property(nonatomic, assign) CGFloat orderPercent;
@end


@interface SWShoppingOrderManager : NSObject
+ (instancetype)sharedInstance;

- (void)bootUp; // 初始化订单信息汇总, 在调用其他方法前，请务必调用该函数
- (void)insertNewOrder:(SWOrder *)shoppingOrder;
- (void)removeShoppingOrder:(SWOrder *)shoppingOrder;

- (NSArray *)allOrdersInCategory;
@end
