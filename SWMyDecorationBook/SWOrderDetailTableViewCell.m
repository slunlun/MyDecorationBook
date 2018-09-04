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
@property(nonatomic, strong) UILabel *orderDateLab;
@property(nonatomic, strong) UILabel *shoppingItemNameLab;
@property(nonatomic, strong) UILabel *shoppingItemPrice;
@property(nonatomic, strong) UILabel *orderCountLab;
@property(nonatomic, strong) UILabel *orderTotalPriceLab;
@property(nonatomic, strong) UILabel *orderRemarkLab;
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
    self.orderCountLab.text = [NSString stringWithFormat:@"x %.2f", orderInfo.itemCount];
    self.orderTotalPriceLab.text = [NSString stringWithFormat:@"%.2f", orderInfo.orderTotalPrice];
    self.shoppingItemPrice.text = [NSString stringWithFormat:@"￥%.2f/%@", orderInfo.productItem.price, orderInfo.productItem.itemUnit.unitTitle];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    //NSDate转NSString
    NSString *orderDateStr = [dateFormatter stringFromDate:orderInfo.orderDate];
    self.orderDateLab.text = orderDateStr;
    if (self.shouldDispalyRemark) {
        self.orderRemarkLab.text = orderInfo.orderRemark?orderInfo.orderRemark:@"";
    }
}

#pragma mark - CommonInit
- (void)commonInit {
    _orderDateLab = [[UILabel alloc] init];
    _orderDateLab.textAlignment = NSTextAlignmentLeft;
    _orderDateLab.textColor = SW_TAOBAO_ORANGE;
    _orderDateLab.font = SW_DEFAULT_SUPER_MIN_FONT;
    [self.contentView addSubview:_orderDateLab];
    [_orderDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    _shoppingItemPrice = [[UILabel alloc] init];
    _shoppingItemPrice.textAlignment = NSTextAlignmentLeft;
    _shoppingItemPrice.textColor = SW_TAOBAO_BLACK;
    _shoppingItemPrice.font = SW_DEFAULT_MIN_FONT;
    [self.contentView addSubview:_shoppingItemPrice];
    [_shoppingItemPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_shoppingItemNameLab.mas_bottom).offset(2);
        make.leftMargin.equalTo(self.contentView.mas_left).offset(SW_CELL_LEFT_MARGIN);
    }];
    
    _orderRemarkLab = [[UILabel alloc] init];
    _orderRemarkLab.textAlignment = NSTextAlignmentRight;
    _orderRemarkLab.textColor = SW_DISABLE_GRAY;
    _orderRemarkLab.font = SW_DEFAULT_MIN_FONT;
    [self.contentView addSubview:_orderRemarkLab];
    [_orderRemarkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_shoppingItemPrice.mas_bottom).offset(2);
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
