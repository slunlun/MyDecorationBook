//
//  SWMarketCategoryStorage.h
//  SWMyDecorationBook
//
//  Created by ShiTeng on 2018/2/5.
//  Copyright © 2018年 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWMarketCategory.h"

@interface SWMarketCategoryStorage : NSObject
+ (void)insertMarketCategory:(SWMarketCategory *)marketCategory;
+ (void)updateMarketCategory:(SWMarketCategory *)marketCategory;
+ (void)removeMarkeetCategory:(SWMarketCategory *)marketCategory;
+ (NSArray<SWMarketCategory *> *)allMarketCategory;
@end
