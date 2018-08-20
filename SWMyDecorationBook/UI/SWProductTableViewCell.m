//
//  SWProductTableViewCell.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/30/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import "SWProductTableViewCell.h"
#import "SWProductPhoto.h"
#import "SWButton.h"
#import "SWProductCollectionViewCell.h"
#import "Masonry.h"
#import "SWUIDef.h"
#import "HexColor.h"
#import "SWDef.h"

@interface SWProductTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource, CAAnimationDelegate>
@property(nonatomic, strong) UILabel *productNameLabel;
@property(nonatomic, strong) UILabel *priceLabel;
@property(nonatomic, strong) UICollectionView *productPicturesCollectionView;
@property(nonatomic, strong) UIButton *delBtn;
@property(nonatomic, strong) UIButton *editBtn;
@property(nonatomic, strong) UILabel *productMarkLabel;

@property(nonatomic, strong) UIView *productInfoView;

@property(nonatomic, assign) CGRect originalFrame;
@property(nonatomic, strong) SWProductCollectionViewCell *selectedCell;
@property(nonatomic, strong) UIView *coverView;
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
    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    self.contentView.layer.shadowOpacity = 0.1f;
    // step1. step up product info
    _productInfoView = [[UIView alloc] init];
    _productInfoView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_productInfoView];
    [_productInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@40);
    }];
    
    
    _productNameLabel = [[UILabel alloc] init];
    _productNameLabel.numberOfLines = 0;
    _productNameLabel.font = SW_DEFAULT_FONT;
    _productNameLabel.textColor = SW_TAOBAO_ORANGE;
    _productNameLabel.textAlignment = NSTextAlignmentLeft;
    [self.productInfoView addSubview:_productNameLabel];
    [_productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productInfoView).offset(8);
        make.left.equalTo(self.productInfoView).offset(SW_CELL_LEFT_MARGIN);
    }];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.numberOfLines = 1;
    _priceLabel.textAlignment = NSTextAlignmentLeft;
    _priceLabel.font = SW_DEFAULT_MIN_FONT;
    _priceLabel.textColor = [UIColor colorWithHexString:@"#e67e22"];
    [self.productInfoView addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.productInfoView);
        make.centerY.equalTo(_productNameLabel);
    }];
    
