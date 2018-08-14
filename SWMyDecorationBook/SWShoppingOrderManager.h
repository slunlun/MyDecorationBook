//
//  SWShoppingOrderManager.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/1.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWOrder.h"
@interface SWShoppingOrderCategoryModle : NSObject<NSCopying>
@property(nonatomic, strong) NSString *orderCategoryID;
@property(nonatomic, strong) NSString *orderCategoryName;
@property(nonatomic, assign) CGFloat totalCost;
@property(nonatomic, assign) CGFloat costPercent;
@end



@interface SWShoppingOrderManager : NSObject
+ (instancetype)sharedInstance;

- (NSArray *)loadData; // 初始化订单汇总信息, 在调用其他方法前，请务必调用该函数
- (NSArray *)loadOrdersInCategory:(SWShoppingOrderCategoryModle *)categoryModel;
- (void)insertNewOrder:(SWOrder *)shoppingOrder;
- (void)removeShoppingOrder:(SWOrder *)shoppingOrder;
@end
