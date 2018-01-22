//
//  SWProductItem.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/30/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import "SWProductItem.h"

@implementation SWProductItem
//@property(nonatomic, strong) NSString *itemID;
//@property(nonatomic, strong) NSString *productName;
//@property(nonatomic, strong) NSString *productMark;
//@property(nonatomic, assign) double price;
//@property(nonatomic, assign, getter=isChoosed) BOOL choosed;
//@property(nonatomic, strong) NSArray *productPhotos;
//@property(nonatomic, strong) SWItemUnit *itemUnit;
//@property(nonatomic, strong) NSDate *createTime;
#pragma mark - Init
- (instancetype)initWithMO:(SWShoppingItem *)shoppingItem {
    if (self = [super init]) {
        // 基本信息
        _itemID = shoppingItem.itemIndex;
        _productName = shoppingItem.name;
        _productRemark = shoppingItem.remark;
        _price = shoppingItem.price;
        _choosed = shoppingItem.choosed;
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:YES];
        NSArray *sortDescriptors = @[sortDescriptor];
        NSArray *shopPhotos = [shoppingItem.itemPhotos sortedArrayUsingDescriptors:sortDescriptors];
        _productPhotos = shopPhotos;
        _createTime = shoppingItem.createTime;
        
        // 设置货品单位
        _itemUnit = [[SWItemUnit alloc] initWithMO:shoppingItem.itemUnit];
    }
    return self;
}
@end
