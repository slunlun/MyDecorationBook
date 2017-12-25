//
//  SWProductTableViewCell.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/30/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import "SWProductTableViewCell.h"
#import "SWButton.h"
#import "SWProductCollectionViewCell.h"
#import "Masonry.h"

@interface SWProductTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong) UILabel *productNameLabel;
@property(nonatomic, strong) UILabel *priceLabel;
@property(nonatomic, strong) SWButton *selectedBtn;
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
    _productInfoView.backgroundColor = [UIColor clearColor];
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
        
    _selectedBtn = [[SWButton alloc] initWithButtonType:SWButtonLayoutTypeImageRight];
    [_selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_selectedBtn setImage:[UIImage imageNamed:@"ShoppingCartGreen"] forState:UIControlStateNormal];
    [_selectedBtn setTitle:NSLocalizedString(@"CHOOSE_PRODUCT", nil) forState:UIControlStateNormal];
    [self.productInfoView addSubview:_selectedBtn];
    
    [_productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productInfoView).offset(5);
        make.left.equalTo(self.productInfoView).offset(5);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productInfoView).offset(5);
        make.centerX.equalTo(self.productInfoView);
    }];
    
    [_selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productInfoView).offset(5);
        make.left.equalTo(_priceLabel.mas_right);
        make.right.equalTo(self.productInfoView);
    }];
    
    [_productInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@40);
    }];
    
    // step2. setup product picutres collection view
    UICollectionViewFlowLayout *collectionLayout = [UICollectionViewFlowLayout new];
    collectionLayout.minimumInteritemSpacing = 20;
    collectionLayout.minimumLineSpacing = 0;
    
    collectionLayout.itemSize = CGSizeMake(100, 100);
    //collectionLayout.sectionInset = UIEdgeInsetsMake(0, 1, 0, 1);
    collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _productPicturesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
    _productPicturesCollectionView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    [_productPicturesCollectionView registerClass:[SWProductCollectionViewCell class] forCellWithReuseIdentifier:@"SWProductCollectionViewCell"];
    _productPicturesCollectionView.delegate = self;
    _productPicturesCollectionView.dataSource = self;
    _productPicturesCollectionView.backgroundColor = [UIColor yellowColor];
    
    [self.contentView addSubview:_productPicturesCollectionView];
    [_productPicturesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@120);
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
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }else {
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentity = @"SWProductCollectionViewCell";
    SWProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentity forIndexPath:indexPath];
    cell.model = [UIImage imageNamed:@"Scan"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Press %@", indexPath);
}

#pragma mark - UI CallBack
- (void)delBtnClickCallBack:(UIButton *)button {
    if([self.delegate respondsToSelector:@selector(productTableViewCell:didClickDelProduct:)]) {
        [self.delegate productTableViewCell:self didClickDelProduct:self.productItem];
    }
}

- (void)editBtnClickCallBack:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(productTableViewCell:didClickEditProduct:)]) {
        [self.delegate productTableViewCell:self didClickEditProduct:self.productItem];
    }
}

- (void)takePhotoBtnClickCallback:(UICollectionViewCell *)collectionViewCell {
//    if (self.delegate respondsToSelector:@selector()) {
//        <#statements#>
//    }
}


@end
