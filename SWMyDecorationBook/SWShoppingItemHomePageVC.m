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
#import "SWShoppingOrderManager.h"
#import "UIView+UIExt.h"
#import "SWUserTutorialManager.h"
#import "SWEmptyMarketView.h"
#import "SWMarketCategoryRemovedView.h"
#import "SWUnreadOrderInfoStorage.h"
#import "SWCommonUtils.h"

@interface SWShoppingItemHomePageVC () <UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating, SWProductTableViewCellDelegate, SWOrderViewDelegate, SWEmptyMarketViewDelegate>
@property(nonatomic, strong) UIView *dragMoveView;
@property(nonatomic, assign) CGPoint preTranslation;
@property(nonatomic, strong) UITableView *shoppingItemListTableView;
@property(nonatomic, strong) NSArray *marketItems;
@property(nonatomic, strong) NSArray *searchResults;
@property(nonatomic, strong) UIBarButtonItem *notebookItemBtn;
@property(nonatomic, strong) SWMarketCategory *curMarketCategory;
@property(nonatomic, strong) SWEmptyMarketView *emptyMarketView;
@property(nonatomic, strong) SWMarketCategoryRemovedView *marketCategoryEmptyView;
@property(nonatomic, assign) CGPoint orderOriginalPoint; // 记录下当前购物车图标的位置，用于购买商品后，商品飞入账本的动画
@property(nonatomic, strong) UISearchController *searchVC;
@end

@implementation SWShoppingItemHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SW_TAOBAO_WHITE;
    [self commitInit];
    self.curMarketCategory = [[SWMarketCategoryStorage allMarketCategory] firstObject]; // 默认选中第一个market category
    _orderOriginalPoint = CGPointZero;
    
    
    // 测试，添加用户引导view
    UIView *rootView = [UIApplication sharedApplication].delegate.window;
    SWTutorialNode *node1 = [[SWTutorialNode alloc] initWithPoint:CGPointMake(0, rootView.center.y) radius:80 text:@"使用侧拉菜单可以添加，编辑，删除商品分类"];
    UIBarButtonItem *addShopBtn = self.navigationItem.rightBarButtonItem;
    
    CGPoint p = CGPointMake(addShopBtn.customView.center.x, addShopBtn.customView.center.y + 20);
    SWTutorialNode *node2 = nil;  SWTutorialNode *node3  = nil;
    if (@available(iOS 11.0, *)) { // iOS 11 由于引入了navigation bar的autolayout, 在通过center获取位置会不准, 先手动搞一下把

        CGFloat navHegiht = [SWCommonUtils systemNavBarHeight];
        CGPoint p2 = CGPointMake(rootView.frame.size.width - 30, navHegiht - 20);
        node2 = [[SWTutorialNode alloc] initWithPoint:p2 radius:80 text:@"点击这里在当前分类下添加商家"];
        CGPoint p3 = CGPointMake(30, navHegiht - 20);
        node3 = [[SWTutorialNode alloc] initWithPoint:p3 radius:80 text:@"所有选购的商品可以在这里查看账单统计"];
    }else {
        node2 = [[SWTutorialNode alloc] initWithPoint:p radius:80 text:@"点击这里在当前分类下添加商家"];
        p = CGPointMake(_notebookItemBtn.customView.center.x, _notebookItemBtn.customView.center.y + 20);
        node3 = [[SWTutorialNode alloc] initWithPoint:p radius:80 text:@"所有选购的商品可以在这里查看账单统计"];
    }
   
    NSArray *nodes = @[node1, node2, node3];
    [[SWUserTutorialManager sharedInstance] setUpTutorialViewWithNodes:nodes inView:rootView];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderInfoUpdated:) name:SW_ORDER_INFO_UPDATE_NOTIFICATION object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if(self.searchVC && self.searchVC.active == YES) {
        [self configureNavigationBar];
        self.searchVC.active = NO;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SW_HOME_PAGE_DISAPPEAR_NOTIFICATION object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:SW_HOME_PAGE_APPEAR_NOTIFICATION object:nil];
    [self updateDataForMarketCategory:self.curMarketCategory];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)commitInit{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _shoppingItemListTableView = [[UITableView alloc] init];
    _shoppingItemListTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _shoppingItemListTableView.dataSource = self;
    _shoppingItemListTableView.delegate = self;
    [_shoppingItemListTableView registerClass:[SWProductTableViewCell class] forCellReuseIdentifier:@"PRODUCT_CELL"];
    [_shoppingItemListTableView registerClass:[SWMarketHeaderView class] forHeaderFooterViewReuseIdentifier:@"MARKET_HEADER_VIEW"];
    _shoppingItemListTableView.tableFooterView = [[UIView alloc] init];
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
    
    [self configureNavigationBar];
}

