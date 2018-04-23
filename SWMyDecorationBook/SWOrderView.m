//
//  SWOrderView.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/4/19.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWOrderView.h"
#import "SWOrderCountTableViewCell.h"
#import "Masonry.h"
#import "SWOrderProductTableViewCell.h"
#import "SWUIDef.h"
#import "SWDef.h"

static NSString *SW_ORDER_COUNT_CELL_IDENTITY = @"SW_ORDER_COUNT_CELL_IDENTITY";
static NSString *SW_PRODUCT_INFO_CELL_IDENTITY = @"SW_PRODUCT_INFO_CELL_IDENTITY";

#define SW_ORDER_VIEW_HEIGHT 300
@interface SWOrderView()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UIButton *cancelBtn;
@property(nonatomic, strong) UIButton *okBtn;
@property(nonatomic, strong) UIView *coverView;
@property(nonatomic, strong) UITableView *orderInfoTableView;
@property(nonatomic, assign) NSInteger orderCount;
@end

@implementation SWOrderView
- (instancetype)initWithProductItem:(SWProductItem *)productItem {
    if (self = [super init]) {
        _model = productItem;
        _orderCount = 1;
        [self commonInit];
    }
    return self;
}

- (void)attachToView:(UIView *)parentView {
    if (parentView) {
        [parentView addSubview:self];
        CGRect screenFrame = [UIScreen mainScreen].bounds;
        self.frame = CGRectMake(0, screenFrame.size.height + SW_ORDER_VIEW_HEIGHT, screenFrame.size.width, SW_ORDER_VIEW_HEIGHT);
    }
}
- (void)showOrderView {
    UIView *parentView = [self superview];
    if (parentView) {
        CGRect screenFrame = [UIScreen mainScreen].bounds;
        [self showCoverView];
        [UIView animateWithDuration:0.4 animations:^{
            self.frame = CGRectMake(0, parentView.frame.size.height - SW_ORDER_VIEW_HEIGHT, screenFrame.size.width, SW_ORDER_VIEW_HEIGHT);
        } completion:^(BOOL finished) {
            if (finished) {
               
            }
        }];
    }
}

- (void)dismissOrderView {
    [self endEditing:YES];
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    [self removeCoverView];
    [UIView animateWithDuration:0.6 animations:^{
        self.frame = CGRectMake(0, screenFrame.size.height + SW_ORDER_VIEW_HEIGHT, screenFrame.size.width, SW_ORDER_VIEW_HEIGHT);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - Private
- (void)showCoverView {
    UIView *parentView = [self superview];
    [parentView addSubview:self.coverView];
    self.coverView.frame = parentView.frame;
    [parentView bringSubviewToFront:self];
}

- (void)removeCoverView {
    [self.coverView removeFromSuperview];
}
#pragma mark - Common Init
- (void)commonInit {
    self.backgroundColor = [UIColor whiteColor];
    
    _orderInfoTableView = [[UITableView alloc] init];
    [_orderInfoTableView registerClass:[SWOrderCountTableViewCell class] forCellReuseIdentifier:SW_ORDER_COUNT_CELL_IDENTITY];
    [_orderInfoTableView registerClass:[SWOrderProductTableViewCell class] forCellReuseIdentifier:SW_PRODUCT_INFO_CELL_IDENTITY];
    _orderInfoTableView.delegate = self;
    _orderInfoTableView.dataSource = self;
    _orderInfoTableView.backgroundColor = SW_DISABLIE_THIN_WHITE;
    [self addSubview:_orderInfoTableView];
    [_orderInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    self.coverView = [[UIView alloc] initWithFrame:CGRectZero];
    self.coverView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewTapped:)];
    [self.coverView addGestureRecognizer:tapGesture];
}


#pragma mark - UI Response
- (void)backgroundViewTapped:(UITapGestureRecognizer *)tapGesture {
    [self dismissOrderView];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //if (indexPath.row == 1) {
    if (indexPath.row == 0) {
        return 150;
    }else {
        return 60;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:SW_PRODUCT_INFO_CELL_IDENTITY];
        [((SWOrderProductTableViewCell *)cell) setModel:self.model];
        [((SWOrderProductTableViewCell *)cell) updateProductOrderCount:self.orderCount];
        
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:SW_ORDER_COUNT_CELL_IDENTITY];
        WeakObj(self);
        ((SWOrderCountTableViewCell *)cell).orderCountUpdateBlock = ^(NSInteger orderCount) {
            StrongObj(self);
            if (self) {
                if (orderCount != self.orderCount) {
                    self.orderCount = orderCount;
                    [self.orderInfoTableView reloadData];
                }
            }
        };
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
@end
