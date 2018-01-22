//
//  SWMarketContactStorage.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/18/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWMarketContact.h"

@interface SWMarketContactStorage : NSObject
+ (void)insertMarketContact:(SWMarketContact *)contact;
+ (void)removeMarketContact:(SWMarketContact *)contact;
+ (void)updateMarketContact:(SWMarketContact *)contact;

@end
