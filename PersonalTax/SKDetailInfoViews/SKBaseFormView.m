//
//  SKBaseFormView.m
//  SKIncomeTaxCalculator
//
//  Created by Tim (Xinyin) Liu on 2018/12/26.
//  Copyright © 2018 skyline. All rights reserved.
//

#import "SKBaseFormView.h"
#import "Masonry.h"
#import "SKSocialSecurityCell.h"
static CGFloat itemHeight = 40.0;

@interface SKBaseFormView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, assign)CGFloat itemWidth;

@end
@implementation SKBaseFormView
- (instancetype)initWithDataArray:(NSArray<NSArray<NSString *> *> *)dataArray {
    self = [super init];
    if (self) {
        self.dataArray = dataArray;
        [self commonInit];
    }
    return self;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void)setDataArray:(NSArray<NSArray<NSString *> *> *)dataArray {
    _dataArray = dataArray;
    self.itemWidth = ([UIScreen mainScreen].bounds.size.width-20)/dataArray.firstObject.count;
    [self.collectionView reloadData];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(dataArray.count * itemHeight));
    }];
}
- (void)commonInit {
    if (self.dataArray) {
        self.itemWidth = ([UIScreen mainScreen].bounds.size.width-20)/self.dataArray.firstObject.count;
    }else{
        self.itemWidth = 100;
    }
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.scrollEnabled = NO;
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[SKSocialSecurityCell class] forCellWithReuseIdentifier:@"cell"];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@30);
    }];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@(itemHeight));
        make.bottom.equalTo(self).offset(-8);
    }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.itemWidth, itemHeight);
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray[section].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SKSocialSecurityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.infoStr = self.dataArray[indexPath.section][indexPath.row];
    if (indexPath.row>0) {
        //        cell.textColor = [UIColor redColor];
    }
    return cell;
}
@end
