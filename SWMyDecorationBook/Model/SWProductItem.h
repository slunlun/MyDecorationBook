//
//  SWProductItem.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/30/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWItemUnit.h"

@interface SWProductItem : NSObject
@property(nonatomic, strong) NSString *productName;
@property(nonatomic, strong) NSString *productMark;
@property(nonatomic, assign) double price;
@property(nonatomic, assign, getter=isChoosed) BOOL choosed;
@property(nonatomic, strong) NSArray *productPhotos;
@property(nonatomic, strong) SWItemUnit *itemUnit;
@property(nonatomic, strong) NSDate *createTime;
@end
