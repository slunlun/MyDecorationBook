//
//  SWProductPhoto.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/17/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWProductPhoto.h"

@implementation SWProductPhoto
- (instancetype)initWithProductItem:(SWProductItem *)ownerProduct image:(UIImage *)photo {
    if (self = [super init]) {
        _itemID = [[NSUUID UUID] UUIDString];
        _photo = photo;
        _createTime = [NSDate date];
        _ownerProductItem = ownerProduct;
    }
    return self;
}
@end
