//
//  SWOrder.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/4/19.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWProductItem.h"
@interface SWOrder : NSObject
@property(nonatomic, strong) SWProductItem *productItem;
@property(nonatomic, strong) NSNumber *itemCount;
@property(nonatomic, strong) NSNumber *orderTotalPrice;
@property(nonatomic, strong) NSDate *orderDate;
@property(nonatomic, strong) NSString *orderRemark;
@end
