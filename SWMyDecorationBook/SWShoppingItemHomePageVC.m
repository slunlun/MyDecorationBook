//
//  SWRedViewController.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/25/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import "SWShoppingItemHomePageVC.h"
#import "AppDelegate.h"
#import "Masonry.h"
#import "SWProductTableViewCell.h"
#import "SWMarketHeaderView.h"
#import "SWMarketViewController.h"
#import "TZImagePickerController.h"
#import "SWShoppingItemInfoViewController.h"
#import "SWDef.h"
#import "SWUIDef.h"
#import "SWMarketStorage.h"
#import "SWProductPhoto.h"
#import "SWProductItemStorage.h"
#import "SWMarketCategoryStorage.h"
#import "SWOrderView.h"
#import "SWNotebookHomeViewController.h"
#import "SWProductOrderStorage.h"
#import "UIView+UIExt.h"

@interface SWShoppingItemHomePageVC () <UITableViewDelegate, UITableViewDataSource, SWProductTableViewCellDelegate, SWOrderViewDelegate>
@property(nonatomic, strong) UIView *dragMoveView;
@property(nonatomic, assign) CGPoint preTranslation;
@property(nonatomic, strong) UITableView *shoppingItemListTableView;
@property(nonatomic, strong) NSArray *marketItems;
@property(nonatomic, strong) UIBarButtonItem *notebookItemBtn;
@end

@implementation SWShoppingItemHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SW_TAOBAO_WHITE;
    [self commitInit];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:SW_HOME_PAGE_DISAPPEAR_NOTIFICATION object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:SW_HOME_PAGE_APPEAR_NOTIFICATION object:nil];
    [self updateData];
    [self.shoppingItemListTableView reloadData];
}

- (void)commitInit{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _shoppingItemListTableView = [[UITableView alloc] init];
    _shoppingItemListTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _shoppingItemListTableView.dataSource = self;
    _shoppingItemListTableView.delegate = self;
    [_shoppingItemListTableView registerClass:[SWProductTableViewCell class] forCellReuseIdentifier:@"PRODUCT_CELL"];
    [_shoppingItemListTableView registerClass:[SWMarketHeaderView class] forHeaderFooterViewReuseIdentifier:@"MARKET_HEADER_VIEW"];
    [self.view addSubview:_shoppingItemListTableView];

    [_shoppingItemListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.mas_topLayoutGuideBottom);
        }
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
        }
    }];
    
    UIBarButtonItem *configItemBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Gear"] style:UIBarButtonItemStylePlain target:self action:@selector(sysConfig:)];
    UIImageView *noteBookImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Notebook"]];
    UITapGestureRecognizer *imageTaped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noteBookClicked:)];
    [noteBookImgView addGestureRecognizer:imageTaped];
    UIBarButtonItem *notebookItemBtn = [[UIBarButtonItem alloc] initWithCustomView:noteBookImgView];
    _notebookItemBtn = notebookItemBtn;
    UIBarButtonItem *addMarketItemBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewMarketItem:)];
    self.navigationItem.rightBarButtonItem = addMarketItemBtn;
    self.navigationItem.leftBarButtonItems = @[configItemBtn, notebookItemBtn];
}

#pragma mark - Data source
- (void)updateData {
    self.marketItems = [SWMarketStorage allMarketInCategory:nil];
}


#pragma mark - TABLE VIEW
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((SWMarketItem *)self.marketItems[section]).shoppingItems.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == ((SWMarketItem *)self.marketItems[indexPath.section]).shoppingItems.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NORMAL_CELL"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NORMAL_CELL"];
           
        }
        cell.textLabel.text = @"添加商品";
        cell.textLabel.textColor = SW_DISABLE_GRAY;
        cell.imageView.image = [UIImage imageNamed:@"BigAdd"];
        return cell;
    }
    SWProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PRODUCT_CELL"];
    SWProductItem *productItem = ((SWMarketItem *)self.marketItems[indexPath.section]).shoppingItems[indexPath.row];
    cell.productItem = productItem;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == ((SWMarketItem *)self.marketItems[indexPath.section]).shoppingItems.count) {
        return 100;
    }else {
        return 210;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SWProductItem *productItem = nil;
    if (indexPath.row == ((SWMarketItem *)self.marketItems[indexPath.section]).shoppingItems.count) { // 点击的是最后一个，意思是add shoppingItem,
        productItem = [[SWProductItem alloc] init];
        
    }else {
        productItem = ((SWMarketItem *)self.marketItems[indexPath.section]).shoppingItems[indexPath.row];
    }
    
    SWShoppingItemInfoViewController *vc = [[SWShoppingItemInfoViewController alloc] initWithProductItem:productItem inMarket:self.marketItems[indexPath.section]];
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.marketItems.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SWMarketHeaderView *marketHeaderView = (SWMarketHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MARKET_HEADER_VIEW"];
    SWMarketItem *marketItem = self.marketItems[section];
    marketHeaderView.markItem = marketItem;
    WeakObj(self);
    marketHeaderView.actionBlock = ^(SWMarketItem *market) {
        SWMarketViewController *vc = [[SWMarketViewController alloc] initWithMarketItem:market];
        StrongObj(self);
        if (self) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    return marketHeaderView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)longPressed:(UILongPressGestureRecognizer *)longPressGesture
{
    CGRect showFrame = [longPressGesture.view convertRect:longPressGesture.view.frame toView:[UIApplication sharedApplication].delegate.window];
    
    
    [UIView animateWithDuration:1.0f animations:^{
        longPressGesture.view.frame = CGRectMake(showFrame.origin.x -  5, showFrame.origin.y - 5, showFrame.size.width + 10, showFrame.size.height + 10);
    }];
}

- (void)panMoved:(UIPanGestureRecognizer *)panGesture{
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.preTranslation = [panGesture translationInView:self.view];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            //  panGesture f
            CGPoint translation = [panGesture translationInView:self.view];
            NSLog(@"X: %lf   Y:%lf", translation.x, translation.y);
            CGPoint newLocationPoint = CGPointMake(translation.x - self.preTranslation.x, translation.y - self.preTranslation.y);
            panGesture.view.frame = CGRectMake(panGesture.view.frame.origin.x, panGesture.view.frame.origin.y + newLocationPoint.y, panGesture.view.frame.size.width, panGesture.view.frame.size.height);
            self.preTranslation = translation;
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            NSLog(@"Finishedddddd");
        }
            break;
        default:
            break;
    }
}


