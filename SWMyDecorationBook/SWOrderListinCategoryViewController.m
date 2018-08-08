//
//  SWOrderListinCategoryViewController.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/8.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWOrderListinCategoryViewController.h"
#import "SWOrder.h"
#import "Masonry.h"

@interface SWOrderListinCategoryViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) NSMutableArray<NSDictionary *> *orderArray;
@property(nonatomic, strong) UITableView *orderListTableView;
@property(nonatomic, strong) SWShoppingOrderCategoryModle *shoppingOrderCategory;
@end

@implementation SWOrderListinCategoryViewController

- (instancetype)initWithOrderList:(NSArray *)orderList inShoppingCategory:(SWShoppingOrderCategoryModle *)orderCategory {
    if (self = [super init]) {
        [self sortOrderList:orderList];
        _shoppingOrderCategory = orderCategory;
        [self commonInit];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = [NSString stringWithFormat:@"%@账目", self.shoppingOrderCategory.orderCategoryName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Setter/Getter
- (NSMutableArray *)orderArray {
    if (_orderArray == nil) {
        _orderArray = [[NSMutableArray alloc] init];
    }
    return _orderArray;
}

#pragma mark - Private method
- (void)sortOrderList:(NSArray *)orderList {
    NSArray *sortedOrderList = [orderList sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        SWOrder *firstObj = (SWOrder *)obj1;
        SWOrder *secondObj = (SWOrder *)obj2;
        return [firstObj.orderDate compare:secondObj.orderDate];
    }];
    NSMutableDictionary *dict = nil;
    for (SWOrder *order in sortedOrderList) {
        if (dict == nil) {
            dict = [[NSMutableDictionary alloc] init];
            NSMutableArray *array = [NSMutableArray arrayWithObject:order];
            [dict setObject:array forKey:order.orderDate];
            [self.orderArray addObject:dict];
        }else {
            NSDate *dictKey = (NSDate *)dict.allKeys.firstObject;
            if ([dictKey isEqual:order.orderDate]) {
                NSMutableArray *orderArray = [dict objectForKey:dictKey];
                [orderArray addObject:order];
            }else {
                [self.orderArray addObject:dict];
                dict = [[NSMutableDictionary alloc] init];
                NSMutableArray *array = [NSMutableArray arrayWithObject:order];
                [dict setObject:array forKey:order.orderDate];
            }
        }
    }
}

#pragma mark - CommonInit
- (void)commonInit {
    _orderListTableView = [[UITableView alloc] init];
    [_orderListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL_IDENTITY"];
    _orderListTableView.delegate = self;
    _orderListTableView.dataSource = self;
    _orderListTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_orderListTableView];
    [_orderListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
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
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderArray.count + 1;
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        NSDictionary *orderInfo = self.orderArray[section - 1];
        NSDate *key = orderInfo.allKeys.firstObject;
        NSArray *orderArray = [orderInfo objectForKey:key];
        return orderArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_IDENTITY" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"总花费 %lf", self.shoppingOrderCategory.totalCost];
    }else {
        NSDictionary *orderInfo = self.orderArray[indexPath.section - 1];
        NSDate *key = orderInfo.allKeys.firstObject;
        NSArray *orderArray = [orderInfo objectForKey:key];
        SWOrder *order = orderArray[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ * %lf 总价: %lf", order.productItem.productName, order.itemCount, order.orderTotalPrice];
    }
    return cell;
}

@end
