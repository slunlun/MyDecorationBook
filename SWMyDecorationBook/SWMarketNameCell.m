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
@interface SWMarketNameCell()
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
    _titleLab.font = SW_DEFAULT_FONT;
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.textColor = SW_TAOBAO_BLACK;
    [self.contentView addSubview:_titleLab];
    
    _marketNameTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _marketNameTextField.font= SW_DEFAULT_MIN_FONT;
    _marketNameTextField.textAlignment = NSTextAlignmentLeft;
    _marketNameTextField.placeholder = @"内容";
    [self.contentView addSubview:_marketNameTextField];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.contentView.mas_left).offset(SW_MARGIN);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
    }];
    
    [_marketNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.rightMargin.equalTo(self.contentView.mas_right).offset(-SW_MARGIN);
        make.left.equalTo(self.titleLab.mas_right).offset(SW_MARGIN);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
        make.bottomMargin.equalTo(self.contentView.mas_bottom).offset(-SW_MARGIN);
    }];
}
@end
