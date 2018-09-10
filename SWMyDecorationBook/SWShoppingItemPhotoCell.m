//
//  SWShoppingItemPhotoCell.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/9/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWShoppingItemPhotoCell.h"
#import "SWProductCollectionViewCell.h"
#import "Masonry.h"
#import "SWUIDef.h"
#import "SWDef.h"

static NSString *cellIdentify = @"SWProductCollectionViewCell";
@interface SWShoppingItemPhotoCell()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong) UICollectionView *shoppingItemPhotoCollectionView;
@end

@implementation SWShoppingItemPhotoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _photos = [[NSMutableArray alloc] init];
        [self commonInit];
    }
    return self;
}

#pragma mark - Common init
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
    _shoppingItemPhotoCollectionView.backgroundColor = [UIColor clearColor];
    
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
    if (indexPath.section == 0) {
        if (self.photoCellClicked) {
            self.photoCellClicked(indexPath.row);
        }
    }else {
        if (self.takeNewPhoto) {
            self.takeNewPhoto();
        }
    }
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    }else {
        return self.photos.count;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SWProductCollectionViewCell *cell = (SWProductCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentify forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.supportEdit = YES;
    }else {
        cell.supportEdit = NO;
    }
    
    WeakObj(self);
    cell.actionBlock = ^() {
        StrongObj(self);
        if (self.delPhoto) {
            self.delPhoto(indexPath.row);
        }
        
    };
    if (indexPath.section == 1) {
        SWProductPhoto *model = [[SWProductPhoto alloc] initWithImage:[UIImage imageNamed:@"Scan"]];
        cell.model = model;
        cell.productImage.contentMode = UIViewContentModeCenter;
    }else{
        cell.model = self.photos[indexPath.row];
        cell.productImage.contentMode = UIViewContentModeScaleToFill;
    }
    return cell;
}

#pragma mark - UICo

@end
