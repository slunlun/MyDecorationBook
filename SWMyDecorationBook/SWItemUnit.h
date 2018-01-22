//
//  SWItemUnit.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/17/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWPriceUnit+CoreDataClass.h"

@interface SWItemUnit : NSObject
- (instancetype)initWithMO:(SWPriceUnit *)priceUnit;
@property(nonatomic, strong) NSString *unitTitle;
@property(nonatomic, strong) NSArray *shoppingItems;
@end
