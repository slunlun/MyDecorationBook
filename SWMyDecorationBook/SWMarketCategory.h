//
//  SWMarketCategory.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/17/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SWMarketCategory : NSObject
@property(nonatomic, strong) NSString *categoryName;
@property(nonatomic, strong) UIImage *categoryImage;
@property(nonatomic, strong) NSArray *categoryItems;  // 当前分类下的商家列表
@property(nonatomic, assign) NSInteger indexNum;    // 用户排序
@end
