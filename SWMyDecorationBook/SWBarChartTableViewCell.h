//
//  SWBarChartTableViewCell.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/6.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWShoppingOrderManager.h"
#import "SWBarChartView.h"
@interface SWBarChartTableViewCell : UITableViewCell
@property(nonatomic, strong) SWBarChartView *barChartView;
@property(nonatomic, strong) SWShoppingOrderCategoryModle *model;
@end
