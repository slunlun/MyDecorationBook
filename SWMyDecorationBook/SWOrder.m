//
//  SWOrder.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/4/19.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWOrder.h"

@implementation SWOrder
- (instancetype)init {
    if (self = [super init]) {
        _orderDate = [NSDate date];
    }
    return self;
}
@end
