//
//  SWProductOrderStorage.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/4/26.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWOrder.h"

@interface SWProductOrderStorage : NSObject
+ (void)insertNewProductOrder:(SWOrder *)newOrder;
+ (void)removeProductOrder:(SWOrder *)order;
+ (void)removeProductOrderByOrderItemID:(NSString *)itemID;
+ (void)removeProductOrderByProduct:(SWProductItem *)productItem;
+ (void)updateProductOrder:(SWOrder *)order;
+ (SWOrder *)productOrderByOrderID:(NSString *)orderID;
+ (NSArray<SWOrder *>*)allProductOrders;
@end
