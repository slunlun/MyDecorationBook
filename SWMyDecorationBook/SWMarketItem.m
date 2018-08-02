//
//  SWMarketItem.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/2/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWMarketItem.h"
#import "SWShoppingCategory+CoreDataClass.h"
#import "SWMarketContact.h"
#import "SWShopContact+CoreDataClass.h"
#import "SWProductItem.h"

@implementation SWMarketItem
#pragma mark - Init

- (instancetype)initWithMarketCategory:(SWMarketCategory *)marketCategory {
    if (self = [super init]) {
        _itemID = [[NSUUID UUID] UUIDString];
        _createTime = [NSDate date];
        _marketCategory = marketCategory;
    }
    return self;
}

- (instancetype)init {
    NSAssert(NO, @"SWMarketItem use (instancetype)initWithMarketCategory:(SWMarketCategory *)marketCategory");
    return nil;
}

- (instancetype)initWithMO:(SWShop *)MO {
    if (self = [super init]) {
        // 商铺基本信息
        self.marketName = MO.name;
        self.itemID = MO.itemID;
        self.createTime = MO.createTime;
        
        // 商铺分类
        SWMarketCategory *category = [[SWMarketCategory alloc] init]; // 注意这里不能调用 initWithMO，因为存在循环调用
        category.categoryName = MO.shopCategory.name;
        category.itemID = MO.shopCategory.itemID;
        self.marketCategory = category;
        
        // 商铺联系人
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:YES];
        NSArray *sortDescriptors = @[sortDescriptor];
        NSArray *shopContacts = [MO.shopContacts sortedArrayUsingDescriptors:sortDescriptors];
        for (SWShopContact *shopContact in shopContacts) {
            SWMarketContact *marketContact = [[SWMarketContact alloc] initWithMO:shopContact];
            [self.telNums addObject:marketContact];
            if (marketContact.isDefaultContact) {
                self.defaultTelNum = marketContact.telNum;
            }
        }
        
        // 商铺商品
        NSArray *shopItems = [MO.shopItems sortedArrayUsingDescriptors:sortDescriptors];
        for (SWShoppingItem *shopItem in shopItems) {
            SWProductItem *productItem = [[SWProductItem alloc] initWithMO:shopItem];
            [self.shoppingItems addObject:productItem];
        }
        
        
    }
    return self;
}
#pragma mark - Setter/Getter
- (NSMutableArray *)telNums {
    if (_telNums == nil) {
        _telNums = [[NSMutableArray alloc] init];
    }
    return _telNums;
}

- (NSMutableArray *)shoppingItems {
    if (_shoppingItems == nil) {
        _shoppingItems = [[NSMutableArray alloc] init];
    }
    return _shoppingItems;
}
@end
