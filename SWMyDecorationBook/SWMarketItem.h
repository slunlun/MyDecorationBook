//
//  SWMarketItem.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/2/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWMarketCategory.h"
#import "SWShop+CoreDataClass.h"
@interface SWMarketItem : NSObject
- (instancetype)initWithMO:(SWShop *)MO;
@property(nonatomic, strong) NSString *itemID;
@property(nonatomic, strong) NSString *marketName;
@property(nonatomic, strong) NSMutableArray *telNums;  // 联系方式(可多个)
@property(nonatomic, strong) NSString *defaultTelNum;
@property(nonatomic, strong) NSMutableArray *shoppingItems;
@property(nonatomic, strong) NSDate *createTime;
@property(nonatomic, strong) SWMarketCategory *marketCategory;
@end
