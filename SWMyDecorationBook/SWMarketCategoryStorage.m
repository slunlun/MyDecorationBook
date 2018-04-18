//
//  SWMarketCategoryStorage.m
//  SWMyDecorationBook
//
//  Created by ShiTeng on 2018/2/5.
//  Copyright © 2018年 Eren. All rights reserved.
//

#import "SWMarketCategoryStorage.h"
#import "MagicalRecord.h"
#import "SWShoppingCategory+CoreDataClass.h"

@implementation SWMarketCategoryStorage
+ (void)insertMarketCategory:(SWMarketCategory *)marketCategory {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemID==%@", marketCategory.itemID];
        SWShoppingCategory *shoppingCategory = [SWShoppingCategory MR_findFirstWithPredicate:predicate inContext:localContext];
        if (shoppingCategory == nil) {
            shoppingCategory = [SWShoppingCategory MR_createEntityInContext:localContext];
        }
        shoppingCategory.arrangeIndex = marketCategory.indexNum;
        shoppingCategory.createTime = marketCategory.createTime;
        shoppingCategory.name = marketCategory.categoryName;
        shoppingCategory.itemID = marketCategory.itemID;
    }];
}

+ (void)updateMarketCategory:(SWMarketCategory *)marketCategory {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemID==%@", marketCategory.itemID];
        SWShoppingCategory *shoppingCategory = [SWShoppingCategory MR_findFirstWithPredicate:predicate inContext:localContext];
        if (shoppingCategory != nil) {
            shoppingCategory.arrangeIndex = marketCategory.indexNum;
            shoppingCategory.createTime = marketCategory.createTime;
            shoppingCategory.name = marketCategory.categoryName;
        }
    }];
}

+ (void)removeMarkeetCategory:(SWMarketCategory *)marketCategory {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemID==%@", marketCategory.itemID];
        SWShoppingCategory *shoppingCategory = [SWShoppingCategory MR_findFirstWithPredicate:predicate inContext:localContext];
        [shoppingCategory MR_deleteEntityInContext:localContext];
    }];
}

+ (NSArray<SWMarketCategory *> *)allMarketCategory {
    NSMutableArray *retArray = [NSMutableArray new];
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSArray *DBCategories = [SWShoppingCategory MR_findAllInContext:localContext];
        for (SWShoppingCategory* shoppingCategory in  DBCategories) {
            SWMarketCategory *marketCategory = [[SWMarketCategory alloc] initWithMO:shoppingCategory];
            [retArray addObject:marketCategory];
        }
    }];
    return retArray;
}
@end