#pragma mark - Data source

- (void)updateDataForMarketCategory:(SWMarketCategory *)marketCategory {
    if (marketCategory) {
        [self.marketCategoryEmptyView removeFromSuperview];
        
        self.marketItems = [SWMarketStorage allMarketInCategory:marketCategory];
        self.navigationItem.title = marketCategory.categoryName;
        self.curMarketCategory = marketCategory;
        if(self.marketItems.count > 0) {
            [self.emptyMarketView removeFromSuperview];
            self.emptyMarketView = nil;
            [self.shoppingItemListTableView reloadData];
        }else {
            // 当前分类下没有商家，显示添加商家界面
            if (self.emptyMarketView == nil) {
                _emptyMarketView = [[SWEmptyMarketView alloc] initWithFrame:self.view.frame];
                _emptyMarketView.delegate = self;
                _emptyMarketView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                [self.view addSubview:_emptyMarketView];
            }
        }
    }else {  // 传入的marketCategory为nil，表明当前的market category已经被删除
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.navigationItem.title = @"";
        [self.marketCategoryEmptyView removeFromSuperview];
        _marketCategoryEmptyView = [[SWMarketCategoryRemovedView alloc] initWithFrame:self.view.frame];
        _marketCategoryEmptyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_marketCategoryEmptyView];
        
    }
    
    
}

