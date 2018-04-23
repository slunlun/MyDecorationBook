//
//  SWOrderProductTableViewCell.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/4/23.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWOrderProductTableViewCell.h"
#import "Masonry.h"
#import "SWUIDef.h"

@interface SWOrderProductTableViewCell()
@property(nonatomic, strong) UILabel *labProductName;
@property(nonatomic, strong) UILabel *labProductRemark;
@property(nonatomic, strong) UILabel *labProductPrice;
@property(nonatomic, strong) UILabel *labProductOrderCount;
@property(nonatomic, strong) UIImageView *productThumbnail;
@end

@implementation SWOrderProductTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Common init
- (void)commonInit {
    _productThumbnail = [[UIImageView alloc] init];
    [self.contentView addSubview:_productThumbnail];
    [_productThumbnail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.contentView.mas_left).offset(0.5 * SW_MARGIN);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
        make.bottomMargin.equalTo(self.contentView.mas_bottom).offset(-SW_MARGIN);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(0.4);
    }];
    
    _labProductName = [[UILabel alloc] init];
    _labProductName.font = SW_DEFAULT_FONT;
    _labProductName.textColor = SW_TAOBAO_BLACK;
    _labProductName.textAlignment = NSTextAlignmentLeft;
    _labProductName.numberOfLines = 2;
    [self.contentView addSubview:_labProductName];
    [_labProductName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_productThumbnail.mas_right).offset(0.5 * SW_MARGIN);
        make.top.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
    }];
    
    _labProductRemark = [[UILabel alloc] init];
    _labProductRemark.font = SW_DEFAULT_SUPER_MIN_FONT;
    _labProductRemark.textColor = SW_DISABLE_GRAY;
    _labProductRemark.textAlignment = NSTextAlignmentLeft;
    _labProductRemark.numberOfLines = 0;
    [self.contentView addSubview:_labProductRemark];
    [_labProductRemark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_productThumbnail.mas_right).offset(0.5 * SW_MARGIN);
        make.top.equalTo(_labProductName.mas_bottom).offset(0.5 * SW_MARGIN);
        make.right.equalTo(self.contentView.mas_right).offset(-SW_MARGIN);
        make.height.equalTo(self.contentView.mas_height).multipliedBy(0.3);
    }];
    
    _labProductPrice = [[UILabel alloc] init];
    _labProductPrice.font = SW_DEFAULT_MIN_FONT;
    _labProductPrice.textColor = SW_TAOBAO_ORANGE;
    _labProductPrice.numberOfLines = 1;
    _labProductPrice.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_labProductPrice];
    [_labProductPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_productThumbnail.mas_right).offset(0.5 * SW_MARGIN);
        make.top.equalTo(_labProductRemark.mas_bottom).offset(0.5 * SW_MARGIN);
    }];
    
    _labProductOrderCount = [[UILabel alloc] init];
    _labProductOrderCount.font = SW_DEFAULT_MIN_FONT;
    _labProductOrderCount.textColor = SW_TAOBAO_BLACK;
    _labProductOrderCount.numberOfLines = 1;
    _labProductOrderCount.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_labProductOrderCount];
    [_labProductOrderCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-SW_MARGIN);
        make.top.equalTo(_labProductRemark.mas_bottom).offset(0.5 * SW_MARGIN);
    }];
}

#pragma mark - Update model
- (void)setModel:(SWProductItem *)productItem {
    if (productItem) {
        if (productItem.productPhotos.count > 0) {
            _productThumbnail.image = ((SWProductPhoto *)productItem.productPhotos.firstObject).photo;
            _productThumbnail.contentMode = UIViewContentModeScaleAspectFit;
        }else {
            _productThumbnail.image = [UIImage imageNamed:@"ProductThumb"];
            _productThumbnail.contentMode = UIViewContentModeCenter;
        }
        _labProductName.text = productItem.productName;
        _labProductRemark.text = productItem.productRemark;
        _labProductPrice.text = [NSString stringWithFormat:@"￥%.2lf", productItem.price];
        _labProductOrderCount.text = @"x1";
    }
}

- (void)updateProductOrderCount:(NSInteger)orderCount {
    _labProductOrderCount.text = [NSString stringWithFormat:@"x%ld", orderCount];
}
@end
