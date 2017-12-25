//
//  SWLeftSlideViewControllerCollectionViewController.m
//  SWMyDecorationBook
//
//  Created by ShiTeng on 2017/12/25.
//  Copyright © 2017年 Eren. All rights reserved.
//

#import "SWLeftSlideCollectionViewController.h"
#import "Masonry.h"

static NSString *SHOP_ITEM_CELL_IDENTITY = @"SHOP_ITEM_CELL_IDENTITY";
@interface SWLeftSlideCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic,strong) UICollectionView *shoppingCategoryCollectionView;
@end

@implementation SWLeftSlideCollectionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 0.0f;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.shoppingCategoryCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.shoppingCategoryCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.shoppingCategoryCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:SHOP_ITEM_CELL_IDENTITY];
    
    [self.view addSubview:self.shoppingCategoryCollectionView];
    [self.shoppingCategoryCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.mas_topLayoutGuideBottom);
        }
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).offset(-40);
        }
    }];
    
    self.shoppingCategoryCollectionView.dataSource = self;
    self.shoppingCategoryCollectionView.delegate = self;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMoving:)];
    [self.shoppingCategoryCollectionView addGestureRecognizer:longPress];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)longPressMoving:(UILongPressGestureRecognizer *)longPress {
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath* selectedIndex = [self.shoppingCategoryCollectionView indexPathForItemAtPoint:[longPress locationInView:self.shoppingCategoryCollectionView]];
            [self.shoppingCategoryCollectionView beginInteractiveMovementForItemAtIndexPath:selectedIndex];
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self.shoppingCategoryCollectionView updateInteractiveMovementTargetPosition:[longPress locationInView:self.shoppingCategoryCollectionView]];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self.shoppingCategoryCollectionView endInteractiveMovement];
        }
            break;
        default:{
            [self.shoppingCategoryCollectionView cancelInteractiveMovement];
        }
            break;
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SHOP_ITEM_CELL_IDENTITY forIndexPath:indexPath];
    CGFloat redFactor = arc4random()%256;
    CGFloat greenFactor = arc4random()%256;
    CGFloat blueFactor = arc4random()%256;
    
    UIColor *backgroundColor = [UIColor colorWithRed:redFactor/255 green:greenFactor/255 blue:blueFactor/255 alpha:1.0];
    cell.backgroundColor = backgroundColor;
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath {
    
}
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
