//
//  SWMarketCategory.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/17/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SWShoppingCategory+CoreDataClass.h"

@interface SWMarketCategory : NSObject
- (instancetype)initWithMO:(SWShoppingCategory *)category;
@property(nonatomic, strong) NSString *categoryName;
@property(nonatomic, strong) UIImage *categoryImage;
@property(nonatomic, strong) NSMutableArray *categoryItems;  // 当前分类下的商家列表
@property(nonatomic, assign) NSInteger indexNum;    // 用户排序
@property(nonatomic, strong) NSDate *createTime;
@end
