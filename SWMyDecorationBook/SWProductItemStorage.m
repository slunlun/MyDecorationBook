//
//  SWProductItemStorage.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/18/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWProductItemStorage.h"
#import "MagicalRecord.h"
#import "SWShoppingItem+CoreDataClass.h"
#import "SWPriceUnit+CoreDataClass.h"
#import "SWShop+CoreDataClass.h"
#import "SWShoppingPhoto+CoreDataClass.h"


@implementation SWProductItemStorage
+ (void)insertProductItem:(SWProductItem *)productItem toMarket:(SWMarketItem *)market {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemID==%@", productItem.itemID];
        SWShoppingItem *shopItem = [SWShoppingItem MR_findFirstWithPredicate:predicate inContext:localContext];
        if (shopItem == nil) {
            shopItem = [SWShoppingItem MR_createEntityInContext:localContext];
        }
//        @property (nonatomic) BOOL choosed;
//        @property (nullable, nonatomic, copy) NSDate *createTime;
//        @property (nullable, nonatomic, copy) NSString *itemID;
//        @property (nullable, nonatomic, copy) NSString *name;
//        @property (nonatomic) float price;
//        @property (nullable, nonatomic, copy) NSString *remark;
        
//        @property (nullable, nonatomic, retain) NSSet<SWShoppingPhoto *> *itemPhotos;
//        @property (nullable, nonatomic, retain) SWPriceUnit *itemUnit;
//        @property (nullable, nonatomic, retain) SWShop *shop;
        // 商品基本信息
        shopItem.choosed = productItem.choosed;
        shopItem.createTime = productItem.createTime;
        shopItem.itemID = productItem.itemID;
        shopItem.name = productItem.productName;
        shopItem.price = productItem.price;
        shopItem.remark = productItem.productRemark;
        
        // 价格单位
        predicate = [NSPredicate predicateWithFormat:@"unit==%@", productItem.itemUnit.unitTitle];
        SWPriceUnit *priceUnit = [SWPriceUnit MR_findFirstWithPredicate:predicate inContext:localContext];
        shopItem.itemUnit = priceUnit;
        [priceUnit addShopItemsObject:shopItem];
        
        // 所属商铺
        predicate = [NSPredicate predicateWithFormat:@"itemID==%@", market.itemID];
        SWShop *shop = [SWShop MR_findFirstWithPredicate:predicate inContext:localContext];
        [shop addShopItemsObject:shopItem];
        shopItem.shop = shop;
        
        // 商品照片
//        NSArray *shopPhotos = [shopItem.itemPhotos allObjects];
//        for (SWShoppingPhoto *photo in shopPhotos) {
//            sho
//        }
        
        //TODO
        
        
    }];
}

+ (void)removeProductItem:(SWProductItem *)productItem {
    
}
@end
