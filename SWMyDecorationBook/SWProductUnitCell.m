//
//  SWProductUnitCell.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/9/3.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWProductUnitCell.h"
#import "SWUIDef.h"
#import "Masonry.h"

@interface SWProductUnitCell()
@property(nonatomic, strong) UILabel *titleLab;
@property(nonatomic, strong) UIButton *modifyBtn;
@property(nonatomic, strong) UIButton *delBtn;
@end

@implementation SWProductUnitCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }
    return self;
}

#pragma mark - CommonInit
- (void)commonInit {
    _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLab.font = SW_DEFAULT_FONT_LARGE;
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.textColor = SW_TAOBAO_BLACK;
    _titleLab.text = @"块";
    [self.contentView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.contentView.mas_left).offset(SW_CELL_LEFT_MARGIN);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    _delBtn = [[UIButton alloc] init];
    _delBtn.titleLabel.font = SW_DEFAULT_FONT;
    [_delBtn setTitleColor:SW_WARN_RED forState:UIControlStateNormal];
    [_delBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.contentView addSubview:_delBtn];
    [_delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.rightMargin.equalTo(self.contentView.mas_right).offset(-SW_CELL_LEFT_MARGIN);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@60);
    }];
    
    _modifyBtn = [[UIButton alloc] init];
    _modifyBtn.titleLabel.font = SW_DEFAULT_FONT;
    [_modifyBtn setTitleColor:SW_MAIN_BLUE_COLOR forState:UIControlStateNormal];
    [_modifyBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.contentView addSubview:_modifyBtn];
    [_modifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.rightMargin.equalTo(_delBtn.mas_left).offset(-SW_CELL_LEFT_MARGIN);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@60);
    }];
}
@end
