//
//  SWOrder.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/4/19.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWProductItem.h"
#import "SWMarketItem.h"
#import "SWShoppingItemOrder+CoreDataClass.h"
@interface SWOrder : NSObject
- (instancetype)initWithMO:(SWShoppingItemOrder *)mo;
@property(nonatomic, strong) NSString *orderID;
@property(nonatomic, strong) SWProductItem *productItem;
@property(nonatomic, strong) SWMarketItem *marketItem;
@property(nonatomic, assign) CGFloat itemCount;
@property(nonatomic, assign) CGFloat orderTotalPrice;
@property(nonatomic, strong) NSDate *orderDate;
@property(nonatomic, strong) NSString *orderRemark;
@end
