//
//  SWOrderDetailViewController.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/10.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWOrderDetailViewController.h"
#import "Masonry.h"
#import "SWUIDef.h"
#import "SWOrderCountTableViewCell.h"
#import "SWOrderRemarkTableViewCell.h"
#import "SWOrderTotalPriceTableViewCell.h"
#import "SWOrderProductBasicInfoTableViewCell.h"

@interface SWOrderDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *orderInfoTableView;
@property(nonatomic, strong) UIButton *saveBtn;
@property(nonatomic, strong) UIButton *delBtn;
@end

@implementation SWOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Instance
- (instancetype)initWithOrderInfo:(SWOrder *)orderInfo {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

#pragma mark - CommonInit
- (void)commonInit {
    _orderInfoTableView = [[UITableView alloc] init];
    _orderInfoTableView.delegate = self;
    _orderInfoTableView.dataSource = self;
    [self.view addSubview:_orderInfoTableView];
    [_orderInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    [_orderInfoTableView registerClass:[SWOrderCountTableViewCell class] forCellReuseIdentifier:@"ORDER_COUNT_CELL_IDENTIFY"];
    [_orderInfoTableView registerClass:[SWOrderRemarkTableViewCell class] forCellReuseIdentifier:@"ORDER_REMARK_CELL_IDENTIFY"];
    [_orderInfoTableView registerClass:[SWOrderTotalPriceTableViewCell class] forCellReuseIdentifier:@"ORDER_TOTAL_PRICE_CELL_IDENTIFY"];
    [_orderInfoTableView registerClass:[SWOrderProductBasicInfoTableViewCell class] forCellReuseIdentifier:@"ORDER_PRODUCT_BASICE_INFO_CELL_IDENTIFY"];
    
}

#pragma mark - UITableViewDelegate
#pragma mark - UITableViewDataSource
@end
