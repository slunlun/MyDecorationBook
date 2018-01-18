//
//  SWMarketContactSectionHeaderView.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/4/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWMarketContactSectionHeaderView.h"
#import "Masonry.h"
#import "SWUIDef.h"
@interface SWMarketContactSectionHeaderView()
@property(nonatomic, strong) UIButton *addContactBtn;
@property(nonatomic, strong) UILabel *titleLab;
@end

@implementation SWMarketContactSectionHeaderView
#pragma mark - INIT
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }
    return self;
}

#pragma mark - COMMON INIT
- (void)commonInit {
    _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLab.font = SW_DEFAULT_FONT;
    _titleLab.text = @"联系电话";
    _titleLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_titleLab];
    
    _addContactBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    _addContactBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_addContactBtn setImage:[UIImage imageNamed:@"Add"] forState:UIControlStateNormal];
    [_addContactBtn addTarget:self action:@selector(addContactBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_addContactBtn];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.contentView.mas_left).offset(SW_MARGIN);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
        make.bottomMargin.equalTo(self.contentView.mas_bottom).offset(-SW_MARGIN);
    }];
    
    [_addContactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.rightMargin.equalTo(self.contentView.mas_right).offset(-2*SW_MARGIN);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
        make.bottomMargin.equalTo(self.contentView.mas_bottom).offset(-SW_MARGIN);
    }];
}

#pragma mark - UI Respond
- (void)addContactBtnClicked:(UIButton *)button {
    if (self.addContactAction) {
        self.addContactAction();
    }
}
@end
