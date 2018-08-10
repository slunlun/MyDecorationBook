//
//  SWOrderInfoPhotoTableViewCell.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/10.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWOrderInfoPhotoTableViewCell.h"
#import "SWProductCollectionViewCell.h"
#import "Masonry.h"
#import "SWUIDef.h"
static NSString *cellIdentify = @"SWProductCollectionViewCell";
@interface SWOrderInfoPhotoTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong) UICollectionView *shoppingItemPhotoCollectionView;
@end

@implementation SWOrderInfoPhotoTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    // step2. setup product picutres collection view
    UICollectionViewFlowLayout *collectionLayout = [UICollectionViewFlowLayout new];
    collectionLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
    collectionLayout.itemSize = CGSizeMake(100, 100);
    //collectionLayout.sectionInset = UIEdgeInsetsMake(0, 1, 0, 1);
    collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _shoppingItemPhotoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
    _shoppingItemPhotoCollectionView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    [_shoppingItemPhotoCollectionView registerClass:[SWProductCollectionViewCell class] forCellWithReuseIdentifier:cellIdentify];
    _shoppingItemPhotoCollectionView.delegate = self;
    _shoppingItemPhotoCollectionView.dataSource = self;
    _shoppingItemPhotoCollectionView.backgroundColor = [UIColor yellowColor];
    
    [self.contentView addSubview:_shoppingItemPhotoCollectionView];
    [_shoppingItemPhotoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.contentView.mas_left).offset(SW_MARGIN);
        make.rightMargin.equalTo(self.contentView.mas_right).offset(-SW_MARGIN);
        make.height.equalTo(@120);
        make.top.equalTo(self.contentView);
    }];
}

#pragma mark - Setter/Getter
- (void)setPhotos:(NSMutableArray *)photos {
    _photos = photos;
    [self.shoppingItemPhotoCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.photoCellClicked) {
        self.photoCellClicked(indexPath.row);
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SWProductCollectionViewCell *cell = (SWProductCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentify forIndexPath:indexPath];
    cell.supportEdit = NO;
    cell.model = self.photos[indexPath.row];
    cell.productImage.contentMode = UIViewContentModeScaleToFill;
    return cell;
}
@end
