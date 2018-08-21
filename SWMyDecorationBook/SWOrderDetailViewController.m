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
#import "SWProductOrderStorage.h"
#import "SWDef.h"
#import "SWMarketContactViewController.h"

@interface SWOrderDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *orderInfoTableView;
@property(nonatomic, strong) UIButton *saveBtn;
@property(nonatomic, strong) UIButton *delBtn;
@property(nonatomic, strong) UIButton *connectBtn;
@property(nonatomic, assign) BOOL orderInfoChanged;
@property(nonatomic, strong) SWOrder *orderInfo;
@end

@implementation SWOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = self.orderInfo.productItem.productName;
    [self registerNotification];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"OrderDetailVC dealloc");
}

#pragma mark - Notification
- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notificaiton {
    NSDictionary *info = notificaiton.userInfo;
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.orderInfoTableView.contentInset = UIEdgeInsetsMake(0, 0, kbSize.height - 60, 0);  // 60 是最下方button的高度
    self.orderInfoTableView.contentOffset = CGPointMake(0, kbSize.height - 10 - SW_KEYBOARD_ACCESSVIEW_HEIGHT);
    
    
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    self.orderInfoTableView.contentInset = UIEdgeInsetsZero;
    self.orderInfoTableView.contentOffset = CGPointMake(0, 0);
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
    UIView *bkView = [[UIView alloc] init];
    bkView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bkView];
    [bkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.mas_topLayoutGuideBottom);
        }
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
    }];
    _orderInfoTableView = [[UITableView alloc] init];
    _orderInfoTableView.delegate = self;
    _orderInfoTableView.dataSource = self;
    [bkView addSubview:_orderInfoTableView];
    [_orderInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(bkView);
        make.bottom.equalTo(bkView.mas_bottom).offset(-75);
    }];
    [_orderInfoTableView registerClass:[SWOrderCountTableViewCell class] forCellReuseIdentifier:@"ORDER_COUNT_CELL_IDENTIFY"];
    [_orderInfoTableView registerClass:[SWOrderRemarkTableViewCell class] forCellReuseIdentifier:@"ORDER_REMARK_CELL_IDENTIFY"];
    [_orderInfoTableView registerClass:[SWOrderTotalPriceTableViewCell class] forCellReuseIdentifier:@"ORDER_TOTAL_PRICE_CELL_IDENTIFY"];
    [_orderInfoTableView registerClass:[SWOrderInfoPhotoTableViewCell class] forCellReuseIdentifier:@"ORDER_PHOTO_CELL_IDENTIFY"];
    [_orderInfoTableView registerClass:[SWOrderDetailTableViewCell class] forCellReuseIdentifier:@"ORDER_DETAIL_CELL_IDENTIFY"];
    _orderInfoTableView.tableFooterView = [[UIView alloc] init];
    
    
