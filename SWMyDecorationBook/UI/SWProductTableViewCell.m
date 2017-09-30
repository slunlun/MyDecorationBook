//
//  SWProductTableViewCell.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/30/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import "SWProductTableViewCell.h"
#import "LZRelayoutButton.h"
#import "Masonry.h"

@interface SWProductTableViewCell()
@property(nonatomic, strong) UILabel *productNameLabel;
@property(nonatomic, strong) UILabel *priceLabel;
@property(nonatomic, strong) LZRelayoutButton *selectedBtn;
@property(nonatomic, strong) UICollectionView *productPicturesCollectionView;
@property(nonatomic, strong) UIButton *delBtn;
@property(nonatomic, strong) UIButton *editBtn;

@property(nonatomic, strong) UIView *productInfoView;

@end

@implementation SWProductTableViewCell

- (void)setProductItem:(SWProductItem *)productItem {

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark - UI init
- (void) commonInit {
    _productInfoView = [[UIView alloc] init];
    [self.contentView addSubview:_productInfoView];
    
    _productNameLabel = [[UILabel alloc] init];
    _productNameLabel.numberOfLines = 1;
    _productNameLabel.textAlignment = NSTextAlignmentLeft;
    [self.productInfoView addSubview:_productNameLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.numberOfLines = 1;
    _priceLabel.textAlignment = NSTextAlignmentLeft;
    [self.productInfoView addSubview:_priceLabel];
    
    _selectedBtn = [[LZRelayoutButton alloc] init];
    _selectedBtn.lzType = LZRelayoutButtonTypeLeft;
    _selectedBtn.imageSize = CGSizeMake(30.0f, 30.0f);
    _selectedBtn.offset = 5.0f;
    [self.productInfoView addSubview:_selectedBtn];
    
    [_productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productInfoView);
        make.left.equalTo(self.productInfoView).offset(5);
        make.width.equalTo(@100);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productInfoView);
        make.left.equalTo(_productNameLabel.mas_right);
        make.width.equalTo(@80);
    }];
    
    [_selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productInfoView);
        make.left.equalTo(_priceLabel.mas_right);
        make.right.equalTo(self.productInfoView);
    }];
    
    
    
    
    
}

@end
