//
//  SWBudgetCell.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/9/3.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWBudgetCell.h"
#import "SWUIDef.h"
#import "Masonry.h"
#import "UITextField+OKToolBar.h"

@interface SWBudgetCell()<UITextFieldDelegate>
@property(nonatomic, strong) UILabel *titleLab;
@property(nonatomic, strong) UITextField *budgetTextField;
@end

@implementation SWBudgetCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }
    return self;
}

- (void)updateBudget:(NSString *)budget {
    _budgetTextField.text = budget;
}

#pragma mark - CommonInit
- (void)commonInit {
    _titleLab = [[UILabel alloc] init];
    _titleLab.font = SW_DEFAULT_FONT_LARGE;
    _titleLab.textColor = SW_TAOBAO_BLACK;
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.text = @"家装预算: ￥";
    [self.contentView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.contentView.mas_left).offset(SW_CELL_LEFT_MARGIN);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@100);
    }];
    
    _budgetTextField = [[UITextField alloc] init];
    _budgetTextField.font = SW_DEFAULT_FONT_LARGE;
    _budgetTextField.textColor = SW_TAOBAO_ORANGE;
    _budgetTextField.backgroundColor = SW_DISABLIE_THIN_WHITE;
    _budgetTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _budgetTextField.delegate = self;
    _budgetTextField.text = @"999999";
    [_budgetTextField addOKToolBar];
    [self.contentView addSubview:_budgetTextField];
    [_budgetTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLab.mas_right);
        make.top.equalTo(self.contentView.mas_top).offset( 0.5 * SW_MARGIN);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0.5 * SW_MARGIN);
        make.width.equalTo(self.contentView).multipliedBy(0.33);
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        textField.text = @"0.00";
    }else {
        CGFloat totalCount = textField.text.floatValue;
        textField.text = [NSString stringWithFormat:@"%.2lf", totalCount];
    }
    if (self.budgetUpdate) {
        self.budgetUpdate(textField.text);
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