#pragma mark - SWEmptyMarketViewDelegate
- (void)didClickedEmptyView {
    SWMarketItem *newMarketItem = [[SWMarketItem alloc] initWithMarketCategory:self.curMarketCategory];
    SWMarketViewController *vc = [[SWMarketViewController alloc] initWithMarketItem:newMarketItem];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Setter/Getter
- (void)setMarketItems:(NSArray *)marketItems {
    _marketItems = marketItems;
    [_shoppingItemListTableView reloadData];
}

#pragma mark - Table view scrollview delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.searchVC) {
        [self.searchVC.searchBar resignFirstResponder];
    }
}
#pragma mark - TABLE VIEW
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchVC) {
        return ((SWMarketItem *)self.searchResults[section]).shoppingItems.count + 1;
    }else {
        return ((SWMarketItem *)self.marketItems[section]).shoppingItems.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchVC) {
        if(indexPath.row == ((SWMarketItem *)self.searchResults[indexPath.section]).shoppingItems.count) {
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
        SWProductItem *productItem = ((SWMarketItem *)self.searchResults[indexPath.section]).shoppingItems[indexPath.row];
        cell.productItem = productItem;
        cell.market = self.marketItems[indexPath.section];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else {
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
        cell.market = self.marketItems[indexPath.section];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchVC) {
        if(indexPath.row == ((SWMarketItem *)self.searchResults[indexPath.section]).shoppingItems.count) {
            return 100;
        }else {
            return 210;
        }
    }else {
        if(indexPath.row == ((SWMarketItem *)self.marketItems[indexPath.section]).shoppingItems.count) {
            return 100;
        }else {
            return 210;
        }
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchVC) {
        SWProductItem *productItem = nil;
        if (indexPath.row == ((SWMarketItem *)self.searchResults[indexPath.section]).shoppingItems.count) { // 点击的是最后一个，意思是add shoppingItem,
            productItem = [[SWProductItem alloc] init];
            SWShoppingItemInfoViewController *vc = [[SWShoppingItemInfoViewController alloc] initWithProductItem:productItem inMarket:self.marketItems[indexPath.section]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else {
        SWProductItem *productItem = nil;
        if (indexPath.row == ((SWMarketItem *)self.marketItems[indexPath.section]).shoppingItems.count) { // 点击的是最后一个，意思是add shoppingItem,
            productItem = [[SWProductItem alloc] init];
            
            SWShoppingItemInfoViewController *vc = [[SWShoppingItemInfoViewController alloc] initWithProductItem:productItem inMarket:self.marketItems[indexPath.section]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
   
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchVC) {
        return self.searchResults.count;
    }else {
        return self.marketItems.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.searchVC) {
        SWMarketHeaderView *marketHeaderView = (SWMarketHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MARKET_HEADER_VIEW"];
        SWMarketItem *marketItem = self.searchResults[section];
        marketHeaderView.markItem = marketItem;
        WeakObj(self);
        marketHeaderView.actionBlock = ^(SWMarketItem *market) {
            SWMarketViewController *vc = [[SWMarketViewController alloc] initWithMarketItem:market];
            StrongObj(self);
            if (self) {
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
        
        marketHeaderView.marketContactClickBlock = ^(SWMarketItem *market) {
            NSString *msg = [NSString stringWithFormat:@"要联系 %@ 吗？", market.defaultContactName];
            UIAlertController *alertVC= [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *telNum = [NSString stringWithFormat:@"tel://%@", market.defaultTelNum];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNum] options:@{} completionHandler:^(BOOL success) {
                    NSLog(@"为你打call");
                }];
            }];
            
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertVC addAction:okAction];
            [alertVC addAction:cancleAction];
            
            StrongObj(self);
            [self presentViewController:alertVC animated:YES completion:nil];
        };
        
        return marketHeaderView;
    }else {
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
        
        marketHeaderView.marketContactClickBlock = ^(SWMarketItem *market) {
            NSString *msg = [NSString stringWithFormat:@"要联系 %@ 吗？", market.defaultContactName];
            UIAlertController *alertVC= [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *telNum = [NSString stringWithFormat:@"tel://%@", market.defaultTelNum];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNum] options:@{} completionHandler:^(BOOL success) {
                    NSLog(@"为你打call");
                }];
            }];
            
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertVC addAction:okAction];
            [alertVC addAction:cancleAction];
            
            StrongObj(self);
            [self presentViewController:alertVC animated:YES completion:nil];
        };
        
        return marketHeaderView;
    }
  
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
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

#pragma mark - Navigation Bar items
- (void)configureNavigationBar {
//    UIImageView *configImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gear"]];
//    UITapGestureRecognizer *configTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sysConfig:)];
//    [configImgView addGestureRecognizer:configTapped];
//    UIBarButtonItem *configItemBtn = [[UIBarButtonItem alloc] initWithCustomView:configImgView];
    
    
    UIImageView *noteBookImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Notebook"]];
    UITapGestureRecognizer *imageTaped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noteBookClicked:)];
    [noteBookImgView addGestureRecognizer:imageTaped];
    UIBarButtonItem *notebookItemBtn = [[UIBarButtonItem alloc] initWithCustomView:noteBookImgView];
    _notebookItemBtn = notebookItemBtn;
    
    UIImageView *addMarketView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AddMarket"]];
    UITapGestureRecognizer *addTaped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNewMarketItem:)];
    [addMarketView addGestureRecognizer:addTaped];
    UIBarButtonItem *addMarketItemBtn = [[UIBarButtonItem alloc] initWithCustomView:addMarketView];
    
    UIImageView *searchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Search"]];
    UITapGestureRecognizer *searchTaped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchItem:)];
    [searchView addGestureRecognizer:searchTaped];
    UIBarButtonItem *searchItemBtn = [[UIBarButtonItem alloc] initWithCustomView:searchView];
    self.navigationItem.rightBarButtonItems = @[addMarketItemBtn, searchItemBtn];
    self.navigationItem.leftBarButtonItems = @[notebookItemBtn];
    
    self.navigationItem.titleView = nil;
    self.navigationItem.title = self.curMarketCategory.categoryName;
    
    NSArray *array = [SWUnreadOrderInfoStorage allUnreadOrderInfos];
    if (array.count) {
        [self.notebookItemBtn.customView showNotificationBubble];
    }else {
        [self.notebookItemBtn.customView dismissNotificationBubble];
    }
}

- (void)addNewMarketItem:(UIBarButtonItem *)addItem {
    SWMarketItem *newMarketItem = [[SWMarketItem alloc] initWithMarketCategory:self.curMarketCategory];
    SWMarketViewController *vc = [[SWMarketViewController alloc] initWithMarketItem:newMarketItem];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)noteBookClicked:(UITapGestureRecognizer *)tapGesture {
    [self.notebookItemBtn.customView dismissNotificationBubble];
    [SWUnreadOrderInfoStorage removeAllOrderInfos];
    SWNotebookHomeViewController *notebookVC = [[SWNotebookHomeViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:notebookVC];
    [navVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).drawerVC presentViewController:navVC animated:YES completion:^{
        
    }];
}

