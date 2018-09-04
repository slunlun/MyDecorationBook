//
//  SWSystemHeaderView.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/31.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWSystemHeaderView.h"
#import "Masonry.h"
#import "SWButton.h"
#import "SWUIDef.h"

@interface SWSystemHeaderView()
@property(nonatomic, strong) UILabel *versionLab;
@property(nonatomic, strong) UILabel *totalCostLab;
@property(nonatomic, strong) UILabel *budgetLab;
@property(nonatomic, strong) SWButton *sysConfigBtn;
@property(nonatomic, strong) UIView *splashView;
@end

@implementation SWSystemHeaderView

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

#pragma mark - commonInit
- (void)commonInit {
    _versionLab = [[UILabel alloc] init];
    _versionLab.font = SW_DEFAULT_SUPER_MIN_FONT;
    _versionLab.textColor = [UIColor grayColor];
    _versionLab.textAlignment = NSTextAlignmentLeft;
    _versionLab.text = [NSString stringWithFormat:@"家装随手记 版本 %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [self addSubview:_versionLab];
    [_versionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.mas_left).offset(SW_MARGIN);
        make.top.equalTo(self.mas_top).offset(0.1 * SW_MARGIN);
    }];
    
    _sysConfigBtn = [[SWButton alloc] initWithButtonType:SWButtonLayoutTypeImageTop];
    [_sysConfigBtn setTitle:@"设 置" forState:UIControlStateNormal];
    [_sysConfigBtn setTitleColor:SW_DISABLE_GRAY forState:UIControlStateNormal];
    [_sysConfigBtn setImage:[UIImage imageNamed:@"Gear"] forState:UIControlStateNormal];
    _sysConfigBtn.titleLabel.font = SW_DEFAULT_FONT;
    [_sysConfigBtn addTarget:self action:@selector(systemConfigBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sysConfigBtn];
    [_sysConfigBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.mas_left);
        make.topMargin.equalTo(self.mas_top).offset(0.5 * SW_MARGIN);
        make.bottomMargin.equalTo(self.mas_bottom).offset(-0.5 * SW_MARGIN);
        make.width.equalTo(@80);
    }];
    
    _totalCostLab = [[UILabel alloc] init];
    _totalCostLab.font = SW_DEFAULT_FONT_LARGE_BOLD;
    _totalCostLab.text = @"总支出: ￥9999";
    _totalCostLab.textColor = SW_DISABLE_GRAY;
    [self addSubview:_totalCostLab];
    [_totalCostLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(-0.7 * SW_MARGIN);
        make.leftMargin.equalTo(_sysConfigBtn.mas_right).offset(0.5 * SW_MARGIN);
    }];
    
    _budgetLab = [[UILabel alloc] init];
    _budgetLab.font = SW_DEFAULT_FONT_LARGE_BOLD;
    _budgetLab.text = @"预   算: ￥9999999";
    _budgetLab.textColor = SW_DISABLE_GRAY;
    [self addSubview:_budgetLab];
    [_budgetLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(0.7 * SW_MARGIN);
        make.leftMargin.equalTo(_sysConfigBtn.mas_right).offset(0.5 * SW_MARGIN);
    }];
    
    _splashView = [[UIView alloc] init];
    _splashView.backgroundColor = [UIColor grayColor];
    _splashView.alpha = 0.6;
    [self addSubview:_splashView];
    [_splashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_sysConfigBtn.mas_right).offset(2);
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@1);
    }];
}

- (void)updateCostSummary:(CGFloat)totalCost budget:(CGFloat)budget {
    _totalCostLab.text = [NSString stringWithFormat:@"总支出:￥%.2lf", totalCost];
    _budgetLab.text = [NSString stringWithFormat:@"预   算:￥%.2lf", budget];
    if (budget) {
        if (totalCost / budget > 1) {
            _totalCostLab.textColor = SW_WARN_RED;
        }else {
            _totalCostLab.textColor = SW_DISABLE_GRAY;
        }
    }
    
}

#pragma mark - UI response
- (void)systemConfigBtnClicked:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(systemHeaderViewdidSelectedSystemConfigBtn:)]) {
        [self.delegate systemHeaderViewdidSelectedSystemConfigBtn:self];
    }
}
@end
