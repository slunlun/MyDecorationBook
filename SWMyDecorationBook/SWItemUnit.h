//
//  SWItemUnit.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/17/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWPriceUnit+CoreDataClass.h"

@interface SWItemUnit : NSObject<NSCopying>
- (instancetype)initWithMO:(SWPriceUnit *)priceUnit;
- (instancetype)initWithUnit:(NSString *)unit;
@property(nonatomic, strong) NSString *unitTitle;
@property(nonatomic, readonly, strong) NSString *itemID;
@property(nonatomic, assign) BOOL shopItemAssociated;
@end
