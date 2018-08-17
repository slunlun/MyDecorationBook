//
//  SWMarketNameCell.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/5/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWMarketNameCell.h"
#import "SWUIDef.h"
#import "Masonry.h"
#import "UITextField+OKToolBar.h"
@interface SWMarketNameCell()<UITextFieldDelegate>
@property(nonatomic, readwrite, strong) UITextField *marketNameTextField;
@end
@implementation SWMarketNameCell

#pragma mark - Init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Common init
- (void)commonInit {
    _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLab.font = SW_DEFAULT_FONT_BOLD;
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.textColor = SW_TAOBAO_BLACK;
    [self.contentView addSubview:_titleLab];
    
    _marketNameTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _marketNameTextField.font= SW_DEFAULT_FONT;
    _marketNameTextField.textAlignment = NSTextAlignmentLeft;
    _marketNameTextField.placeholder = @"名称";
    _marketNameTextField.delegate = self;
    _marketNameTextField.textColor = SW_TAOBAO_BLACK;
    [_marketNameTextField addOKToolBar];
    [self.contentView addSubview:_marketNameTextField];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.contentView.mas_left).offset(SW_CELL_LEFT_MARGIN);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@60);
    }];
    
    [_marketNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.rightMargin.equalTo(self.contentView.mas_right).offset(-SW_MARGIN);
        make.left.equalTo(self.titleLab.mas_right).offset(SW_MARGIN * 0.5);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
        make.bottomMargin.equalTo(self.contentView.mas_bottom).offset(-SW_MARGIN);
    }];
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.finishBlock) {
        self.finishBlock(textField.text);
    }
}
@end