- (void)dragViewPan:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.preTranslation = [panGesture translationInView:self.view];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [panGesture translationInView:self.view];
            NSLog(@"X: %lf   Y:%lf", translation.x, translation.y);
            CGPoint newLocationPoint = CGPointMake(translation.x - self.preTranslation.x, translation.y - self.preTranslation.y);
            _dragMoveView.frame = CGRectMake(_dragMoveView.frame.origin.x + newLocationPoint.x, _dragMoveView.frame.origin.y + newLocationPoint.y, _dragMoveView.frame.size.width, _dragMoveView.frame.size.height);
            self.preTranslation = translation;
        }
        break;
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
        {
            NSLog(@"Finishedddddd");
        }
            break;
        default:
            break;
    }
}

- (void)addNewMarketItem:(UIBarButtonItem *)addItem {
    NSArray *marketCategories = [SWMarketCategoryStorage allMarketCategory];
    SWMarketItem *newMarketItem = [[SWMarketItem alloc] initWithMarketCategory:marketCategories[0]];
    SWMarketViewController *vc = [[SWMarketViewController alloc] initWithMarketItem:newMarketItem];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)noteBookClicked:(UITapGestureRecognizer *)tapGesture {
    [self.notebookItemBtn.customView dismissNotificationBubble];
    
    SWNotebookHomeViewController *notebookVC = [[SWNotebookHomeViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:notebookVC];
    [navVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).drawerVC presentViewController:navVC animated:YES completion:^{
        
    }];
}

- (void)sysConfig:(UIBarButtonItem *)sysConfigItem {
    
}

#pragma mark - SWProductTableViewCellDelegate

- (void)productTableViewCell:(SWProductTableViewCell *)cell didSelectImage:(UIImage *)image {
    
}

- (void)productTableViewCell:(SWProductTableViewCell *)cell didClickEditProduct:(SWProductItem *)productItem {
    
}

- (void)productTableViewCell:(SWProductTableViewCell *)cell didClickDelProduct:(SWProductItem *)productItem {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除该商品吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SWProductItemStorage removeProductItem:productItem];
        [self updateData];
        [self.shoppingItemListTableView reloadData];
        
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"容我三思" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertView addAction:cancleAction];
    [alertView addAction:okAction];
    
    [self presentViewController:alertView animated:YES completion:^{
        
    }];
}

- (void)productTableViewCell:(SWProductTableViewCell *)cell didClickBuyProduct:(SWProductItem *)productItem {
    SWOrderView *orderView = [[SWOrderView alloc] initWithProductItem:productItem];
    orderView.delegate = self;
    [orderView attachToView:self.view];
    [orderView showOrderView];
}

- (void)productTableViewCell:(SWProductTableViewCell *)cell didUnBuyProduct:(SWProductItem *)productItem {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定将该商品从账单中删除吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SWProductOrderStorage removeProductOrderByProduct:productItem];
        [self updateData];
        [[NSNotificationCenter defaultCenter] postNotificationName:SW_UNBUY_NOTIFICATION object:nil userInfo:@{SW_NOTIFICATION_PRODUCT_KEY:productItem}];
        
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"容我三思" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertView addAction:cancleAction];
    [alertView addAction:okAction];
    
    [self presentViewController:alertView animated:YES completion:^{
        
    }];
}

- (void)productTableViewCell:(SWProductTableViewCell *)cell didClickTakeProductPhoto:(SWProductItem *)productItem {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    WeakObj(self);
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        StrongObj(self);
        for (UIImage *photo in photos) {
            SWProductPhoto *productPhoto = [[SWProductPhoto alloc] initWithImage:photo];
            [productItem.productPhotos addObject:productPhoto];
        }
        [SWProductItemStorage updateProductItem:productItem];
        [self updateData];
        [self.shoppingItemListTableView reloadData];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - SWOrderViewDelegate
- (void)SWOrderView:(SWOrderView *)orderView didOrderItem:(SWOrder *)productOrder {
    if(productOrder) {
        [SWProductOrderStorage insertNewProductOrder:productOrder];
        // 对于新加入的商品，需要添加小红点，表示账本已经更新
        [self.notebookItemBtn.customView showNotificationBubble];
        [self updateData];
        [self performSelector:@selector(postBuyProductNotification:) withObject:productOrder.productItem afterDelay:0.5];
    }
}

- (void)postBuyProductNotification:(SWProductItem *)productItem {
     [[NSNotificationCenter defaultCenter] postNotificationName:SW_BUY_NOTIFICATION object:nil userInfo:@{SW_NOTIFICATION_PRODUCT_KEY:productItem}];
}

- (void)SWOrderView:(SWOrderView *)orderView cancelOrderItem:(SWProductItem *)product {
    
}
@end
