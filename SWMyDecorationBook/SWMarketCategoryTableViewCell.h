//
//  SWMarketCategoryTableViewCell.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/4/17.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWMarketCategory.h"
typedef void(^configBtnCallback)(SWMarketCategory *model);
@interface SWMarketCategoryTableViewCell : UITableViewCell
@property(nonatomic, strong) SWMarketCategory *model;
@property(nonatomic, copy) configBtnCallback configBtnCallback;
@end
