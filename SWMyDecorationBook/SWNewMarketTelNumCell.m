//
//  SWNewMarketTelNumCell.m
//  SWMyDecorationBook
//
//  Created by ShiTeng on 2018/1/2.
//  Copyright © 2018年 Eren. All rights reserved.
//

#import "SWNewMarketTelNumCell.h"
#import "Masonry.h"
#import "SWUIDef.h"
#import "UITextField+OKToolBar.h"
@interface SWNewMarketTelNumCell()<UITextFieldDelegate>
@property(nonatomic, strong) UIButton *defaultTelBtn;
@property(nonatomic, strong) UIButton *delBtn;
@end
@implementation SWNewMarketTelNumCell

#pragma mark - INIT
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }
    return self;
}

#pragma mark - UI COMMON INIT
- (void)commonInit {
    _contactNameTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [_contactNameTextField addOKToolBar];
    _contactNameTextField.placeholder = @"姓名";
    _contactNameTextField.font = SW_DEFAULT_FONT;
    _contactNameTextField.delegate = self;
    [self.contentView addSubview:_contactNameTextField];
    [self.contactNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.contentView.mas_left).offset(SW_CELL_LEFT_MARGIN);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
        make.bottomMargin.equalTo(self.contentView.mas_bottom).offset(-SW_MARGIN);
        make.width.equalTo(@60);
    }];
    
    _telNumTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [_telNumTextField addOKToolBar];
    _telNumTextField.placeholder = @"联系电话";
    _telNumTextField.font = SW_DEFAULT_FONT;
    _telNumTextField.textAlignment = NSTextAlignmentLeft;
    _telNumTextField.delegate = self;
    _telNumTextField.keyboardType = UIKeyboardTypePhonePad;
    [self.contentView addSubview:_telNumTextField];
    [self.telNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contactNameTextField.mas_right);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
        make.bottomMargin.equalTo(self.contentView.mas_bottom).offset(-SW_MARGIN);
        make.width.equalTo(@140);
    }];
    
    _delBtn = [[UIButton alloc] init];
    [_delBtn addTarget:self action:@selector(delBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_delBtn setTitle:@"删 除" forState:UIControlStateNormal];
    _delBtn.titleLabel.font = SW_DEFAULT_FONT_BOLD;
    [_delBtn setTitleColor:SW_WARN_RED forState:UIControlStateNormal];
    [self.contentView addSubview:_delBtn];
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.rightMargin.equalTo(self.contentView.mas_right).offset(-SW_MARGIN);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
        make.width.equalTo(@40);
        make.bottomMargin.equalTo(self.contentView.mas_bottom).offset(-SW_MARGIN);
    }];
    
    _defaultTelBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_defaultTelBtn addTarget:self action:@selector(defaultTelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_defaultTelBtn setTitleColor:SW_TAOBAO_BLACK forState:UIControlStateNormal];
    [_defaultTelBtn setTitleColor:SW_TAOBAO_ORANGE forState:UIControlStateSelected];
    [_defaultTelBtn setTitle:@"默认" forState:UIControlStateNormal];
    _defaultTelBtn.titleLabel.font = SW_DEFAULT_FONT_BOLD;
    [_defaultTelBtn setImage:[UIImage imageNamed:@"Check-UnSel"] forState:UIControlStateNormal];
    [_defaultTelBtn setImage:[UIImage imageNamed:@"Check-Sel"] forState:UIControlStateSelected];
    _defaultTelBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.contentView addSubview:_defaultTelBtn];
    [self.defaultTelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
        make.bottomMargin.equalTo(self.contentView.mas_bottom).offset(-SW_MARGIN);
        make.width.equalTo(@60);
        make.rightMargin.equalTo(_delBtn.mas_left).offset(-SW_MARGIN);
    }];
    
   
}


#pragma mark - SETTER/GETTER
- (void)setMarketContact:(SWMarketContact *)marketContact {
    _marketContact = marketContact;
    [self updateUIbyModel:marketContact];
}

- (void)updateUIbyModel:(SWMarketContact *)marketContact {
    self.contactNameTextField.text = marketContact.name;
    self.telNumTextField.text = marketContact.telNum;
    if ([marketContact isDefaultContact]) {
        _defaultTelBtn.selected = YES;
    }else {
        _defaultTelBtn.selected = NO;
    }
}

#pragma mark - UI Response
- (void)defaultTelBtnClicked:(UIButton *)button {
    if(button.isSelected == NO) {
        button.selected = YES;
        if (self.defaultContactSetBlock) {
            self.defaultContactSetBlock(self.marketContact);
        }
    }
}

- (void)delBtnClicked:(UIButton *)button {
    if (self.contactDelBlock) {
        self.contactDelBlock();
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
     [textField resignFirstResponder];
    if ([textField isEqual:self.contactNameTextField]) {
        if(self.contactNameChangedBlock) {
            self.contactNameChangedBlock(textField.text);
        }
    }else {
        if (self.contactTelNumChangedBlock) {
            self.contactTelNumChangedBlock(textField.text);
        }
    }
}
@end
