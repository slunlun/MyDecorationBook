//
//  SWMarketStorage.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/18/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWMarketStorage.h"
#import "SWShop+CoreDataClass.h"
#import "SWShoppingCategory+CoreDataClass.h"
#import "SWShopContact+CoreDataClass.h"
#import "MagicalRecord.h"
#import "SWMarketContact.h"

@implementation SWMarketStorage
+ (void)insertMarket:(SWMarketItem *)shop {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        // 商铺基本信息
        SWShop* newShop = nil;
        NSPredicate *shopPredicate = [NSPredicate predicateWithFormat:@"itemID==%@", shop.itemID];
        newShop = [SWShop MR_findFirstWithPredicate:shopPredicate inContext:localContext];
        if (newShop == nil) {
            newShop = [SWShop MR_createEntityInContext:localContext];
        }
        
        newShop.createTime = [NSDate date];
        newShop.itemID = [[NSUUID UUID] UUIDString];
        newShop.name = shop.marketName;
//        // 将商铺添加到当前分类下
//        NSPredicate *categoryPredicate = [NSPredicate predicateWithFormat:@"name==%@", shop.marketCategory.categoryName];
//        SWShoppingCategory *shoppingCategory = [SWShoppingCategory MR_findFirstWithPredicate:categoryPredicate inContext:localContext];
//        [shoppingCategory addShopsObject:newShop];
//        newShop.shopCategory = shoppingCategory;
        // 商铺联系人
        for (SWMarketContact *contact in shop.telNums) {
            SWShopContact *newContact = [SWShopContact MR_createEntityInContext:localContext];
            newContact.createTime = [NSDate date];
            newContact.isDefaultContact = contact.isDefaultContact;
            newContact.itemID = [[NSUUID UUID] UUIDString];
            newContact.name = contact.name;
            newContact.telNum = contact.telNum;
            newContact.shop = newShop;
            [newShop addShopContactsObject:newContact];
        }
    }];
}

+ (void)removeMarket:(SWMarketItem *)shop {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        
    }];
}

+ (void)updateMarket:(SWMarketItem *)shop {
    
}

+ (NSArray *)allMarketInCategory:(SWMarketCategory *)marketCatagroy {
    NSArray *shops = [SWShop MR_findAll];
    NSMutableArray *allMarket = [NSMutableArray new];
    for (SWShop *shop in shops) {
        
        SWMarketItem *marketItem = [[SWMarketItem alloc] initWithMO:shop];
        [allMarket addObject:marketItem];
    }
    return allMarket;
    
}
@end
