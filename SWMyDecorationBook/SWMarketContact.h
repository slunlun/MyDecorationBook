//
//  SWMarketContact.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/4/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWShopContact+CoreDataClass.h"

@interface SWMarketContact : NSObject
- (instancetype)initWithMO:(SWShopContact *)contact;
@property(nonatomic, strong) NSString *itemID;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *telNum;
@property(nonatomic, assign, getter=isDefaultContact) BOOL defaultContact;
@property(nonatomic, strong) NSDate *createTime;
@end
