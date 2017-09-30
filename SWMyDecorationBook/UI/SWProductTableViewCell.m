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

@interface SWProductTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong) UILabel *productNameLabel;
@property(nonatomic, strong) UILabel *priceLabel;
@property(nonatomic, strong) LZRelayoutButton *selectedBtn;
@property(nonatomic, strong) UICollectionView *productPicturesCollectionView;
@property(nonatomic, strong) UIButton *delBtn;
@property(nonatomic, strong) UIButton *editBtn;

@property(nonatomic, strong) UIView *productInfoView;

@end

@implementation SWProductTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark - UI init
- (void) commonInit {
    
    // step1. step up product info
    _productInfoView = [[UIView alloc] init];
    _productInfoView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_productInfoView];
    _productNameLabel = [[UILabel alloc] init];
    _productNameLabel.numberOfLines = 0;
    _productNameLabel.backgroundColor = [UIColor blueColor];
    
    _productNameLabel.textAlignment = NSTextAlignmentLeft;
    [self.productInfoView addSubview:_productNameLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.numberOfLines = 1;
    _priceLabel.textAlignment = NSTextAlignmentLeft;
    [self.productInfoView addSubview:_priceLabel];
    
    _selectedBtn = [[LZRelayoutButton alloc] init];
    [_selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _selectedBtn.lzType = LZRelayoutButtonTypeLeft;
    _selectedBtn.imageSize = CGSizeMake(30.0f, 30.0f);
    [_selectedBtn setImage:[UIImage imageNamed:@"ShoppingCartGreen"] forState:UIControlStateNormal];
    _selectedBtn.offset = 1.0f;
    [_selectedBtn setTitle:NSLocalizedString(@"CHOOSE_PRODUCT", nil) forState:UIControlStateNormal];
    [self.productInfoView addSubview:_selectedBtn];
    
    [_productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productInfoView);
        make.left.equalTo(self.productInfoView).offset(5);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productInfoView);
        make.centerX.equalTo(self.productInfoView);
    }];
    
    [_selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productInfoView);
        make.left.equalTo(_priceLabel.mas_right);
        make.right.equalTo(self.productInfoView);
    }];
    
    [_productInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@20);
    }];
    
    // step2. setup product picutres collection view
    
    _productPicturesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
    _productPicturesCollectionView.delegate = self;
    _productPicturesCollectionView.dataSource = self;
    
    [self.contentView addSubview:_productPicturesCollectionView];
    [_productPicturesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@80);
        make.top.equalTo(_productInfoView.mas_bottom);
    }];
    
    // step3. setup del/edit button
    _delBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_delBtn setImage:[UIImage imageNamed:@"RubbishBin"] forState:UIControlStateNormal];
    [_delBtn addTarget:self action:@selector(delBtnClickCallBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_delBtn];
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_editBtn setImage:[UIImage imageNamed:@"EditPen"] forState:UIControlStateNormal];
    [_editBtn addTarget:self action:@selector(editBtnClickCallBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_editBtn];
    
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productPicturesCollectionView.mas_bottom).offset(5);
        make.right.equalTo(self.contentView);
        make.width.height.equalTo(@40);
    }];
    
    [_delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productPicturesCollectionView.mas_bottom).offset(5);
        make.right.equalTo(_editBtn.mas_left);
        make.width.height.equalTo(@40);
    }];
    
}
#pragma mark - Init/Setter/Getter
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self commonInit];
    }
    return self;
}


- (void)setProductItem:(SWProductItem *)productItem {
    if ([_productItem isEqual:productItem]) {
        return;
    }
    
    _productItem = productItem;
    
    self.productNameLabel.text = productItem.productName;
    self.priceLabel.text = [NSString stringWithFormat:@"%lf", productItem.price];
    
    if (productItem.isChoosed) {
        self.selectedBtn.backgroundColor = [UIColor greenColor];
    }else {
        self.selectedBtn.backgroundColor = [UIColor whiteColor];
    }
    
    [self.productPicturesCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.productItem) {
        return self.productItem.productPictures.count;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentity = @"CELL_IDENTITY";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentity forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UI CallBack
- (void)delBtnClickCallBack:(UIButton *)button {

}

- (void)editBtnClickCallBack:(UIButton *)button {

}


@end
