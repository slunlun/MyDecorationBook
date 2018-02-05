//
//  SWProductItemStorage.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/18/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWProductItem.h"
#import "SWMarketItem.h"

@interface SWProductItemStorage : NSObject
+ (void)insertProductItem:(SWProductItem *)productItem toMarket:(SWMarketItem *)market;
+ (void)updateProductItem:(SWProductItem *)productItem;
+ (void)removeProductItem:(SWProductItem *)productItem;
@end
