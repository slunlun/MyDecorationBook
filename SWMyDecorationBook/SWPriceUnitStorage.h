//
//  SWPriceUnitStorage.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/18/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWItemUnit.h"
@interface SWPriceUnitStorage : NSObject
+ (void)insertPriceUnit:(SWItemUnit *)priceUnit;
+ (void)removePriceUnit:(SWItemUnit *)priceUnit;
+ (void)updatePriceUnit:(SWItemUnit *)priceUnit;
+ (NSArray *)allPriceUnit;
@end
