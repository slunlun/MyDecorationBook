//
//  SWOrderTotalPriceTableViewCell.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/10.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWOrderTotalPriceTableViewCell.h"
#import "Masonry.h"
#import "SWUIDef.h"
#import "UITextField+OKToolBar.h"
@interface SWOrderTotalPriceTableViewCell()<UITextFieldDelegate>
@property(nonatomic, strong) UITextField *txtFTotalPrice;
@property(nonatomic, strong) UILabel *priceTotalLab;
@property(nonatomic, strong) SWOrder *orderInfo;
@end

@implementation SWOrderTotalPriceTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _priceTotalLab= [[UILabel alloc] init];
    _priceTotalLab.font = SW_DEFAULT_FONT;
    _priceTotalLab.textColor = SW_TAOBAO_BLACK;
    _priceTotalLab.textAlignment = NSTextAlignmentRight;
    _priceTotalLab.text = @"合计金额: ￥";
    [self.contentView addSubview:_priceTotalLab];
    [_priceTotalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.width.equalTo(self.contentView).multipliedBy(0.33);
    }];
    
    _txtFTotalPrice = [[UITextField alloc] init];
    _txtFTotalPrice.font = SW_DEFAULT_FONT_LARGE;
    _txtFTotalPrice.textColor = SW_TAOBAO_ORANGE;
    _txtFTotalPrice.backgroundColor = SW_DISABLIE_THIN_WHITE;
    _txtFTotalPrice.keyboardType = UIKeyboardTypeDecimalPad;
    _txtFTotalPrice.delegate = self;
    [_txtFTotalPrice addOKToolBar];
    [self.contentView addSubview:_txtFTotalPrice];
    [_txtFTotalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_priceTotalLab.mas_right);
        make.top.equalTo(self.contentView.mas_top).offset( 0.5 * SW_MARGIN);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0.5 * SW_MARGIN);
        make.width.equalTo(self.contentView).multipliedBy(0.33);
    }];
}

- (void)setOrderInfo:(SWOrder *)orderInfo {
    _orderInfo = orderInfo;
    _txtFTotalPrice.text = [NSString stringWithFormat:@"%.2lf", self.orderInfo.orderTotalPrice];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        textField.text = @"0.00";
    }else {
        CGFloat totalCount = textField.text.floatValue;
        textField.text = [NSString stringWithFormat:@"%.2lf", totalCount];
    }
    if (self.priceChangedBlock) {
        self.priceChangedBlock(textField.text.floatValue);
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
