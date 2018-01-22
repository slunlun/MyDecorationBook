//
//  SWMarketStorage.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/18/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWMarketItem.h"
#import "SWMarketCategory.h"

@interface SWMarketStorage : NSObject
+ (void)insertMarket:(SWMarketItem *)shop;
+ (void)removeMarket:(SWMarketItem *)shop;
+ (void)updateMarket:(SWMarketItem *)shop;
+ (NSArray *)allMarketInCategory:(SWMarketCategory *)marketCatagroy;
@end
