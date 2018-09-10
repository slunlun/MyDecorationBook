//
//  SWProductItem.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/30/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import "SWProductItem.h"
#import "SWDef.h"
#import "SWPriceUnitStorage.h"
#import "SWShoppingItemOrder+CoreDataClass.h"

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
- (instancetype)init {
    if (self = [super init]) {
        _itemID = [[NSUUID UUID] UUIDString];
        _price = -1.0f;
        _createTime = [NSDate date];
       
        _productPhotos = [[NSMutableArray alloc] init];
        _itemUnit = [SWPriceUnitStorage allPriceUnit].firstObject;
    }
    return self;
}
- (instancetype)initWithMO:(SWShoppingItem *)shoppingItem {
    if (self = [super init]) {
        // 基本信息
        _itemID = shoppingItem.itemID;
        _productName = shoppingItem.name;
        _productRemark = shoppingItem.remark;
        _price = shoppingItem.price;
        _choosed = shoppingItem.ownnerOrder?YES:NO;
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:YES];
        NSArray *sortDescriptors = @[sortDescriptor];
        NSArray *shopPhotos = [shoppingItem.itemPhotos sortedArrayUsingDescriptors:sortDescriptors];
        _productPhotos = [[NSMutableArray alloc] init];
        for (SWShoppingPhoto * shopPhoto in shopPhotos) {
            SWProductPhoto *productPhoto = [[SWProductPhoto alloc] initWithMO:shopPhoto];
            [_productPhotos addObject:productPhoto];
        }
        _createTime = shoppingItem.createTime;
        _itemUnit = [[SWItemUnit alloc] initWithMO:shoppingItem.itemUnit];
        
        // 订单信息
        if (shoppingItem.ownnerOrder) {
            _ownnerOrderID = shoppingItem.ownnerOrder.itemID;
        }
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if([object isKindOfClass:[SWProductItem class]]) {
        if([((SWProductItem *)object).itemID isEqualToString:self.itemID]) {
            return YES;
        }else {
            return NO;
        }
    }else {
        return NO;
    }
}

- (NSUInteger)hash {
    return [self.itemID hash];
}
@end
