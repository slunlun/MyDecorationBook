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
@interface SWNewMarketTelNumCell()

@property(nonatomic, strong) UIButton *defaultTelBtn;
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
    _contactNameTextField.placeholder = @"姓名";
    _contactNameTextField.font = SW_DEFAULT_MIN_FONT;
    [self.contentView addSubview:_contactNameTextField];
    
    _telNumTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _telNumTextField.placeholder = @"联系电话";
    _telNumTextField.font = SW_DEFAULT_MIN_FONT;
    _telNumTextField.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_telNumTextField];
    
    _defaultTelBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_defaultTelBtn addTarget:self action:@selector(defaultTelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_defaultTelBtn setTitleColor:SW_TAOBAO_BLACK forState:UIControlStateNormal];
    [_defaultTelBtn setTitleColor:SW_TAOBAO_ORANGE forState:UIControlStateSelected];
    [_defaultTelBtn setTitle:@"默认" forState:UIControlStateNormal];
    _defaultTelBtn.titleLabel.font = SW_DEFAULT_MIN_FONT;
    [_defaultTelBtn setImage:[UIImage imageNamed:@"Check-UnSel"] forState:UIControlStateNormal];
    [_defaultTelBtn setImage:[UIImage imageNamed:@"Check-Sel"] forState:UIControlStateSelected];
    
    _defaultTelBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    [self.contentView addSubview:_defaultTelBtn];
    
    [self.contactNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.contentView.mas_left).offset(34);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
        make.bottomMargin.equalTo(self.contentView.mas_bottom).offset(-SW_MARGIN);
        make.width.equalTo(@80);
    }];
    
    [self.telNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contactNameTextField.mas_right).offset(SW_MARGIN);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
        make.bottomMargin.equalTo(self.contentView.mas_bottom).offset(-SW_MARGIN);
        make.width.equalTo(@100);
    }];
    
    [self.defaultTelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.rightMargin.equalTo(self.contentView.mas_right).offset(-SW_MARGIN);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
        make.bottomMargin.equalTo(self.contentView.mas_bottom).offset(-SW_MARGIN);
        make.width.equalTo(@60);
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
    button.selected = !button.selected;
    self.marketContact.defaultContact = button.isSelected;
}
@end
