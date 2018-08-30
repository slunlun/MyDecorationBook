//
//  SWNotebookHomeViewController.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/5/2.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWNotebookHomeViewController.h"
#import "SWShoppingItemHomePageVC.h"
#import "AppDelegate.h"
#import "SWShoppingOrderManager.h"
#import "Masonry.h"
#import "SWUIDef.h"
#import "SWNotebookBarChartView.h"
#import "SWNotebookPieChartView.h"
#import "SWOrderListinCategoryViewController.h"

@interface SWNotebookHomeViewController ()<SWNotebookPieChartViewDelegate, SWNotebookBarChartViewDelegate, UINavigationControllerDelegate>
@property(nonatomic, strong) NSArray *orderInfoArray;
@property(nonatomic, strong) UIView *focusView;
@property(nonatomic, strong) UIView *guideBarView;
@property(nonatomic, strong) SWNotebookPieChartView *pieChartView;
@property(nonatomic, strong) SWNotebookBarChartView *barChartView;
@end

@implementation SWNotebookHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self commonInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _orderInfoArray = [[SWShoppingOrderManager sharedInstance] loadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
     [_pieChartView updateSummarizingData];
    self.navigationController.delegate = self; // 在这里设置navigationController.delegate，确保第一次push到本vc时，delegate方法不被调用
}

#pragma mark - Common init
- (void)commonInit {
    // 初始化navigation bar
    UIBarButtonItem *shoppingItemHomePage = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MarketBig"] style:UIBarButtonItemStylePlain target:self action:@selector(shoppingItemHomePageClicked:)];
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareMyOrderClicked:)];
    self.navigationItem.leftBarButtonItem = shoppingItemHomePage;
    self.navigationItem.rightBarButtonItem = shareBtn;
    self.navigationItem.title = @"账本";
    
    // 初始化汇总视图的导航栏
    UIView *guideBarView = [[UIView alloc] init];
    guideBarView.backgroundColor = SW_DISABLIE_THIN_WHITE;
    [self.view addSubview:guideBarView];
    [guideBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.mas_topLayoutGuideBottom);
        }
        make.height.equalTo(@40);
    }];
    _guideBarView = guideBarView;
    
    UIButton *barChartBtn = [[UIButton alloc] init];
    [barChartBtn addTarget:self action:@selector(barChartBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    barChartBtn.titleLabel.font = SW_DEFAULT_FONT;
    [barChartBtn setTitle:@"条状图" forState:UIControlStateNormal];
    [barChartBtn setTitleColor:SW_TAOBAO_BLACK forState:UIControlStateNormal];
    [guideBarView addSubview:barChartBtn];
    [barChartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(guideBarView);
        make.right.equalTo(guideBarView.mas_right).offset(-SW_MARGIN);
        make.width.equalTo(@60);
    }];
    
    
    UIButton *pieChartBtn = [[UIButton alloc] init];
    [pieChartBtn addTarget:self action:@selector(pieChartBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    pieChartBtn.titleLabel.font = SW_DEFAULT_FONT;
    [pieChartBtn setTitle:@"饼图" forState:UIControlStateNormal];
    [pieChartBtn setTitleColor:SW_TAOBAO_BLACK forState:UIControlStateNormal];
    [guideBarView addSubview:pieChartBtn];
    [pieChartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(guideBarView);
        make.right.equalTo(barChartBtn.mas_left);
        make.width.equalTo(@60);
    }];
    
    UIView *focusView = [[UIView alloc] init];
    focusView.backgroundColor = SW_TAOBAO_ORANGE;
    focusView.alpha = 0.1f;
    [guideBarView addSubview:focusView];
    // 默认选中饼图
    [focusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(guideBarView);
        make.left.equalTo(pieChartBtn.mas_left);
        make.width.equalTo(@60);
    }];
    
    UIView *focusSubView = [[UIView alloc] init];
    focusSubView.backgroundColor = SW_TAOBAO_ORANGE;
    [guideBarView addSubview:focusSubView];
    [focusSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(focusView);
        make.height.equalTo(@2);
    }];
    _focusView = focusView;
    
    // 初始化饼图view和条形图view
    _pieChartView = [[SWNotebookPieChartView alloc] init];
    _pieChartView.backgroundColor = [UIColor whiteColor];
    _pieChartView.delegate = self;
    [self.view addSubview:_pieChartView];
    [_pieChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_guideBarView.mas_bottom);
    }];
    
    _barChartView = [[SWNotebookBarChartView alloc] init];
    _barChartView.backgroundColor = [UIColor whiteColor];
    _barChartView.delegate = self;
    [self.view addSubview:_barChartView];
    [_barChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_guideBarView.mas_bottom);
        make.bottom.equalTo(self.view);
        make.left.equalTo(_pieChartView.mas_right);
        make.width.equalTo(self.view.mas_width);
    }];
}

#pragma mark - UI Response
- (void)shoppingItemHomePageClicked:(UIBarButtonItem *)barItem {
    [((AppDelegate *)[UIApplication sharedApplication].delegate).drawerVC dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)shareMyOrderClicked:(UIBarButtonItem *)barItem {
    [self generateSharedExcel];
}


- (void)pieChartBtnClicked:(UIButton *)button {
    [self.focusView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.guideBarView);
        make.left.equalTo(button.mas_left);
        make.width.equalTo(@60);
    }];
    
    [_pieChartView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_guideBarView.mas_bottom);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
}

- (void)barChartBtnClicked:(UIButton *)button {
    [self.focusView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.guideBarView);
        make.left.equalTo(button.mas_left);
        make.width.equalTo(@60);
    }];
    
    [_pieChartView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_guideBarView.mas_bottom);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view.mas_left);
        make.width.equalTo(self.view);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            // 更新bar chart 信息
            [_barChartView updateData];
        }
    }];
}

#pragma mark - SWNotebookPieChartViewDelegate
- (void)SWNotebookPieChartView:(SWNotebookPieChartView *)pieCharView didSelectOrderCategory:(NSDictionary *)dict {
    SWShoppingOrderCategoryModle *orderCategory = dict.allKeys.firstObject;
    SWOrderListinCategoryViewController *vc = [[SWOrderListinCategoryViewController alloc] initWithShoppingCategory:orderCategory];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - SWNotebookBarChartViewDelegate
- (void)SWNotebookBarChartView:(SWNotebookBarChartView *)barCharView didSelectOrderCategory:(NSDictionary *)dict {
    SWShoppingOrderCategoryModle *orderCategory = dict.allKeys.firstObject;
    SWOrderListinCategoryViewController *vc = [[SWOrderListinCategoryViewController alloc] initWithShoppingCategory:orderCategory];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isEqual:self]) {
        _barChartView.needUpdata = YES;
    }
}

#pragma mark - Generate shared excel
- (NSURL *)generateSharedExcel {

    return nil;
}
@end
