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
#import "SWUIDef.h"
#import "SWDef.h"
#import "SWOrderProductInfoView.h"

static NSString *SW_ORDER_COUNT_CELL_IDENTITY = @"SW_ORDER_COUNT_CELL_IDENTITY";
static NSString *SW_PRODUCT_INFO_CELL_IDENTITY = @"SW_PRODUCT_INFO_CELL_IDENTITY";

#define SW_ORDER_VIEW_HEIGHT 400
@interface SWOrderView()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UIButton *cancelBtn;
@property(nonatomic, strong) UIButton *okBtn;
@property(nonatomic, strong) UIView *coverView;
@property(nonatomic, strong) UITableView *orderInfoTableView;
@property(nonatomic, assign) NSInteger orderCount;
@property(nonatomic, strong) SWOrderProductInfoView *orderProductInfoView;
@end

@implementation SWOrderView
- (instancetype)initWithProductItem:(SWProductItem *)productItem {
    if (self = [super init]) {
        _model = productItem;
        _orderCount = 1;
        [self registerNotification];
        [self commonInit];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = YES;
    self.backgroundColor = SW_DISABLIE_THIN_WHITE;
    
    
    
    _orderProductInfoView = [[SWOrderProductInfoView alloc] init];
    [self addSubview:_orderProductInfoView];
    [_orderProductInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0.5 * SW_MARGIN);
        make.left.equalTo(self).offset(0.5 * SW_MARGIN);
        make.right.equalTo(self).offset(0.5 * SW_MARGIN);
        make.height.equalTo(@120);
    }];
    
    [_orderProductInfoView setModel:self.model];
    
    _cancelBtn = [[UIButton alloc] init];
    _cancelBtn.imageView.contentMode = UIViewContentModeCenter;
    [_cancelBtn setImage:[UIImage imageNamed:@"RoundCancel"] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelBtn];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0.2 * SW_MARGIN);
        make.right.equalTo(self).offset(-0.2 * SW_MARGIN);
        make.height.width.equalTo(@50);
    }];
    
    _orderInfoTableView = [[UITableView alloc] init];
    [_orderInfoTableView registerClass:[SWOrderCountTableViewCell class] forCellReuseIdentifier:SW_ORDER_COUNT_CELL_IDENTITY];
    _orderInfoTableView.delegate = self;
    _orderInfoTableView.dataSource = self;
    _orderInfoTableView.backgroundColor = SW_DISABLIE_THIN_WHITE;
    [self addSubview:_orderInfoTableView];
    [_orderInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_orderProductInfoView.mas_bottom);
        make.right.left.equalTo(self);
        make.height.equalTo(@210);
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
- (void)cancelBtnClicked:(UIButton *)cancelBtn {
    [self dismissOrderView];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //if (indexPath.row == 1) {
    return 60;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:SW_ORDER_COUNT_CELL_IDENTITY];
        WeakObj(self);
        ((SWOrderCountTableViewCell *)cell).orderCountUpdateBlock = ^(NSInteger orderCount) {
            StrongObj(self);
            if (self) {
                if (orderCount != self.orderCount) {
                    self.orderCount = orderCount;
                    [self.orderProductInfoView updateProductOrderCount:self.orderCount];
                }
            }
        };
    }else {
       
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - Notification
- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notificaiton {
    NSDictionary *info = notificaiton.userInfo;
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.orderInfoTableView.contentInset = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    self.orderInfoTableView.contentInset = UIEdgeInsetsZero;
}
@end
