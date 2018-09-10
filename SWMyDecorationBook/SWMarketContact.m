//
//  SWMarketContact.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/4/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWMarketContact.h"

@implementation SWMarketContact
//@property(nonatomic, strong) NSString *name;
//@property(nonatomic, strong) NSString *telNum;
//@property(nonatomic, assign, getter=isDefaultContact) BOOL defaultContact;
//@property(nonatomic, strong) NSDate *createTime;
- (instancetype)init {
    if (self = [super init]) {
        _createTime = [NSDate date];
        _itemID = [[NSUUID UUID] UUIDString];
    }
    return self;
}
- (instancetype)initWithMO:(SWShopContact *)contact {
    if (self = [super init]) {
        _name = contact.name;
        _telNum = contact.telNum;
        _defaultContact = contact.isDefaultContact;
        _createTime = contact.createTime;
        _itemID = contact.itemID;
        _contactIdentify = contact.contactIdentify;
    }
    return self;
}

- (NSUInteger)hash {
    return [self.itemID hash];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[SWMarketContact class]]) {
        if ([((SWMarketContact *)object).itemID isEqualToString:self.itemID]) {
            return YES;
        }
    }
    return NO;
}
@end
