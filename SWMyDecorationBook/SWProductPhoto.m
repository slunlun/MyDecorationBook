//
//  SWProductPhoto.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/17/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWProductPhoto.h"

@implementation SWProductPhoto
- (instancetype)initWithImage:(UIImage *)photo {
    if (self = [super init]) {
        _itemID = [[NSUUID UUID] UUIDString];
        _photo = photo;
        _createTime = [NSDate date];
    }
    return self;
}

- (instancetype)initWithMO:(SWShoppingPhoto *)shoppingPhoto {
    if (self = [super init]) {
        _itemID = shoppingPhoto.itemID;
        _photo = [UIImage imageWithData:shoppingPhoto.image];
        _createTime = shoppingPhoto.createTime;
    }
    return self;
}
@end
