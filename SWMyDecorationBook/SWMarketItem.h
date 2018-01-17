//
//  SWMarketItem.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/2/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWMarketItem : NSObject
@property(nonatomic, strong) NSString *marketName;
@property(nonatomic, strong) NSArray *telNums;  // 联系方式(可多个)
@property(nonatomic, strong) NSNumber *defaultTelNum;
@property(nonatomic, strong) NSArray *shoppingItems;
@property(nonatomic, strong) NSDate *createTime;
@end
