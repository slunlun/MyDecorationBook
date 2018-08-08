//
//  SWOrder.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/4/19.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWOrder.h"
#import "NSDate+SWDateExt.h"
@implementation SWOrder
- (instancetype)init {
    if (self = [super init]) {
        
        _orderDate = [NSDate dateYMD];
        _orderID = [[NSUUID UUID] UUIDString];
    }
    return self;
}

- (instancetype)initWithMO:(SWShoppingItemOrder *)MO {
    if (self = [super init]) {
        _orderID = MO.itemID;
        _itemCount = MO.totalCount;
        _orderTotalPrice = MO.totalPrice;
        _orderDate = MO.createTime;
        _orderRemark = MO.remark;
        _productItem = [[SWProductItem alloc] initWithMO:MO.shopItem];
        _marketItem = [[SWMarketItem alloc] initWithMO:MO.shopItem.shop];
    }
    return self;
}
@end
