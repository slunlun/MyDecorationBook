//
//  SWOrderListinCategoryViewController.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/8.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWOrderListinCategoryViewController.h"
#import "SWOrder.h"
#import "SWOrderDetailTableViewCell.h"
#import "SWUIDef.h"
#import "Masonry.h"
#import "SWOrderDetailViewController.h"
#import "SWProductItemStorage.h"

@interface SWOrderListinCategoryViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) NSMutableArray<NSDictionary *> *orderArray;
@property(nonatomic, strong) UITableView *orderListTableView;
@property(nonatomic, strong) SWShoppingOrderCategoryModle *shoppingOrderCategory;
@end

@implementation SWOrderListinCategoryViewController

- (instancetype)initWithShoppingCategory:(SWShoppingOrderCategoryModle *)orderCategory {
    if (self = [super init]) {
        _shoppingOrderCategory = orderCategory;
        [self commonInit];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = [NSString stringWithFormat:@"%@账目", self.shoppingOrderCategory.orderCategoryName];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSArray *orderList = [[SWShoppingOrderManager sharedInstance] loadOrdersInCategory:self.shoppingOrderCategory];
    [self sortOrderList:orderList];
    [self.orderListTableView reloadData];
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
    [self.orderArray removeAllObjects];
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
    if (dict != nil) {
        [self.orderArray addObject:dict];
    }
}

#pragma mark - CommonInit
- (void)commonInit {
    _orderListTableView = [[UITableView alloc] init];
    [_orderListTableView registerClass:[SWOrderDetailTableViewCell class] forCellReuseIdentifier:@"ORDER_DETAIL_CELL_IDENTITY"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70;
    }else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *orderInfoDict = self.orderArray[indexPath.section - 1];
    NSDate *key = orderInfoDict.allKeys.firstObject;
    NSArray *orderArray = [orderInfoDict objectForKey:key];
    SWOrder *order = orderArray[indexPath.row];
    SWOrderDetailViewController *vc = [[SWOrderDetailViewController alloc] initWithOrderInfo:order];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - TableViewDataSource
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"";
    }else {
        NSDictionary *orderInfo = self.orderArray[section - 1];
        NSDate *key = orderInfo.allKeys.firstObject;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设置格式：zzz表示时区
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        //NSDate转NSString
        NSString *currentDateString = [dateFormatter stringFromDate:key];
        return currentDateString;
    }
}
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
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_IDENTITY" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"总花费 %.2f", self.shoppingOrderCategory.totalCost];
        cell.textLabel.font = SW_DEFAULT_FONT_LARGE_BOLD;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = SW_DISABLIE_WHITE;
    }else {
        NSDictionary *orderInfo = self.orderArray[indexPath.section - 1];
        NSDate *key = orderInfo.allKeys.firstObject;
        NSArray *orderArray = [orderInfo objectForKey:key];
        SWOrder *order = orderArray[indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ORDER_DETAIL_CELL_IDENTITY" forIndexPath:indexPath];
        [((SWOrderDetailTableViewCell *)cell) updateOrderInfo:order];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.section != 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

@end
