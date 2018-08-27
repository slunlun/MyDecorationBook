//
//  SWItemUnit.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/17/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWItemUnit.h"

@implementation SWItemUnit
- (instancetype)initWithMO:(SWPriceUnit *)priceUnit {
    if (self = [super init]) {
        _unitTitle = priceUnit.unit;
    }
    return self;
}

@end
