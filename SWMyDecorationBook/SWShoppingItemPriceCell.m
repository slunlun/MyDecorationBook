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
#import "UITextField+OKToolBar.h"
@interface SWShoppingItemPriceCell()<UITextFieldDelegate>
@property(nonatomic, strong) UILabel *priceUnitLab;
@property(nonatomic, strong) NSString *priceUnitStr;
@property(nonatomic, strong) UITextField *priceTextField;
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
    _titleLab.font = SW_DEFAULT_FONT_BOLD;
    _titleLab.textColor = SW_TAOBAO_BLACK;
    _titleLab.text = @"单价 ¥";
    [self.contentView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.contentView.mas_left).offset(SW_CELL_LEFT_MARGIN);
        make.width.equalTo(@60);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    _priceTextField = [[UITextField alloc] init];
    _priceTextField.font = SW_DEFAULT_FONT;
    _priceTextField.placeholder = @"单价";
    _priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _priceTextField.delegate = self;
    _priceTextField.textAlignment = NSTextAlignmentLeft;
    [_priceTextField addOKToolBar];
    [self.contentView addSubview:_priceTextField];
    [_priceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(_titleLab.mas_right).offset(SW_MARGIN);
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@100);
    }];
    
    
    _slashLab = [[UILabel alloc] init];
    _slashLab.font = SW_DEFAULT_FONT;
    _slashLab.text = @"/";
    [self.contentView addSubview:_slashLab];
    [_slashLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_priceTextField.mas_right).offset(SW_MARGIN * 0.5);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
 
    
    _priceUnitLab = [[UILabel alloc] init];
    _priceUnitLab.font = SW_DEFAULT_FONT;
    _priceUnitLab.text = @"请选择价格单位";
    [self.contentView addSubview:_priceUnitLab];
    [_priceUnitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_slashLab.mas_right).offset(SW_MARGIN);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

- (void)setPriceUnitStr:(NSString *)priceUnitStr {
    _priceUnitStr = priceUnitStr;
    self.priceUnitLab.text = priceUnitStr;
}

- (void)setProductItem:(SWProductItem *)productItem {
    if (productItem) {
        self.priceUnitLab.text = productItem.itemUnit.unitTitle;
        if (productItem.price > 0) {
            self.priceTextField.text = [NSString stringWithFormat:@"%.2lf", productItem.price];
        }
        _productItem = productItem;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.priceChangeBlock) {
        self.priceChangeBlock(textField.text);
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        textField.text = @"0.00";
    }else {
        CGFloat totalCount = textField.text.floatValue;
        textField.text = [NSString stringWithFormat:@"%.2lf", totalCount];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.text isEqualToString:@"0.00"]) {
        textField.text = string;
        return NO;
    }
    return YES;
}
@end
