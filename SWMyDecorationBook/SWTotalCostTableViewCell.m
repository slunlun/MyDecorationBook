//
//  SWTotalCostTableViewCell.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/6.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWTotalCostTableViewCell.h"
#import "Masonry.h"
#import "SWUIDef.h"

@interface SWTotalCostTableViewCell()
@property(nonatomic, strong) UILabel *titleLab;
@property(nonatomic, strong) UILabel *totalCostLab;
@end

@implementation SWTotalCostTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit {
    _titleLab = [[UILabel alloc] init];
    _titleLab.font = SW_DEFAULT_FONT_BOLD;
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.textColor = SW_TAOBAO_BLACK;
    _titleLab.text = @"总支出";
    [self.contentView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.contentView.mas_left).offset(SW_CELL_LEFT_MARGIN);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
    }];
    
    _totalCostLab = [[UILabel alloc] init];
    _totalCostLab.font = SW_DEFAULT_FONT_LARGE_BOLD;
    _totalCostLab.textColor = SW_MAIN_BLUE_COLOR;
    [self.contentView addSubview:_totalCostLab];
    [_totalCostLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.contentView.mas_left).offset(SW_CELL_LEFT_MARGIN);
        make.topMargin.equalTo(_titleLab.mas_bottom).offset(0.7 * SW_MARGIN);
    }];
}

#pragma mark - Setter/Getter
- (void)setModel:(NSString *)model {
    _totalCostLab.text = model;
}
@end
