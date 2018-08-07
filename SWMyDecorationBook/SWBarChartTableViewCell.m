//
//  SWBarChartTableViewCell.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/6.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWBarChartTableViewCell.h"
#import "Masonry.h"
#import "SWUIDef.h"
@interface SWBarChartTableViewCell()
@property(nonatomic, strong) UILabel *categoryTitleLab;
@property(nonatomic, strong) UILabel *costPercentLab;
@property(nonatomic, strong) UILabel *totalCostLab;
@end

@implementation SWBarChartTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
#pragma mark - Common init
- (void)commonInit {
    _categoryTitleLab = [[UILabel alloc] init];
    _categoryTitleLab.font = SW_DEFAULT_FONT_BOLD;
    _categoryTitleLab.textColor = SW_TAOBAO_BLACK;
    _categoryTitleLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_categoryTitleLab];
    [_categoryTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.contentView.mas_left).offset(SW_CELL_LEFT_MARGIN);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
    }];

    _costPercentLab = [[UILabel alloc] init];
    _costPercentLab.font = SW_DEFAULT_SUPER_MIN_FONT;
    _costPercentLab.textColor = SW_TAOBAO_BLACK;
    _costPercentLab.textAlignment = NSTextAlignmentLeft;
   
    [self.contentView addSubview:_costPercentLab];
    [_costPercentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(_categoryTitleLab.mas_right).offset(SW_MARGIN);
        make.centerY.equalTo(self.categoryTitleLab.mas_centerY);
    }];
    
    _totalCostLab = [[UILabel alloc] init];
    _totalCostLab.font = SW_DEFAULT_SUPER_MIN_FONT;
    _totalCostLab.textColor = SW_MAIN_BLUE_COLOR;
    _totalCostLab.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_totalCostLab];
    [_totalCostLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.contentView.mas_left).offset(SW_CELL_LEFT_MARGIN);
        make.topMargin.equalTo(self.categoryTitleLab.mas_bottom).offset(0.5 * SW_MARGIN);
    }];
}

- (void)setModel:(SWShoppingOrderCategoryModle *)model {
    _model = model;
    _categoryTitleLab.text = _model.orderCategoryName;
    
    NSString *percentTitle = [NSString stringWithFormat:@"%.2f%%", _model.costPercent * 100];
    _costPercentLab.text = percentTitle;
    
    NSString *totalCostStr = [NSString stringWithFormat:@"¥ %.2f", _model.totalCost];
    _totalCostLab.text = totalCostStr;

    
    [_barChartView removeFromSuperview];
    _barChartView = [[SWBarChartView alloc] initWithFrame:CGRectMake(0.5 * SW_MARGIN, 0.2 * SW_MARGIN, self.contentView.frame.size.width -  2 * SW_MARGIN, self.contentView.frame.size.height - 0.4 * SW_MARGIN)];
    [self.contentView insertSubview:_barChartView belowSubview:_categoryTitleLab];
    [_barChartView updateChartView:_model.costPercent];
    
}


@end
