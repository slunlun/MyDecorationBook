//
//  SWShoppingItemRemarkCell.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/9/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWShoppingItemRemarkCell.h"
#import "SWUIDef.h"
#import "Masonry.h"

#define MAX_TEXT_LENGTH 32
#define PLACE_HOLD_TEXT @"备注可选，最多32个字"
@interface SWShoppingItemRemarkCell()<UITextViewDelegate>
@property(nonatomic, strong) UILabel *remarkTitleLab;
@property(nonatomic, strong) UILabel *countLimitLab;
@property(nonatomic, assign) BOOL firstEdit;
@end


@implementation SWShoppingItemRemarkCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _firstEdit = YES;
        [self commonInit];
    }
    return self;
}

#pragma mark - Common init
- (void)commonInit {
    _remarkTitleLab = [[UILabel alloc] init];
    _remarkTitleLab.font = SW_DEFAULT_FONT;
    _remarkTitleLab.textColor = SW_TAOBAO_BLACK;
    _remarkTitleLab.text = @"备注";
    [self.contentView addSubview:_remarkTitleLab];
    
    _remarkTextView = [[UITextView alloc] init];
    _remarkTextView.font = SW_DEFAULT_MIN_FONT;
    _remarkTextView.delegate = self;
    _remarkTextView.text = PLACE_HOLD_TEXT;
    _remarkTextView.textColor = SW_DISABLE_GRAY;
    [self.contentView addSubview:_remarkTextView];
    
    _countLimitLab = [[UILabel alloc] init];
    _countLimitLab.font = SW_DEFAULT_SUPER_MIN_FONT;
    _countLimitLab.textColor = SW_DISABLE_GRAY;
    _countLimitLab.text = [NSString stringWithFormat:@"0/%d", MAX_TEXT_LENGTH];
    _countLimitLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_countLimitLab];
    
    [_remarkTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.contentView.mas_left).offset(SW_MARGIN);
        make.top.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
    }];
    
    [_remarkTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.contentView.mas_left).offset(SW_MARGIN);
        make.top.equalTo(self.remarkTitleLab.mas_bottom).offset(SW_MARGIN/2);
        make.rightMargin.equalTo(self.contentView.mas_right).offset(-SW_MARGIN);
        make.height.equalTo(@60);
    }];
    
    [_countLimitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.topMargin.equalTo(_remarkTextView.mas_bottom).offset(SW_MARGIN);
        make.right.equalTo(_remarkTextView.mas_right);
    }];
}

#pragma mark - Set/Get
- (void)setProductItem:(SWProductItem *)productItem {
    self.remarkTextView.text = productItem.productRemark;
    _productItem = productItem;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (_firstEdit) {
        _remarkTextView.textColor = SW_TAOBAO_BLACK;
        _remarkTextView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        _remarkTextView.text = PLACE_HOLD_TEXT;
        _remarkTextView.textColor = SW_DISABLE_GRAY;
        _firstEdit = YES;
    }else {
        self.productItem.productRemark = _remarkTextView.text;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (range.location < MAX_TEXT_LENGTH){
        return  YES;
        
    } else if ([textView.text isEqualToString:@"\n"]) {
        
        //这里写按了ReturnKey 按钮后的代码
        return NO;
    }
    
    if (textView.text.length == MAX_TEXT_LENGTH) {
        
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    self.countLimitLab.text = [NSString stringWithFormat:@"%lu/32", textView.text.length];
}

@end
