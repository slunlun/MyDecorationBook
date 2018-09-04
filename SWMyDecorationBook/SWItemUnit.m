//
//  SWItemUnit.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/17/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWItemUnit.h"
@interface SWItemUnit()
@property(nonatomic, readwrite, strong) NSString *itemID;
@end

@implementation SWItemUnit
- (instancetype)initWithMO:(SWPriceUnit *)priceUnit {
    if (self = [super init]) {
        _unitTitle = priceUnit.unit;
        _itemID = priceUnit.itemID;
        if (priceUnit.shopItems.count) {
            _shopItemAssociated = YES;
        }else {
            _shopItemAssociated = NO;
        }
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        _itemID = [[NSUUID UUID] UUIDString];
    }
    return self;
}

- (instancetype)initWithUnit:(NSString *)unit {
    if (self = [super init]) {
        _itemID = [[NSUUID UUID] UUIDString];
        _unitTitle = unit;
    }
    return self;
}
#pragma mark - Equal
- (BOOL)isEqual:(id)object {
    if ([((SWItemUnit *)object).itemID isEqualToString:self.itemID]) {
        return YES;
    }else {
        return NO;
    }
}

- (NSUInteger)hash {
    return [self.itemID hash];
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    SWItemUnit *itemUnit = [[SWItemUnit alloc] init];
    itemUnit.itemID = [self.itemID copyWithZone:zone];
    itemUnit.unitTitle = [self.unitTitle copyWithZone:zone];
    itemUnit.shopItemAssociated = self.shopItemAssociated;
    return itemUnit;
}

@end
