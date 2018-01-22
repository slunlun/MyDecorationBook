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
        SWShop *newShop = [SWShop MR_createEntityInContext:localContext];
        
//        @property (nullable, nonatomic, copy) NSDate *createTime;
//        @property (nullable, nonatomic, copy) NSString *itemIndex;
//        @property (nullable, nonatomic, copy) NSString *name;
//        @property (nullable, nonatomic, retain) SWShoppingCategory *shopCategory;
//        @property (nullable, nonatomic, retain) NSSet<SWShopContact *> *shopContacts;
//        @property (nullable, nonatomic, retain) NSSet<SWShoppingItem *> *shopItems;
        newShop.createTime = [NSDate date];
        newShop.itemIndex = [[NSUUID UUID] UUIDString];
        newShop.name = shop.marketName;
        NSPredicate *categoryPredicate = [NSPredicate predicateWithFormat:@"name==%@", shop.marketCategory.categoryName];
        SWShoppingCategory *shoppingCategory = [SWShoppingCategory MR_findFirstWithPredicate:categoryPredicate inContext:localContext];
       
        [shoppingCategory addShopsObject:newShop];
        newShop.shopCategory = shoppingCategory;
        
        for (SWMarketContact *contact in shop.telNums) {
//            @property (nullable, nonatomic, copy) NSDate *createTime;
//            @property (nonatomic) BOOL isDefaultContact;
//            @property (nullable, nonatomic, copy) NSString *itemIndex;
//            @property (nullable, nonatomic, copy) NSString *name;
//            @property (nullable, nonatomic, copy) NSString *telNum;
//            @property (nullable, nonatomic, retain) SWShop *shop;
            SWShopContact *newContact = [SWShopContact MR_createEntityInContext:localContext];
            newContact.createTime = [NSDate date];
            newContact.isDefaultContact = contact.isDefaultContact;
            newContact.itemIndex = [[NSUUID UUID] UUIDString];
            newContact.name = contact.name;
            newContact.telNum = contact.telNum;
            newContact.shop = newShop;
            [newShop addShopContactsObject:newContact];
        }
        
        
    }];
}

+ (void)removeMarket:(SWMarketItem *)shop {
    
}

+ (void)updateMarket:(SWMarketItem *)shop {
    
}

+ (NSArray *)allMarketInCategory:(SWMarketCategory *)marketCatagroy {
    NSArray *shops = [SWShop MR_findAll];
    NSMutableArray *allMarket = [NSMutableArray new];
    for (SWShop *shop in shops) {
        SWMarketItem *marketItem = [[SWMarketItem alloc] init];
//        @property(nonatomic, strong) NSString *marketName;
//        @property(nonatomic, strong) NSArray *telNums;  // 联系方式(可多个)
//        @property(nonatomic, strong) NSNumber *defaultTelNum;
//        @property(nonatomic, strong) NSArray *shoppingItems;
//        @property(nonatomic, strong) NSDate *createTime;
//        @property(nonatomic, strong) SWMarketCategory *marketCategory;
        marketItem.marketName = shop.name;
        marketItem.itemID = shop.itemIndex;
        marketItem.createTime = shop.createTime;
        
        SWMarketCategory *category = [[SWMarketCategory alloc] init];
        category.categoryName = shop.shopCategory.name;
        marketItem.marketCategory = category;
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:YES];
        NSArray *sortDescriptors = @[sortDescriptor];
        NSArray *shopContacts = [shop.shopContacts sortedArrayUsingDescriptors:sortDescriptors];
        for (SWShopContact *shopContact in shopContacts) {
            SWMarketContact *marketContact = [[SWMarketContact alloc] init];
            marketContact.name = shopContact.name;
            marketContact.telNum = shopContact.telNum;
            marketContact.createTime = shopContact.createTime;
            marketContact.defaultContact = shopContact.isDefaultContact;
            [marketItem.telNums addObject:marketContact];
        }
        [allMarket addObject:marketItem];
    }
    return allMarket;
    
}
@end
