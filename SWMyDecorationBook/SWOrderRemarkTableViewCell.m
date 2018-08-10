//
//  SWOrderRemarkTableViewCell.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/4/25.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWOrderRemarkTableViewCell.h"
#import "Masonry.h"
#import "SWUIDef.h"
#import "UITextField+OKToolBar.h"


@interface SWOrderRemarkTableViewCell()<UITextFieldDelegate>
@property(nonatomic, strong) UITextField *txtFRemark;
@end

@implementation SWOrderRemarkTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Common Init
- (void)commonInit {
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.textColor = SW_TAOBAO_BLACK;
    titleLab.font = SW_DEFAULT_FONT;
    titleLab.text = @"备注:";
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.contentView.mas_left).offset(SW_CELL_LEFT_MARGIN);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
        make.bottomMargin.equalTo(self.contentView.mas_bottom).offset(-SW_MARGIN);
        make.width.equalTo(@50);
    }];
    
    _txtFRemark = [[UITextField alloc] init];
    _txtFRemark.textAlignment = NSTextAlignmentLeft;
    _txtFRemark.font = SW_DEFAULT_MIN_FONT;
    _txtFRemark.textColor = SW_TAOBAO_BLACK;
    _txtFRemark.delegate = self;
    _txtFRemark.placeholder = @"选填";
    _txtFRemark.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_txtFRemark addOKToolBar];
    [self.contentView addSubview:_txtFRemark];
    [_txtFRemark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab.mas_right).offset(0.2 * SW_MARGIN);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
        make.bottomMargin.equalTo(self.contentView.mas_bottom).offset(-SW_MARGIN);
        make.right.equalTo(self.contentView).offset(-SW_MARGIN);
    }];
    
}

- (void)setOrderRemark:(NSString *)orderRemark {
    if (orderRemark != nil && ![orderRemark isEqualToString:@""]) {
        _txtFRemark.text = orderRemark;
    }
}
#pragma mark - UITextViewDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.remarkChangeBlock) {
        self.remarkChangeBlock(textField.text);
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.text.length < 32) {
        return YES;
    }else {
        return NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length < 32) {
        return YES;
    }else {
        return NO;
    }
}
@end
