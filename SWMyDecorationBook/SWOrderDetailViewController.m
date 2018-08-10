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
#import "SWOrderInfoPhotoTableViewCell.h"
#import "SWOrderDetailTableViewCell.h"

@interface SWOrderDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *orderInfoTableView;
@property(nonatomic, strong) UIButton *saveBtn;
@property(nonatomic, strong) UIButton *delBtn;

@property(nonatomic, strong) SWOrder *orderInfo;
@end

@implementation SWOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = self.orderInfo.productItem.productName;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Instance
- (instancetype)initWithOrderInfo:(SWOrder *)orderInfo {
    if (self = [super init]) {
        _orderInfo = orderInfo;
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
    [_orderInfoTableView registerClass:[SWOrderInfoPhotoTableViewCell class] forCellReuseIdentifier:@"ORDER_PHOTO_CELL_IDENTIFY"];
    [_orderInfoTableView registerClass:[SWOrderDetailTableViewCell class] forCellReuseIdentifier:@"ORDER_DETAIL_CELL_IDENTIFY"];
    _orderInfoTableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { // 订单信息
        if(indexPath.row == 0) { // 订单基本信息
            return 80.0f;
        }
        
        if (indexPath.row == 1) { // 商品图片
            return 120.0f;
        }
        
        if (indexPath.row == 2) { // 购买数量
            return 70.0f;
        }
        
        if (indexPath.row == 3) { // order 备注
           return 70.0f;
        }
        
        if (indexPath.row == 4) { // 合计金额
            return 70.0f;
        }
        
    }else { //  商家信息
        
    }
    return 70.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) { // 订单信息
        return 5;
    }else { // 商家信息
        return self.orderInfo.marketItem.telNums.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) { // 订单信息
        if(indexPath.row == 0) { // 订单基本信息
            cell = [tableView dequeueReusableCellWithIdentifier:@"ORDER_DETAIL_CELL_IDENTIFY" forIndexPath:indexPath];
            [((SWOrderDetailTableViewCell *)cell) updateOrderInfo:self.orderInfo];
        }
        
        if (indexPath.row == 1) { // 商品图片
            cell = [tableView dequeueReusableCellWithIdentifier:@"ORDER_PHOTO_CELL_IDENTIFY" forIndexPath:indexPath];
            ((SWOrderInfoPhotoTableViewCell *)cell).photos = self.orderInfo.productItem.productPhotos;
            ((SWOrderInfoPhotoTableViewCell *)cell).photoCellClicked = ^(NSInteger index) {
                
            };
        }
        
        if (indexPath.row == 2) { // 购买数量
            cell = [tableView dequeueReusableCellWithIdentifier:@"ORDER_COUNT_CELL_IDENTIFY" forIndexPath:indexPath];
            [((SWOrderCountTableViewCell *)cell) setOrderInfo:self.orderInfo];
        }
        
        if (indexPath.row == 3) { // order 备注
            cell = [tableView dequeueReusableCellWithIdentifier:@"ORDER_REMARK_CELL_IDENTIFY" forIndexPath:indexPath];
            [((SWOrderRemarkTableViewCell *)cell) setOrderRemark:self.orderInfo.orderRemark];
        }
        
        if (indexPath.row == 4) { // 合计金额
            cell = [tableView dequeueReusableCellWithIdentifier:@"ORDER_TOTAL_PRICE_CELL_IDENTIFY" forIndexPath:indexPath];
            [((SWOrderTotalPriceTableViewCell *)cell) setOrderInfo:self.orderInfo];
        }
            
    }else { //  商家信息
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
