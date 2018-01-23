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
#import "SWPickerView.h"
@interface SWShoppingItemPriceCell()

@property(nonatomic, strong) UILabel *slashLab;

@property(nonatomic, strong) UILabel *titleLab;
@end


@implementation SWShoppingItemPriceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Common init
- (void)commonInit {
    _titleLab = [[UILabel alloc] init];
    _titleLab.font = SW_DEFAULT_FONT;
    _titleLab.textColor = SW_TAOBAO_BLACK;
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
    
 
    
    _priceUnitLab = [[UILabel alloc] init];
    _priceUnitLab.font = SW_DEFAULT_FONT;
    _priceUnitLab.text = @"平";
    [self.contentView addSubview:_priceUnitLab];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.contentView.mas_left).offset(SW_MARGIN);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
    }];
    
    [_priceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLab.mas_right).offset(SW_MARGIN/2);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
        make.height.equalTo(_titleLab.mas_height);
        make.width.equalTo(@80);
    }];
    
    [_slashLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_priceTextField.mas_right);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
    }];
    
    [_priceUnitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_slashLab.mas_right).offset(SW_MARGIN);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
    }];
}

- (void)setPriceUnitStr:(NSString *)priceUnitStr {
    _priceUnitStr = priceUnitStr;
    self.priceUnitLab.text = priceUnitStr;
}

@end
