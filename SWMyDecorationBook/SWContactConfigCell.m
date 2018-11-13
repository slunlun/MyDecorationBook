//
//  SWContactConfigCell.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/9/3.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWContactConfigCell.h"
#import "SWUIDef.h"
#import "Masonry.h"

@interface SWContactConfigCell()
@property(nonatomic, strong) UILabel *titleLab;
@property(nonatomic, strong) UISwitch *switchBtn;
@end

@implementation SWContactConfigCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }
    return self;
}


- (void)updateSwitchState:(BOOL)state {
    [self.switchBtn setOn:state];
}

#pragma mark - Common Init
- (void)commonInit {
    _titleLab = [[UILabel alloc] init];
    _titleLab.font = SW_DEFAULT_FONT_LARGE;
    _titleLab.textColor = SW_TAOBAO_BLACK;
    _titleLab.text = @"创建时同步到手机通讯录";
    [self.contentView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.contentView.mas_left).offset(SW_CELL_LEFT_MARGIN);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    _switchBtn = [[UISwitch alloc] init];
    [_switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:_switchBtn];
    [_switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.rightMargin.equalTo(self.contentView.mas_right).offset(-SW_CELL_LEFT_MARGIN);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@60);
        make.height.equalTo(@40);
    }];
}

-(void)switchAction:(UISwitch *)sender {
    self.stateChanged(sender.isOn);
}
@end