- (void)searchItem:(UITapGestureRecognizer *)tapGesture {
    [self hiddenNavigatinBarItems];
    UISearchController *searchVC = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    searchVC.delegate = self;
    searchVC.searchResultsUpdater = self;
    
    searchVC.searchBar.placeholder = @"请输入商家名称";
    [searchVC.searchBar sizeToFit];
    searchVC.hidesNavigationBarDuringPresentation = NO;
    searchVC.dimsBackgroundDuringPresentation = NO;
    
    self.navigationController.extendedLayoutIncludesOpaqueBars = NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.definesPresentationContext = YES;
    
    
    self.searchVC = searchVC;
    //self.navigationItem.titleView = self.searchVC.searchBar;
    self.navigationItem.titleView = self.searchVC.searchBar;
    
    [self.searchVC setActive:YES];
}

- (void)onTapSearchCancelButton:(UIBarButtonItem *)cancleBtn {
    
    [self configureNavigationBar];
    self.searchVC.active = NO;
}

- (void)hiddenNavigatinBarItems
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onTapSearchCancelButton:)];
        self.navigationItem.rightBarButtonItems = @[cancelButton];
    }else
    {
        self.navigationItem.rightBarButtonItems = nil;
    }
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.title = nil;
}

- (void)sysConfig:(UIBarButtonItem *)sysConfigItem {
    
}
#pragma -mark UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController {
     [self.searchVC.searchBar becomeFirstResponder];
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    [self configureNavigationBar];
    [self.searchVC.searchBar removeFromSuperview];
    self.searchVC = nil;
     [self updateDataForMarketCategory:self.curMarketCategory];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self configureNavigationBar];
    [self.searchVC.searchBar removeFromSuperview];
    self.searchVC = nil;
    [self updateDataForMarketCategory:self.curMarketCategory];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [searchController.searchBar text];
    if (![searchString isEqualToString:@""]) {
        NSArray *data;
        NSPredicate *preicate;
        
        data = self.marketItems;
        preicate = [NSPredicate predicateWithFormat:@"self.marketName contains [cd] %@", searchString];
        
        self.searchResults = [[NSArray alloc] initWithArray:[data filteredArrayUsingPredicate:preicate]];
        [self.shoppingItemListTableView reloadData];
    }else {
        self.searchResults = [[NSArray alloc] initWithArray:self.marketItems];
        [self.shoppingItemListTableView reloadData];
    }
   
    
}

#pragma mark - SWProductTableViewCellDelegate

- (void)productTableViewCell:(SWProductTableViewCell *)cell didSelectImage:(UIImage *)image {
    
}

- (void)productTableViewCell:(SWProductTableViewCell *)cell didClickEditProduct:(SWProductItem *)productItem {
    SWShoppingItemInfoViewController *vc = [[SWShoppingItemInfoViewController alloc] initWithProductItem:productItem inMarket:cell.market];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)productTableViewCell:(SWProductTableViewCell *)cell didClickDelProduct:(SWProductItem *)productItem {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除该商品吗? 该商品同样会在账本中删除!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [SWProductItemStorage removeProductItem:productItem];
        [self updateDataForMarketCategory:self.curMarketCategory];
        [self.shoppingItemListTableView reloadData];
        
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertView addAction:cancleAction];
    [alertView addAction:okAction];
    
    [self presentViewController:alertView animated:YES completion:^{
        
    }];
}

- (void)productTableViewCell:(SWProductTableViewCell *)cell didClickBuyProduct:(SWProductItem *)productItem {
    // 先把可能的搜索输入键盘收起来
    if (self.searchVC) {
        [self.searchVC.searchBar resignFirstResponder];
    }
    
    // 显示订购界面
    SWOrderView *orderView = [[SWOrderView alloc] initWithProductItem:productItem];
    orderView.delegate = self;
    UIView *mainWindow = [UIApplication sharedApplication].delegate.window;
    [orderView attachToView:mainWindow];
    [orderView showOrderView];
    
    // 先记录下当前购物车图标的位置，用于购买商品后，商品飞入账本的动画
    _orderOriginalPoint = CGPointZero;
    UIView *rootView = [UIApplication sharedApplication].delegate.window;
    CGRect sourceFrame = cell.frame;
    sourceFrame.origin.x += cell.buyBtn.frame.origin.x;
    sourceFrame.origin.y += cell.buyBtn.frame.origin.y;
    sourceFrame = [self.shoppingItemListTableView convertRect:sourceFrame toView:rootView];
   _orderOriginalPoint = sourceFrame.origin;
}

