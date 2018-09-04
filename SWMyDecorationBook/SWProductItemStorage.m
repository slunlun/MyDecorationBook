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
#import "SWProductPhoto.h"


@implementation SWProductItemStorage
+ (void)insertProductItem:(SWProductItem *)productItem toMarket:(SWMarketItem *)market {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemID==%@", productItem.itemID];
        SWShoppingItem *shopItem = [SWShoppingItem MR_findFirstWithPredicate:predicate inContext:localContext];
        if (shopItem == nil) {
            shopItem = [SWShoppingItem MR_createEntityInContext:localContext];
        }

        // 商品基本信息
        shopItem.createTime = productItem.createTime;
        shopItem.itemID = productItem.itemID;
        shopItem.name = productItem.productName;
        shopItem.price = productItem.price;
        shopItem.remark = productItem.productRemark;
        
        // 价格单位
        predicate = [NSPredicate predicateWithFormat:@"itemID==%@", productItem.itemUnit.itemID];
        SWPriceUnit *priceUnit = [SWPriceUnit MR_findFirstWithPredicate:predicate inContext:localContext];
        shopItem.itemUnit = priceUnit;
        [priceUnit addShopItemsObject:shopItem];
        
        // 所属商铺
        predicate = [NSPredicate predicateWithFormat:@"itemID==%@", market.itemID];
        SWShop *shop = [SWShop MR_findFirstWithPredicate:predicate inContext:localContext];
        [shop addShopItemsObject:shopItem];
        shopItem.shop = shop;
        
        
        NSMutableArray *localPhotos = [[NSMutableArray alloc] initWithArray:productItem.productPhotos];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:YES];
        NSMutableArray *DBPhotos = [[NSMutableArray alloc] initWithArray:[shopItem.itemPhotos sortedArrayUsingDescriptors:@[sortDescriptor]]];
        // 商品照片
        for (SWShoppingPhoto *photo in shopItem.itemPhotos) {
            for (SWProductPhoto *productPhoto in productItem.productPhotos) {
                if ([photo.itemID isEqualToString:productPhoto.itemID]) {
                    [DBPhotos removeObject:photo];
                    [localPhotos removeObject:productPhoto];
                }
            }
        }
        
        // 删除多余的照片
        for (SWShoppingPhoto *shopPhoto in DBPhotos) {
            [shopPhoto MR_deleteEntityInContext:localContext];
        }
        
        // 添加新的照片
        for (SWProductPhoto *productPhoto in localPhotos) {
            SWShoppingPhoto *newPhoto = [SWShoppingPhoto MR_createEntityInContext:localContext];
            newPhoto.itemID = productPhoto.itemID;
            newPhoto.createTime = productPhoto.createTime;
            newPhoto.image = UIImagePNGRepresentation(productPhoto.photo);
            newPhoto.shopItem = shopItem;
            [shopItem addItemPhotosObject:newPhoto];
        }
        
        
    }];
}

+ (void)updateProductItem:(SWProductItem *)productItem {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemID==%@", productItem.itemID];
        SWShoppingItem *shopItem = [SWShoppingItem MR_findFirstWithPredicate:predicate inContext:localContext];
        if (shopItem) {
            // 商品基本信息
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
            
            NSMutableArray *localPhotos = [[NSMutableArray alloc] initWithArray:productItem.productPhotos];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:YES];
            NSMutableArray *DBPhotos = [[NSMutableArray alloc] initWithArray:[shopItem.itemPhotos sortedArrayUsingDescriptors:@[sortDescriptor]]];
            // 商品照片
            for (SWShoppingPhoto *photo in shopItem.itemPhotos) {
                for (SWProductPhoto *productPhoto in productItem.productPhotos) {
                    if ([photo.itemID isEqualToString:productPhoto.itemID]) {
                        [DBPhotos removeObject:photo];
                        [localPhotos removeObject:productPhoto];
                    }
                }
            }
            
            // 删除多余的照片
            for (SWShoppingPhoto *shopPhoto in DBPhotos) {
                [shopPhoto MR_deleteEntityInContext:localContext];
            }
            
            // 添加新的照片
            for (SWProductPhoto *productPhoto in localPhotos) {
                SWShoppingPhoto *newPhoto = [SWShoppingPhoto MR_createEntityInContext:localContext];
                newPhoto.itemID = productPhoto.itemID;
                newPhoto.createTime = productPhoto.createTime;
                newPhoto.image = UIImagePNGRepresentation(productPhoto.photo);
                newPhoto.shopItem = shopItem;
                [shopItem addItemPhotosObject:newPhoto];
            }
        }
    }];
}

+ (void)removeProductItem:(SWProductItem *)productItem {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemID==%@", productItem.itemID];
        SWShoppingItem *shopItem = [SWShoppingItem MR_findFirstWithPredicate:predicate inContext:localContext];
        [shopItem MR_deleteEntityInContext:localContext];
    }];
}
@end
