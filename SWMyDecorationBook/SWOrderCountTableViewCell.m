//
//  SWOrderCountTableViewCell.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/4/20.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWOrderCountTableViewCell.h"
#import "SWAddSubView.h"
#import "SWUIDef.h"
#import "Masonry.h"
@interface SWOrderCountTableViewCell()<SWAddSubViewDelegate>
@property(nonatomic, strong) UILabel *titleLab;
@property(nonatomic, strong) SWAddSubView *addSubView;
@property(nonatomic, strong) SWOrder *orderInfo;
@end

@implementation SWOrderCountTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }
    return self;
}


#pragma mark - Common Init
- (void)commonInit {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.font = SW_DEFAULT_FONT;
    _titleLab.textColor = SW_TAOBAO_BLACK;
    _titleLab.text = @"购买数量";
    [self.contentView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.contentView.mas_left).offset(SW_CELL_LEFT_MARGIN);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
        make.bottomMargin.equalTo(self.contentView.mas_bottom).offset(-SW_MARGIN);
    }];
    
    _addSubView = [[SWAddSubView alloc] init];
    _addSubView.delegate = self;
    [self.contentView addSubview:_addSubView];
    [_addSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-SW_MARGIN);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN + 3);
        make.height.equalTo(_titleLab.mas_height).offset(-10);
        make.width.equalTo(@130);
    }];
}

- (void)setOrderInfo:(SWOrder *)orderInfo {
    _orderInfo = orderInfo;
    [self.addSubView updateCountNum:self.orderInfo.itemCount];
}

- (void)updateOrderCount:(CGFloat)orderCount {
    [self.addSubView updateCountNum:orderCount];
}

#pragma mark - SWAddSubViewDelegate
- (void)SWAddSubView:(SWAddSubView *)addSubView didUpdateCount:(CGFloat)count {
    if (self.orderCountUpdateBlock) {
        self.orderCountUpdateBlock(count);
    }
}
@end
