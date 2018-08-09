//
//  SWOrderDetailTableViewCell.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/9.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWOrderDetailTableViewCell.h"
#import "Masonry.h"
#import "SWUIDef.h"

@interface SWOrderDetailTableViewCell()
@property(nonatomic, strong) UILabel *marketNameLab;
@property(nonatomic, strong) UILabel *shoppingItemNameLab;
@property(nonatomic, strong) UILabel *orderCountLab;
@property(nonatomic, strong) UILabel *orderTotalPriceLab;
@end

@implementation SWOrderDetailTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self commonInit];
    }
    return self;
}

- (void)updateOrderInfo:(SWOrder *)orderInfo {
    self.shoppingItemNameLab.text = orderInfo.productItem.productName;
    self.orderCountLab.text = [NSString stringWithFormat:@"x %.2f%@", orderInfo.itemCount, orderInfo.productItem.itemUnit.unitTitle];
    self.orderTotalPriceLab.text = [NSString stringWithFormat:@"%.2f", orderInfo.orderTotalPrice];
    self.marketNameLab.text = orderInfo.marketItem.marketName;
}

#pragma mark - CommonInit
- (void)commonInit {
    _marketNameLab = [[UILabel alloc] init];
    _marketNameLab.textAlignment = NSTextAlignmentLeft;
    _marketNameLab.textColor = SW_TAOBAO_ORANGE;
    _marketNameLab.font = SW_DEFAULT_SUPER_MIN_FONT;
    [self.contentView addSubview:_marketNameLab];
    [_marketNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(2);
        make.leftMargin.equalTo(self.contentView.mas_left).offset(SW_CELL_LEFT_MARGIN);
    }];
    
    _shoppingItemNameLab = [[UILabel alloc] init];
    _shoppingItemNameLab.textAlignment = NSTextAlignmentLeft;
    _shoppingItemNameLab.textColor = SW_TAOBAO_BLACK;
    _shoppingItemNameLab.font = SW_DEFAULT_FONT_LARGE_BOLD;
    [self.contentView addSubview:_shoppingItemNameLab];
    [_shoppingItemNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_centerY).offset(10);
        make.leftMargin.equalTo(self.contentView.mas_left).offset(SW_CELL_LEFT_MARGIN);
    }];
    
    _orderCountLab = [[UILabel alloc] init];
    _orderCountLab.textAlignment = NSTextAlignmentCenter;
    _orderCountLab.textColor = SW_LIGHT_GRAY;
    _orderCountLab.font = SW_DEFAULT_MIN_FONT;
    [self.contentView addSubview:_orderCountLab];
    [_orderCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_centerY).offset(10);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    _orderTotalPriceLab = [[UILabel alloc] init];
    _orderTotalPriceLab.textAlignment = NSTextAlignmentLeft;
    _orderTotalPriceLab.textColor = SW_MAIN_BLUE_COLOR;
    _orderTotalPriceLab.font = SW_DEFAULT_FONT_BOLD;
    [self.contentView addSubview:_orderTotalPriceLab];
    [_orderTotalPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_centerY).offset(10);
        make.rightMargin.equalTo(self.contentView.mas_right).offset(-SW_CELL_LEFT_MARGIN);
    }];
}

@end