//    _editBtn = [[UIButton alloc] initWithFrame:CGRectZero];
//    _editBtn.userInteractionEnabled = NO;
//    [_editBtn setImage:[UIImage imageNamed:@"Edit"] forState:UIControlStateNormal];
//    _editBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
//    [_editBtn addTarget:self action:@selector(editBtnClickCallBack:) forControlEvents:UIControlEventTouchUpInside];
//    [self.productInfoView addSubview:_editBtn];
//    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.productInfoView).offset(8);
//        make.rightMargin.equalTo(_productInfoView.mas_right).offset(-SW_MARGIN);
//        make.width.equalTo(@40);
//        make.height.equalTo(@40);
//    }];
    
    // step2. setup product picutres collection view
    UICollectionViewFlowLayout *collectionLayout = [UICollectionViewFlowLayout new];
    collectionLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
    collectionLayout.itemSize = CGSizeMake(120, 120);
    //collectionLayout.sectionInset = UIEdgeInsetsMake(0, 1, 0, 1);
    collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _productPicturesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
    _productPicturesCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [_productPicturesCollectionView registerClass:[SWProductCollectionViewCell class] forCellWithReuseIdentifier:@"SWProductCollectionViewCell"];
    _productPicturesCollectionView.delegate = self;
    _productPicturesCollectionView.dataSource = self;
    _productPicturesCollectionView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_productPicturesCollectionView];
    [_productPicturesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.contentView.mas_left).offset(SW_MARGIN);
        make.rightMargin.equalTo(self.contentView.mas_right).offset(-SW_MARGIN);
        make.height.equalTo(@120);
        make.top.equalTo(_productInfoView.mas_bottom);
    }];
    
    _productMarkLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _productMarkLabel.font = SW_DEFAULT_SUPER_MIN_FONT;
    _productMarkLabel.textColor = [UIColor colorWithHexString:@"#bdc3c7"];
    [self.contentView addSubview:_productMarkLabel];
    [_productMarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(SW_MARGIN);
        make.top.equalTo(self.productPicturesCollectionView.mas_bottom).offset(20);
        make.width.lessThanOrEqualTo(self.contentView.mas_width).multipliedBy(0.7);
    }];
    
    // step3. setup del/edit button
    _delBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_delBtn setImage:[UIImage imageNamed:@"Del"] forState:UIControlStateNormal];
    [_delBtn addTarget:self action:@selector(delBtnClickCallBack:) forControlEvents:UIControlEventTouchUpInside];
    _delBtn.imageView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:_delBtn];
    [_delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productPicturesCollectionView.mas_bottom).offset(5);
        make.right.equalTo(self.productPicturesCollectionView);
        make.width.height.equalTo(@30);
    }];
    
    _buyBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_buyBtn setImage:[UIImage imageNamed:@"Buy"] forState:UIControlStateNormal];
    _buyBtn.imageView.contentMode = UIViewContentModeCenter;
    [_buyBtn addTarget:self action:@selector(buyBtnClickCallBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_buyBtn];
    [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productPicturesCollectionView.mas_bottom).offset(5);
        make.right.equalTo(_delBtn.mas_left).offset(-10);
        make.width.height.equalTo(@30);
    }];
}
#pragma mark - Init/Setter/Getter
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = SW_TAOBAO_WHITE;
        [self commonInit];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyItemNotification:) name:SW_BUY_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unbuyItemNotification:) name:SW_UNBUY_NOTIFICATION object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setProductItem:(SWProductItem *)productItem {
    _productItem = productItem;
    self.productNameLabel.text = productItem.productName;
    NSString *priceStr = nil;
    if (fmodf(productItem.price, 1)==0) {
        priceStr = [NSString stringWithFormat:@"￥%.0f",productItem.price];
    } else if (fmodf(productItem.price*10, 1)==0) {
        priceStr = [NSString stringWithFormat:@"￥%.1f",productItem.price];
    } else {
        priceStr = [NSString stringWithFormat:@"￥%.2f",productItem.price];
    }
    self.priceLabel.text = priceStr;
    self.productMarkLabel.text = productItem.productRemark;
    if (productItem.isChoosed) {
        [self.buyBtn setImage:[UIImage imageNamed:@"BuyDone"] forState:UIControlStateNormal];
    }else{
        [self.buyBtn setImage:[UIImage imageNamed:@"Buy"] forState:UIControlStateNormal];
    }
    [self.productPicturesCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.productItem.productPhotos.count;
    }else {
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSString *cellIdentity = @"SWProductCollectionViewCell";
        SWProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentity forIndexPath:indexPath];
        SWProductPhoto *productPhoto = self.productItem.productPhotos[indexPath.row];
        cell.model = productPhoto.photo;
        cell.productImage.contentMode = UIViewContentModeScaleToFill;
        return cell;
    }else {
        NSString *cellIdentity = @"SWProductCollectionViewCell";
        SWProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentity forIndexPath:indexPath];
        cell.model = [UIImage imageNamed:@"Scan"];
        cell.productImage.contentMode = UIViewContentModeCenter;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SWProductCollectionViewCell *cell = (SWProductCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        [self enlargeCell:cell];
    }else {
        if ([self.delegate respondsToSelector:@selector(productTableViewCell:didClickTakeProductPhoto:)]) {
            [self.delegate productTableViewCell:self didClickTakeProductPhoto:self.productItem];
        }
    }
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

- (void)buyBtnClickCallBack:(UIButton *)button {
    if (self.productItem.isChoosed) {
        if ([self.delegate respondsToSelector:@selector(productTableViewCell:didUnBuyProduct:)]) {
            [self.delegate productTableViewCell:self didUnBuyProduct:self.productItem];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(productTableViewCell:didClickBuyProduct:)]) {
            [self.delegate productTableViewCell:self didClickBuyProduct:self.productItem];
        }
    }
}

- (void)takePhotoBtnClickCallback:(UICollectionViewCell *)collectionViewCell {
//    if (self.delegate respondsToSelector:@selector()) {
//        <#statements#>
//    }
}