- (void)productTableViewCell:(SWProductTableViewCell *)cell didUnBuyProduct:(SWProductItem *)productItem {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定将该商品从账单中删除吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [SWProductOrderStorage removeProductOrderByProduct:productItem];
        [self updateDataForMarketCategory:self.curMarketCategory];
        [[NSNotificationCenter defaultCenter] postNotificationName:SW_UNBUY_NOTIFICATION object:nil userInfo:@{SW_NOTIFICATION_PRODUCT_KEY:productItem}];
        
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
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
        [self updateDataForMarketCategory:self.curMarketCategory];
        [self.shoppingItemListTableView reloadData];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - SWOrderViewDelegate
- (void)SWOrderView:(SWOrderView *)orderView didOrderItem:(SWOrder *)productOrder {
    if(productOrder) {
        // 入账订单
        [[SWShoppingOrderManager sharedInstance] insertNewOrder:productOrder];
        
        // 添加订单飘向账本动画
        UIView *rootView = [UIApplication sharedApplication].delegate.window;
        
        CGPoint destPoint = CGPointZero;
        if (@available(iOS 11.0, *)) { // iOS 11 由于引入了navigation bar的autolayout, 在通过center获取位置会不准, 先手动搞一下把
            CGFloat navHegiht = [SWCommonUtils systemNavBarHeight];
            destPoint = CGPointMake(30, navHegiht - 20);
        }else {
            destPoint = CGPointMake(_notebookItemBtn.customView.center.x, _notebookItemBtn.customView.center.y + 20);
        }
        
        destPoint.x -= 5;
        destPoint.y -= 5;
        UIImage *orderImg = nil;
        if (productOrder.productItem.productPhotos.count) {
            SWProductPhoto *orderPhoto = productOrder.productItem.productPhotos.firstObject;
            orderImg = orderPhoto.photo;
        }else {
            orderImg = [UIImage imageNamed:@"ProductThumb"];
        }
        UIImageView *imageView = [[UIImageView alloc] initWithImage:orderImg];
        imageView.backgroundColor = SW_TAOBAO_ORANGE;
        imageView.alpha = 0.8;
        imageView.frame = CGRectMake(self.orderOriginalPoint.x, self.orderOriginalPoint.y, 0, 0);
        [imageView cornerRadian:10];
        [rootView addSubview:imageView];
        [UIView animateWithDuration:0.2 animations:^{
            imageView.frame = CGRectMake(self.orderOriginalPoint.x, self.orderOriginalPoint.y - 15, 15, 15);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 animations:^{
                imageView.frame = CGRectMake(destPoint.x, destPoint.y, 15, 15);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    imageView.frame = CGRectMake(destPoint.x, destPoint.y, 0, 0);
                } completion:^(BOOL finished) {
                    [imageView removeFromSuperview];
                }];
            }];
        }];
        [self updateDataForMarketCategory:self.curMarketCategory];
        [self performSelector:@selector(postBuyProductNotification:) withObject:productOrder.productItem afterDelay:0.6];
    }
}

- (void)postBuyProductNotification:(SWProductItem *)productItem {
     [[NSNotificationCenter defaultCenter] postNotificationName:SW_BUY_NOTIFICATION object:nil userInfo:@{SW_NOTIFICATION_PRODUCT_KEY:productItem}];
}

- (void)SWOrderView:(SWOrderView *)orderView cancelOrderItem:(SWProductItem *)product {
}

#pragma mark - Notification
- (void)orderInfoUpdated:(NSNotification *)notification {
    NSArray *array = [SWUnreadOrderInfoStorage allUnreadOrderInfos];
    if (array.count) {
        [self.notebookItemBtn.customView showNotificationBubble];
    }else {
        [self.notebookItemBtn.customView dismissNotificationBubble];
    }
}
@end
