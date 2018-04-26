//
//  SWProductOrderStorage.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/4/26.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWProductOrderStorage.h"
#import "MagicalRecord.h"
#import "SWShoppingItemOrder+CoreDataClass.h"
#import "SWShoppingItem+CoreDataClass.h"

@implementation SWProductOrderStorage
+ (void)insertNewProductOrder:(SWOrder *)newOrder {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        // 订单基本信息
        SWShoppingItemOrder *newShoppingItemOrder = [SWShoppingItemOrder MR_createEntityInContext:localContext];
        newShoppingItemOrder.createTime = newOrder.orderDate;
        newShoppingItemOrder.remark = newOrder.orderRemark;
        newShoppingItemOrder.totalCount = newOrder.itemCount;
        newShoppingItemOrder.totalPrice = newOrder.orderTotalPrice;
        // 建立订单和所定商品的关系
        NSPredicate *shoppingItemPredicate = [NSPredicate predicateWithFormat:@"itemID==%@", newOrder.productItem.itemID];
        SWShoppingItem* shoppingItem = [SWShoppingItem MR_findFirstWithPredicate:shoppingItemPredicate inContext:localContext];
        [shoppingItem addOwnnerOrderObject:newShoppingItemOrder];
        [newShoppingItemOrder setShopItem:shoppingItem];
    }];
}

+ (void)removeProductOrder:(SWOrder *)order {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemID==%@", order.orderID];
        [SWShoppingItemOrder MR_deleteAllMatchingPredicate:predicate inContext:localContext];
    }];
}

+ (void)updateProductOrder:(SWOrder *)order {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemID==%@", order.orderID];
        SWShoppingItemOrder *shoppingItemOrder = [SWShoppingItemOrder MR_findFirstWithPredicate:predicate inContext:localContext];
        if (shoppingItemOrder) {
            // 更新基本信息
            shoppingItemOrder.totalPrice = order.orderTotalPrice;
            shoppingItemOrder.totalCount = order.itemCount;
            shoppingItemOrder.remark = order.orderRemark;
        }
    }];
}

+ (NSArray<SWOrder *>*)allProductOrders {
    __block NSMutableArray *allProductOrders = [[NSMutableArray alloc] init];
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSArray *allOrders = [SWShoppingItemOrder MR_findAllInContext:localContext];
        for (SWShoppingItemOrder *shoppingOrder in allOrders) {
            SWOrder *order = [[SWOrder alloc] initWithMO:shoppingOrder];
            [allProductOrders addObject:order];
        }
    }];
    return allProductOrders;
}
@end