//    _okBtn = [[UIButton alloc] init];
//    _okBtn.titleLabel.font = SW_DEFAULT_FONT;
//    [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [_okBtn setBackgroundColor:SW_RMC_GREEN];
//    _okBtn.layer.cornerRadius = SW_DEFAULT_CORNER_RADIOUS;
//    _okBtn.clipsToBounds = YES;
//    [self.view addSubview:_okBtn];
    
    _saveBtn = [[UIButton alloc] init];
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saveBtn setTitle:@"保 存" forState:UIControlStateNormal];
    [_saveBtn setBackgroundColor:SW_RMC_GREEN];
    _saveBtn.layer.cornerRadius = SW_DEFAULT_CORNER_RADIOUS;
    _saveBtn.clipsToBounds = YES;
    _saveBtn.titleLabel.font = SW_DEFAULT_FONT_LARGE_BOLD;
    [_saveBtn addTarget:self action:@selector(saveBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bkView addSubview:_saveBtn];
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(bkView.mas_left).offset(SW_CELL_LEFT_MARGIN);
        make.topMargin.equalTo(self.orderInfoTableView.mas_bottom).offset(SW_MARGIN);
        make.bottomMargin.equalTo(bkView.mas_bottom).offset(-SW_MARGIN);
        make.width.equalTo(bkView.mas_width).multipliedBy(0.4);
    }];
    
    _delBtn = [[UIButton alloc] init];
    [_delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_delBtn setTitle:@"删 除" forState:UIControlStateNormal];
    _delBtn.titleLabel.font = SW_DEFAULT_FONT_LARGE_BOLD;
    [_delBtn setBackgroundColor:SW_WARN_RED];
    _delBtn.layer.cornerRadius = SW_DEFAULT_CORNER_RADIOUS;
    _delBtn.clipsToBounds = YES;
    [_delBtn addTarget:self action:@selector(delBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bkView addSubview:_delBtn];
    [_delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.saveBtn.mas_right).offset(SW_MARGIN * 0.7);
        make.topMargin.equalTo(self.orderInfoTableView.mas_bottom).offset(SW_MARGIN);
        make.bottomMargin.equalTo(bkView.mas_bottom).offset(-SW_MARGIN);
        make.width.equalTo(bkView.mas_width).multipliedBy(0.25);
    }];
    
    _connectBtn = [[UIButton alloc] init];
    [_connectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_connectBtn setTitle:@"联 系" forState:UIControlStateNormal];
    [_connectBtn setBackgroundColor:SW_MAIN_BLUE_COLOR];
    _connectBtn.titleLabel.font = SW_DEFAULT_FONT_LARGE_BOLD;
    _connectBtn.layer.cornerRadius = SW_DEFAULT_CORNER_RADIOUS;
    _connectBtn.clipsToBounds = YES;
    [_connectBtn addTarget:self action:@selector(connectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bkView addSubview:_connectBtn];
    [_connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.delBtn.mas_right).offset(SW_MARGIN * 0.7);
        make.topMargin.equalTo(self.orderInfoTableView.mas_bottom).offset(SW_MARGIN);
        make.bottomMargin.equalTo(bkView.mas_bottom).offset(-SW_MARGIN);
        make.rightMargin.equalTo(bkView.mas_right).offset(-SW_MARGIN);
    }];
    
    
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
            return SW_CELL_DEFAULT_HEIGHT;
        }
        
        if (indexPath.row == 3) { // order 备注
           return SW_CELL_DEFAULT_HEIGHT;
        }
        
        if (indexPath.row == 4) { // 合计金额
            return SW_CELL_DEFAULT_HEIGHT;
        }
        
    }else { //  商家信息
        
    }
    return SW_CELL_DEFAULT_HEIGHT;
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
            NSMutableArray *photoArray = nil;
            if (self.orderInfo.productItem.productPhotos.count == 0) {
                photoArray = [NSMutableArray arrayWithObject:[UIImage imageNamed:@"ProductThumb"]];
            }else {
                photoArray = [[NSMutableArray alloc] init];
                for (SWProductPhoto *photo in self.orderInfo.productItem.productPhotos) {
                    [photoArray addObject:photo.photo];
                }
            }
            ((SWOrderInfoPhotoTableViewCell *)cell).photos = photoArray;
            ((SWOrderInfoPhotoTableViewCell *)cell).photoCellClicked = ^(NSInteger index) {
                
            };
        }
        
        if (indexPath.row == 2) { // 购买数量
            cell = [tableView dequeueReusableCellWithIdentifier:@"ORDER_COUNT_CELL_IDENTIFY" forIndexPath:indexPath];
            [((SWOrderCountTableViewCell *)cell) setOrderInfo:self.orderInfo];
            WeakObj(self);
            ((SWOrderCountTableViewCell *)cell).orderCountUpdateBlock = ^(CGFloat orderCount) {
                StrongObj(self);
                if (orderCount != self.orderInfo.itemCount) {
                    self.orderInfoChanged = YES;
                    self.orderInfo.itemCount = orderCount;
                    self.orderInfo.orderTotalPrice = orderCount * self.orderInfo.productItem.price;
                    [self.orderInfoTableView reloadData];
                }
            } ;
        }
        
        if (indexPath.row == 3) { // order 备注
            cell = [tableView dequeueReusableCellWithIdentifier:@"ORDER_REMARK_CELL_IDENTIFY" forIndexPath:indexPath];
            [((SWOrderRemarkTableViewCell *)cell) setOrderRemark:self.orderInfo.orderRemark];
            WeakObj(self);
            ((SWOrderRemarkTableViewCell *)cell).remarkChangeBlock = ^(NSString *remark) {
                StrongObj(self);
                if (![remark isEqualToString:self.orderInfo.orderRemark]) {
                    self.orderInfoChanged = YES;
                    self.orderInfo.orderRemark = remark;
                }
            };
        }
        
        if (indexPath.row == 4) { // 合计金额
            cell = [tableView dequeueReusableCellWithIdentifier:@"ORDER_TOTAL_PRICE_CELL_IDENTIFY" forIndexPath:indexPath];
            [((SWOrderTotalPriceTableViewCell *)cell) setOrderInfo:self.orderInfo];
            WeakObj(self);
            ((SWOrderTotalPriceTableViewCell *)cell).priceChangedBlock = ^(CGFloat totalPrice) {
                StrongObj(self);
                if (totalPrice != self.orderInfo.orderTotalPrice) {
                    self.orderInfoChanged = YES;
                    self.orderInfo.orderTotalPrice = totalPrice;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.orderInfoTableView reloadData];
                    });
                    
                }
            };
        }
            
    }else { //  商家信息
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UI Event
- (void)saveBtnClicked:(UIButton *)btn {
    if (self.orderInfoChanged) {
        [SWProductOrderStorage updateProductOrder:self.orderInfo];
        self.orderInfoChanged = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)delBtnClicked:(UIButton *)btn {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定删除该条目吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SWProductOrderStorage removeProductOrder:self.orderInfo];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertView addAction:cancleAction];
    [alertView addAction:okAction];
    
    [self presentViewController:alertView animated:YES completion:^{
        
    }];
}

- (void)connectBtnClicked:(UIButton *)btn {
    SWMarketItem *market = self.orderInfo.marketItem;
    SWMarketContactViewController *vc = [[SWMarketContactViewController alloc] initWithContactArray:market.telNums];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
