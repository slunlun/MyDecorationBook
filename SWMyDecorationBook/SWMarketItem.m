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
- (instancetype)init {
    if (self = [super init]) {
        _itemID = [[NSUUID UUID] UUIDString];
        _createTime = [NSDate date];
    }
    return self;
}

- (instancetype)initWithMO:(SWShop *)MO {
    if (self = [super init]) {
        //        @property(nonatomic, strong) NSString *marketName;
        //        @property(nonatomic, strong) NSArray *telNums;  // 联系方式(可多个)
        //        @property(nonatomic, strong) NSNumber *defaultTelNum;
        //        @property(nonatomic, strong) NSArray *shoppingItems;
        //        @property(nonatomic, strong) NSDate *createTime;
        //        @property(nonatomic, strong) SWMarketCategory *marketCategory;
        
        // 商铺基本信息
        self.marketName = MO.name;
        self.itemID = MO.itemID;
        self.createTime = MO.createTime;
        
        // 商铺分类
        SWMarketCategory *category = [[SWMarketCategory alloc] init];
        category.categoryName = MO.shopCategory.name;
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
    if (_shoppingItems) {
        _shoppingItems = [[NSMutableArray alloc] init];
    }
    return _shoppingItems;
}
@end
