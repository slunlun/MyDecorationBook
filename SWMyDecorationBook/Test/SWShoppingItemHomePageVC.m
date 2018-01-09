//
//  SWRedViewController.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/25/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import "SWShoppingItemHomePageVC.h"
#import "Masonry.h"
#import "SWProductTableViewCell.h"
#import "SWMarketHeaderView.h"
#import "SWMarketViewController.h"
@interface SWShoppingItemHomePageVC () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UIView *dragMoveView;
@property(nonatomic, assign) CGPoint preTranslation;


@property(nonatomic, strong) UITableView *shoppingItemListTableView;
@end

@implementation SWShoppingItemHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self commitInit];
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
    
    UIBarButtonItem *addMarketItemBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewMarketItem:)];
    self.navigationItem.rightBarButtonItem = addMarketItemBtn;
   
}

#pragma mark - TABLE VIEW
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SWProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PRODUCT_CELL"];
    SWProductItem *productItem = [[SWProductItem alloc] init];
    productItem.productName = @"AE-12";
    productItem.price = 124.3;
    productItem.productPictures = [NSArray new];
    productItem.productMark = @"需要在12月12号的商场活动才能够获取到这个东西需要在12月12号的商场活动才能够获取到这个东西需要在12月12号的商场活动才能够获取到这个东西需要在12月12号的商场活动才能够获取到这个东西";
    cell.productItem = productItem;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 210;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Press tableview %@", indexPath);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SWMarketHeaderView *marketHeaderView = (SWMarketHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MARKET_HEADER_VIEW"];
    SWMarketItem *marketItem = [[SWMarketItem alloc] init];
    if (section == 0) {
        marketItem.marketName = @"红枫家具";
        marketItem.defaultTelNum = @18745459381;
    }else {
        marketItem.marketName = @"红枫圣象地板抓目标点红枫圣象地板抓目标点红枫圣象地板抓目标点红枫圣象地板抓目标点";
        marketItem.defaultTelNum = @13745639847;
    }
    
    marketHeaderView.markItem = marketItem;
    marketHeaderView.actionBlock = ^(SWMarketItem *market) {
        NSLog(@"The maket name is %@", market.marketName);
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
    SWMarketViewController *vc = [SWMarketViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
