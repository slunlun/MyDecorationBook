//
//  SWMarketCategory.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/17/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWMarketCategory.h"
#import "SWShop+CoreDataClass.h"
#import "SWMarketItem.h"
@implementation SWMarketCategory

- (instancetype)initWithCategoryName:(NSString *)categoryName {
    if (self = [super init]) {
        _itemID = [[NSUUID UUID] UUIDString];
        _categoryName = categoryName;
        _createTime = [NSDate date];
        _indexNum = -1;
    }
    return self;
}

- (instancetype)initWithMO:(SWShoppingCategory *)category {
    if (self = [super init]) {
//        @property(nonatomic, strong) NSString *categoryName;
//        @property(nonatomic, strong) UIImage *categoryImage;
//        @property(nonatomic, strong) NSArray *categoryItems;  // 当前分类下的商家列表
//        @property(nonatomic, assign) NSInteger indexNum;    // 用户排序
        _categoryName = category.name;
        _indexNum = category.arrangeIndex;
        _createTime = category.createTime;
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:YES];
        NSArray *sortDescriptors = @[sortDescriptor];
        NSArray *categoryShops = [category.shops sortedArrayUsingDescriptors:sortDescriptors];
        
        for (SWShop *shop in categoryShops) {
            SWMarketItem *market = [[SWMarketItem alloc] initWithMO:shop];
            [self.categoryItems addObject:market];
        }
        
    }
    return self;
}

#pragma mark - Setter/Getter
- (NSMutableArray *)categoryItems {
    if (_categoryItems == nil) {
        _categoryItems = [[NSMutableArray alloc] init];
    }
    return _categoryItems;
}
@end
