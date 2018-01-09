//
//  SWShoppingItemPriceCell.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/9/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWShoppingItemPriceCell.h"
#import "Masonry.h"
#import "SWUIDef.h"
@interface SWShoppingItemPriceCell()
@property(nonatomic, strong) UILabel *titleLab;
@property(nonatomic, strong) UILabel *slashLab;
@property(nonatomic, strong) UIButton *priceUnitBtn;
@property(nonatomic, strong) UITextField *priceTextField;
@end


@implementation SWShoppingItemPriceCell
- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Common init
- (void)commonInit {
    _titleLab = [[UILabel alloc] init];
    _titleLab.font = SW_DEFAULT_FONT;
    _titleLab.text = @"单价 ¥";
    [self.contentView addSubview:_titleLab];
    
    _priceTextField = [[UITextField alloc] init];
    _priceTextField.font = SW_DEFAULT_MIN_FONT;
    _priceTextField.placeholder = @"单价";
    _priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.contentView addSubview:_priceTextField];
    
    _slashLab = [[UILabel alloc] init];
    _slashLab.font = SW_DEFAULT_FONT;
    _slashLab.text = @"/";
    [self.contentView addSubview:_slashLab];
    
    _priceUnitBtn = [[UIButton alloc] init];
    [_priceUnitBtn setTitle:@"平" forState:UIControlStateNormal];
    _priceUnitBtn.titleLabel.font = SW_DEFAULT_FONT;
    [_priceUnitBtn addTarget:self action:@selector(priceUnitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_priceUnitBtn];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.contentView.mas_left).offset(SW_MARGIN);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
    }];
    
    [_priceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLab.mas_right);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
        make.bottomMargin.equalTo(self.contentView.mas_bottom).offset(-SW_MARGIN);
        make.width.equalTo(@120);
    }];
    
    [_slashLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_priceTextField.mas_right);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
    }];
    
    [_priceUnitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_slashLab.mas_right);
        make.top.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-SW_MARGIN);
        make.width.equalTo(@80);
    }];
}

#pragma mark - UI Response
- (void)priceUnitBtnClicked:(UIButton *)button {
    
}
@end
