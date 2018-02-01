//
//  SWPriceUnitStorage.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/18/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWPriceUnitStorage : NSObject
+ (void)insertPriceUnit:(NSString *)priceUnit;
+ (void)removePriceUnit:(NSString *)priceUnit;
+ (NSArray *)allPriceUnit;
@end
