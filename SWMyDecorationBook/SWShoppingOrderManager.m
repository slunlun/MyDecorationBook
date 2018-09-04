//
//  SWShoppingOrderManager.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/1.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWShoppingOrderManager.h"
#import "SWProductOrderStorage.h"
@interface SWShoppingOrderCategoryModle()
@end

@implementation SWShoppingOrderCategoryModle
- (id)copyWithZone:(NSZone *)zone {
    SWShoppingOrderCategoryModle *other = [[SWShoppingOrderCategoryModle alloc] init];
    other.orderCategoryName = [self.orderCategoryName copy];
    other.orderCategoryID = [self.orderCategoryID copy];
    other.totalCost = self.totalCost;
    return other;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[SWShoppingOrderCategoryModle class]]) {
        if ([((SWShoppingOrderCategoryModle *)object).orderCategoryID isEqualToString:self.orderCategoryID]) {
            return YES;
        }
    }
    return NO;
}

- (NSUInteger)hash {
    return [self.orderCategoryID hash];
}
@end


static SWShoppingOrderManager *sharedObj = nil;

@interface SWShoppingOrderManager()
@property(nonatomic, strong) NSMutableArray<NSDictionary *> *shoppingOrderInCategoryArray;
@end

@implementation SWShoppingOrderManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObj = [[SWShoppingOrderManager alloc] init];
    });
    return sharedObj;
}

- (CGFloat)totalCost {
    NSArray *allOrders = [SWProductOrderStorage allProductOrders];
    CGFloat totalCost = 0;
    for (SWOrder *order in allOrders) {
        totalCost += order.orderTotalPrice;
    }
    return totalCost;
}

- (NSArray *)loadData {
    NSArray *allOrders = [SWProductOrderStorage allProductOrders];
    NSMutableArray *ordersInCategoryArray = [[NSMutableArray alloc] init];
    CGFloat totalCost = 0.0f;
    for(SWOrder *order in allOrders) {
        @autoreleasepool{
            SWMarketItem *marketItem = order.marketItem;
            SWShoppingOrderCategoryModle *tempMode = [[SWShoppingOrderCategoryModle alloc] init];
            tempMode.orderCategoryID = marketItem.marketCategory.itemID;
            tempMode.orderCategoryName = marketItem.marketCategory.categoryName;
            tempMode.totalCost = order.orderTotalPrice;
            totalCost += order.orderTotalPrice;
            BOOL orderExisted = NO;
            for (NSDictionary *dictNode in ordersInCategoryArray) {
                SWShoppingOrderCategoryModle *orderCategoryModle = [dictNode allKeys].firstObject;
                if ([orderCategoryModle.orderCategoryID isEqualToString:tempMode.orderCategoryID]) { // 队列中已经存在该category
                    // 更新 totalCost
                    orderCategoryModle.totalCost += tempMode.totalCost;
                    NSMutableArray *orderArray = [dictNode objectForKey:orderCategoryModle];
                    [orderArray addObject:order];
                    orderExisted = YES;
                }
            }
            if (!orderExisted) {
                 // 队列中没有该category
                // 组装节点
                NSMutableArray *orderArray = [NSMutableArray arrayWithObject:order];
                NSDictionary *dic = @{tempMode:orderArray};
                // 插入
                [ordersInCategoryArray addObject:dic];
            }
            
            // 将order 插入到当前category下面
        
        }
    } // end for(SWOrder *order in allOrders)
    self.shoppingOrderInCategoryArray = ordersInCategoryArray;
    // 计算每个商品种类 所占的消费比
    for (NSDictionary *infoDict in self.shoppingOrderInCategoryArray) {
        SWShoppingOrderCategoryModle *model = infoDict.allKeys.firstObject;
        model.costPercent = model.totalCost / totalCost;
    }
    return self.shoppingOrderInCategoryArray;
}

- (NSArray *)loadOrdersInCategory:(SWShoppingOrderCategoryModle *)categoryModel {
    NSArray *retArray = nil;
    NSArray *shoppingOrderInCategoryArray = [self loadData];
    for (NSDictionary *info in shoppingOrderInCategoryArray) {
        SWShoppingOrderCategoryModle *orderCategory = info.allKeys.firstObject;
        if ([orderCategory isEqual:categoryModel]) {
            retArray = info[orderCategory];
        }
    }
    return retArray;
}

- (void)insertNewOrder:(SWOrder *)shoppingOrder {
    [SWProductOrderStorage insertNewProductOrder:shoppingOrder];
    [self loadData];
}

- (void)removeShoppingOrder:(SWOrder *)shoppingOrder {
    [SWProductOrderStorage removeProductOrder:shoppingOrder];
    [self loadData];
}


@end
