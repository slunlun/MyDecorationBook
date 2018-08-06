//
//  SWBarChartTableViewCell.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/6.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWBarChartTableViewCell.h"
#import "Masonry.h"
#import "SWBarChartView.h"
@interface SWBarChartTableViewCell()
@property(nonatomic, strong) SWBarChartView *barChartView;
@property(nonatomic, strong) UILabel *categoryTitleLab;
@property(nonatomic, strong) UILabel *costPercentLab;
@property(nonatomic, strong) UILabel *totalCostLab;
@end

@implementation SWBarChartTableViewCell

- (instancetype)initWithShoppingOrderCategoryModle:(SWShoppingOrderCategoryModle *)model {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
#pragma mark - Common init
- (void)commonInit {
    
}
@end
