//
//  SWNotebookBarChartView.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/3.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWNotebookBarChartView.h"
#import "SWBarChartTableViewCell.h"
#import "SWShoppingOrderManager.h"
#import "SWTotalCostTableViewCell.h"
#import "Masonry.h"

@interface SWNotebookBarChartView()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *barChartTableView;
@property(nonatomic, strong) NSArray *orderInfoArray;
@end

@implementation SWNotebookBarChartView
- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _barChartTableView = [[UITableView alloc] init];
    _barChartTableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:_barChartTableView];
    _barChartTableView.delegate = self;
    _barChartTableView.dataSource = self;
    [_barChartTableView registerClass:[SWBarChartTableViewCell class] forCellReuseIdentifier:@"BAR_CHART_CELL"];
    [_barChartTableView registerClass:[SWTotalCostTableViewCell class] forCellReuseIdentifier:@"TOTAL_COST_CELL"];
    [_barChartTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
}

- (void)updateData {
    if (self.orderInfoArray == nil) {
        self.orderInfoArray = [[SWShoppingOrderManager sharedInstance] loadData];
        [self.barChartTableView reloadData];
    }
}

#pragma mark - Setter/Getter
- (void)setOrderInfoArray:(NSArray *)orderInfoArray {
    if (_orderInfoArray == nil) {
        _orderInfoArray = orderInfoArray;
        [self.barChartTableView reloadData];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 70.0f;
    }else {
        return 60.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.orderInfoArray == nil) {
        return 0;
    }else {
        return self.orderInfoArray.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TOTAL_COST_CELL" forIndexPath:indexPath];
        CGFloat totalCost = 0;
        for (NSDictionary *infoDict in self.orderInfoArray) {
            SWShoppingOrderCategoryModle *model = infoDict.allKeys.firstObject;
            totalCost += model.totalCost;
        }
        NSString * totalCostStr = [NSString stringWithFormat:@"¥ %.2f", totalCost];
        ((SWTotalCostTableViewCell *)cell).model = totalCostStr;
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BAR_CHART_CELL" forIndexPath:indexPath];
        NSDictionary *infoDict = self.orderInfoArray[indexPath.row - 1];
        SWShoppingOrderCategoryModle *model = infoDict.allKeys.firstObject;
        ((SWBarChartTableViewCell *)cell).model = model;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
