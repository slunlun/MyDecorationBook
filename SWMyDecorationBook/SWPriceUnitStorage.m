//
//  SWPriceUnitStorage.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/18/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWPriceUnitStorage.h"
#import "MagicalRecord.h"
#import "SWPriceUnit+CoreDataClass.h"
#import "SWItemUnit.h"

@implementation SWPriceUnitStorage
+ (void)insertPriceUnit:(NSString *)unit {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        SWPriceUnit *priceUnit = [SWPriceUnit MR_createEntityInContext:localContext];
        priceUnit.unit = unit;
        
    }];
}

+ (void)removePriceUnit:(NSString *)unit {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"unit==%@", unit];
        [SWPriceUnit MR_deleteAllMatchingPredicate:predicate inContext:localContext];
    }];
}

+ (NSArray *)allPriceUnit {
    __block NSMutableArray *retArray = [[NSMutableArray alloc] init];
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSArray *priceUnits = [SWPriceUnit MR_findAllInContext:localContext];
        for (SWPriceUnit *priceUnit in priceUnits) {
            SWItemUnit *itemUnit = [[SWItemUnit alloc] initWithMO:priceUnit];
            [retArray addObject:itemUnit];
        }
    }];
    return retArray;
}
@end
