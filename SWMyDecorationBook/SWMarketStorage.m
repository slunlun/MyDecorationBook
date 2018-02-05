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
        NSPredicate *categoryPredicate = [NSPredicate predicateWithFormat:@"itemID==%@", shop.marketCategory.itemID];
        SWShoppingCategory *shoppingCategory = [SWShoppingCategory MR_findFirstWithPredicate:categoryPredicate inContext:localContext];
        [shoppingCategory addShopsObject:newShop];
        newShop.shopCategory = shoppingCategory;
        // 商铺联系人
        NSMutableArray *localContacts = [[NSMutableArray alloc] initWithArray:shop.telNums];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:YES];
        NSMutableArray *DBContacts = [[NSMutableArray alloc] initWithArray:[newShop.shopContacts sortedArrayUsingDescriptors:@[sortDescriptor]]];
        // 商品照片
        for (SWShopContact *shopContact in newShop.shopContacts) {
            for (SWMarketContact *marketContact in shop.telNums) {
                if ([shopContact.itemID isEqualToString:marketContact.itemID]) {
                    [DBContacts removeObject:shopContact];
                    [localContacts removeObject:marketContact];
                }
            }
        }
        
        // 删除多余的照片
        for (SWShopContact *shopContact in DBContacts) {
            [shopContact MR_deleteEntityInContext:localContext];
        }
        
        // 添加新的照片
        for (SWMarketContact *marketContact in localContacts) {
            SWShopContact *newShopContact = [SWShopContact MR_createEntityInContext:localContext];
            newShopContact.itemID = marketContact.itemID;
            newShopContact.createTime = marketContact.createTime;
            newShopContact.isDefaultContact = marketContact.isDefaultContact;
            newShopContact.name = marketContact.name;
            newShopContact.telNum = marketContact.telNum;
            newShopContact.shop = newShop;
            [newShop addShopContactsObject:newShopContact];
            
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
    
    __block NSMutableArray *allMarket = [NSMutableArray new];
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSArray *shops = [SWShop MR_findAllInContext:localContext];
        for (SWShop *shop in shops) {
            SWMarketItem *marketItem = [[SWMarketItem alloc] initWithMO:shop];
            [allMarket addObject:marketItem];
        }
    }];
   
    return allMarket;
    
}
@end
