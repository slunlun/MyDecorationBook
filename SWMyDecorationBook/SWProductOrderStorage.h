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
+ (void)updateProductOrder:(SWOrder *)order;
+ (NSArray<SWOrder *>*)allProductOrders;
@end
