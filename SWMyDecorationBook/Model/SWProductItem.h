//
//  SWProductItem.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/30/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWItemUnit.h"
#import "SWShoppingItem+CoreDataClass.h"

@interface SWProductItem : NSObject
- (instancetype)initWithMO:(SWShoppingItem *)shoppingItem;
@property(nonatomic, strong) NSString *itemID;
@property(nonatomic, strong) NSString *productName;
@property(nonatomic, strong) NSString *productRemark;
@property(nonatomic, assign) float price;
@property(nonatomic, assign, getter=isChoosed) BOOL choosed;
@property(nonatomic, strong) NSArray *productPhotos;
@property(nonatomic, strong) SWItemUnit *itemUnit;
@property(nonatomic, strong) NSDate *createTime;
@end
