//
//  SWMarketCategoryTableViewCell.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/4/17.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWMarketCategoryTableViewCell.h"
#import "Masonry.h"
#import "SWUIDef.h"

@interface SWMarketCategoryTableViewCell()
@property(nonatomic, weak) UIButton *configBtn;
@end

@implementation SWMarketCategoryTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commitInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        [self.configBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-20);
        }];
    }else {
        [self.configBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(40);
        }];
    }
}

- (void)commitInit {
    
    self.textLabel.font = SW_DEFAULT_FONT_LARGE;
    self.backgroundColor = SW_TAOBAO_BLACK;
    self.textLabel.textColor = SW_DISABLE_GRAY;
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    UIButton *configBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [configBtn setBackgroundImage:[UIImage imageNamed:@"Config@32"] forState:UIControlStateNormal];
    [self.contentView addSubview:configBtn];
    [configBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.right.equalTo(self.contentView).offset(40);
        make.width.equalTo(@32);
    }];
    [configBtn addTarget:self action:@selector(configBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _configBtn = configBtn;
}

- (void)setModel:(SWMarketCategory *)model {
    _model = model;
    self.textLabel.text = model.categoryName;
}

- (void)configBtnClicked:(UIButton *)configBtn {
    if (self.configBtnCallback) {
        self.configBtnCallback(self.model);
    }
}
@end
