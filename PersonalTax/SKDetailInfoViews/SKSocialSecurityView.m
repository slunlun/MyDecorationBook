//
//  SKSocialSecurityView.m
//  SKIncomeTaxCalculator
//
//  Created by Tim (Xinyin) Liu on 2018/12/26.
//  Copyright © 2018 skyline. All rights reserved.
//

#import "SKSocialSecurityView.h"
#import "Masonry.h"
#import "SKSocialSecurityCell.h"

#define itemWtdth  ([UIScreen mainScreen].bounds.size.width-20)/5.0
static CGFloat itemHeight = 40.0;
@interface SKSocialSecurityView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, assign)CGFloat itemWidth;
@end
@implementation SKSocialSecurityView
- (instancetype)initWithDataArray:(NSArray<NSArray<NSString *> *> *)dataArray {
    if (self = [super init]) {
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
- (void)commonInit {
    self.itemWidth = ([UIScreen mainScreen].bounds.size.width-20)/5;
    UILabel *titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    titleLabel.text = @"三险一金详情";
    UILabel *messageLabel = [[UILabel alloc]init];
    messageLabel.text = @"* 三险一金由上年度平均月薪计算所得.若没有填写,由本年度月薪计算所得";
    messageLabel.numberOfLines = 0;
    messageLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:messageLabel];
    
    
    
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
    }];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(collectionView.mas_bottom).offset(8);
        make.left.right.equalTo(collectionView);
        make.height.equalTo(@30);
        make.bottom.equalTo(self).offset(-8);
    }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 | indexPath.section == self.dataArray.count-1)  {
        if (indexPath.row > 0) {
            return CGSizeMake(self.itemWidth*2, itemHeight);
        }
    }
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
- (void)setDataArray:(NSArray<NSArray<NSString *> *> *)dataArray {
    _dataArray = dataArray;
    [self.collectionView reloadData];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(dataArray.count *itemHeight));
    }];
}
@end