- (void)enlargeCell:(SWProductCollectionViewCell *)cell {
    UIImageView *animationView = [[UIImageView alloc] initWithImage:cell.productImage.image];
    cell.productImage.image = nil;
    self.selectedCell = cell;
    animationView.userInteractionEnabled = YES;
    animationView.layer.shadowColor = [UIColor blackColor].CGColor;
    animationView.layer.shadowOpacity = 0.6;
    animationView.layer.shadowRadius = 10.0;
    animationView.layer.shadowOffset = CGSizeMake(10, 10);
    
    UITapGestureRecognizer *tapGestrure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(restoreCell:)];
    [animationView addGestureRecognizer:tapGestrure];
    
    
    UIView *rootWindow = [[[UIApplication sharedApplication] delegate] window];
    
    self.coverView = [[UIView alloc] initWithFrame:rootWindow.frame];
    self.coverView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [rootWindow addSubview:self.coverView];
    
    CGRect originalFrame = [cell.productImage convertRect:cell.productImage.frame toView:rootWindow];
    animationView.frame = originalFrame;
    self.originalFrame = originalFrame;
    [rootWindow addSubview:animationView];
    
    [UIView animateWithDuration:0.1 animations:^{
        animationView.center = rootWindow.center;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionLayoutSubviews animations:^{
                animationView.frame = CGRectMake(0, 0, rootWindow.frame.size.width, rootWindow.frame.size.height);
            } completion:^(BOOL finished) {
                
            }];
        }
    }];
}

- (void)restoreCell:(UITapGestureRecognizer *)tapGesture {
    UIView *rootWindow = [[[UIApplication sharedApplication] delegate] window];
    UIImageView *animationView = (UIImageView *)tapGesture.view;
    
    [UIView animateWithDuration:0.1 animations:^{
        animationView.center = rootWindow.center;
        animationView.frame = CGRectMake(rootWindow.center.x - self.originalFrame.size.width/2, rootWindow.center.y - self.originalFrame.size.height/2, self.originalFrame.size.width, self.originalFrame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionLayoutSubviews animations:^{
                animationView.frame = self.originalFrame;
            } completion:^(BOOL finished) {
                [animationView removeFromSuperview];
                self.selectedCell.productImage.image = animationView.image;
                [self.coverView removeFromSuperview];
                self.selectedCell = nil;
                self.coverView = nil;
            }];
        }
    }];
}
#pragma mark - CAAnimationDelegate

#pragma mark - Animation
- (void)viewRock:(UIView *)view {
    CAAnimationGroup *animationGroup=[CAAnimationGroup animation]; // 动画组
    animationGroup.delegate = self;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue = [NSNumber numberWithFloat:-M_PI / 4];
    animation.toValue = [NSNumber numberWithFloat:M_PI / 4];
    
    animation.autoreverses = YES; //设置YES，代表动画每次重复执行的效果和上一次的相反
    animation.duration = 0.5; //一次动画的完成时间

    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation2.fromValue = @1;
    animation2.toValue = @2;
    animation2.duration = 1.0;
    animation2.autoreverses = NO;
    
    animationGroup.animations = @[animation, animation2];
    
    [view.layer addAnimation:animationGroup forKey:@"rockAnimation"];
}

#pragma mark - Notification reaction
- (void)buyItemNotification:(NSNotification *)notification {
    SWProductItem *product = (SWProductItem *)notification.userInfo[SW_NOTIFICATION_PRODUCT_KEY];
    if (product) {
        if ([product isEqual:self.productItem]) {
            self.productItem.choosed = YES;
            [self.buyBtn setImage:[UIImage imageNamed:@"BuyDone"] forState:UIControlStateNormal];
            [self viewRock:self.buyBtn];
        }
    }
}

- (void)unbuyItemNotification:(NSNotification *)notification {
    SWProductItem *product = (SWProductItem *)notification.userInfo[SW_NOTIFICATION_PRODUCT_KEY];
    if (product) {
        if ([product isEqual:self.productItem]) {
            self.productItem.choosed = NO;
            [self.buyBtn setImage:[UIImage imageNamed:@"Buy"] forState:UIControlStateNormal];
        }
    }
}
@end
