//
//  SWOrderView.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/4/19.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWOrderView.h"
#import "Masonry.h"
#import "SWUIDef.h"
#import "SWDef.h"
#import "SWOrderProductInfoTableViewCell.h"
#import "SWOrderCountTableViewCell.h"
#import "SWShoppingItemRemarkCell.h"
#import "SWOrderRemarkTableViewCell.h"
#import "UITextField+OKToolBar.h"

static NSString *SW_ORDER_COUNT_CELL_IDENTITY = @"SW_ORDER_COUNT_CELL_IDENTITY";
static NSString *SW_PRODUCT_INFO_CELL_IDENTITY = @"SW_PRODUCT_INFO_CELL_IDENTITY";
static NSString *SW_ORDER_REMARK_CELL_IDENTITY = @"SW_ORDER_REMARK_CELL_IDENTITY";

#define SW_ORDER_VIEW_HEIGHT 420
@interface SWOrderView()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property(nonatomic, strong) UIButton *cancelBtn;
@property(nonatomic, strong) UIButton *okBtn;
@property(nonatomic, strong) UIView *coverView;
@property(nonatomic, strong) UITableView *orderInfoTableView;
@property(nonatomic, assign) CGFloat orderCount;
@property(nonatomic, strong) NSString *orderRemark;
@property(nonatomic, strong) UITextField *txtFTotalPrice;
@property(nonatomic, strong) UIView *bottomView;
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
            self.frame = CGRectMake(0, parentView.frame.size.height - SW_ORDER_VIEW_HEIGHT + SW_MARGIN, screenFrame.size.width, SW_ORDER_VIEW_HEIGHT);
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
    self.backgroundColor = [UIColor whiteColor];
    
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
    [_orderInfoTableView registerClass:[SWOrderProductInfoTableViewCell class] forCellReuseIdentifier:SW_PRODUCT_INFO_CELL_IDENTITY];
    [_orderInfoTableView registerClass:[SWOrderRemarkTableViewCell class] forCellReuseIdentifier:SW_ORDER_REMARK_CELL_IDENTITY];
    _orderInfoTableView.delegate = self;
    _orderInfoTableView.dataSource = self;
    _orderInfoTableView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_orderInfoTableView];
    [_orderInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(2 * SW_MARGIN);
        make.right.left.equalTo(self);
        make.height.equalTo(@300);
    }];
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor whiteColor];
    _bottomView.layer.borderWidth = 0.8f;
    _bottomView.layer.borderColor = SW_DISABLE_GRAY.CGColor;
    [self addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_orderInfoTableView.mas_bottom);
        make.bottom.equalTo(self).offset(-SW_MARGIN);
        make.left.equalTo(self).offset(-1.0);
        make.right.equalTo(self).offset(1.0);
    }];
    
    
    
    UILabel *labPriceTotal = [[UILabel alloc] init];
    labPriceTotal.font = SW_DEFAULT_FONT;
    labPriceTotal.textColor = SW_TAOBAO_BLACK;
    labPriceTotal.textAlignment = NSTextAlignmentRight;
    labPriceTotal.text = @"合计金额: ￥";
    [_bottomView addSubview:labPriceTotal];
    [labPriceTotal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(_bottomView);
        make.width.equalTo(_bottomView).multipliedBy(0.33);
    }];
    
    _txtFTotalPrice = [[UITextField alloc] init];
    _txtFTotalPrice.font = SW_DEFAULT_FONT_LARGE;
    _txtFTotalPrice.textColor = SW_TAOBAO_ORANGE;
    _txtFTotalPrice.backgroundColor = SW_DISABLIE_THIN_WHITE;
    _txtFTotalPrice.keyboardType = UIKeyboardTypeDecimalPad;
    _txtFTotalPrice.delegate = self;
    _txtFTotalPrice.text = [NSString stringWithFormat:@"%.2lf", self.model.price];
    [_txtFTotalPrice addOKToolBar];
    [_bottomView addSubview:_txtFTotalPrice];
    [_txtFTotalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labPriceTotal.mas_right);
        make.top.equalTo(_bottomView.mas_top).offset( 0.5 * SW_MARGIN);
        make.bottom.equalTo(_bottomView.mas_bottom).offset(-0.5 * SW_MARGIN);
        make.width.equalTo(_bottomView).multipliedBy(0.33);
    }];
    
    _okBtn = [[UIButton alloc] init];
    _okBtn.backgroundColor = SW_RMC_GREEN;
    _okBtn.titleLabel.font = SW_DEFAULT_FONT_LARGE;
    _okBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_okBtn addTarget:self action:@selector(okBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_okBtn];
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_txtFTotalPrice.mas_right).offset(0.2 * SW_MARGIN);
        make.bottom.right.equalTo(_bottomView);
        make.top.equalTo(_bottomView.mas_top).offset(0.8);
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

- (void)okBtnClicked:(UIButton *)okBtn {
    if (self.orderCount > 0) {
        // 产生一份新的订单
        SWOrder *newOrder = [[SWOrder alloc] init];
        newOrder.productItem = self.model;
        newOrder.itemCount = self.orderCount;
        newOrder.orderTotalPrice = self.txtFTotalPrice.text.floatValue;
        newOrder.orderRemark = self.orderRemark;
        
        if ([self.delegate respondsToSelector:@selector(SWOrderView:didOrderItem:)]) {
            [self.delegate SWOrderView:self didOrderItem:newOrder];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(SWOrderView:cancelOrderItem:)]) {
            [self.delegate SWOrderView:self cancelOrderItem:self.model];
        }
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 180;
    }
    return 60;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:SW_ORDER_COUNT_CELL_IDENTITY];
        WeakObj(self);
        ((SWOrderCountTableViewCell *)cell).orderCountUpdateBlock = ^(CGFloat orderCount) {
            StrongObj(self);
            if (self) {
                if (orderCount != self.orderCount) {
                    self.orderCount = orderCount;
                    CGFloat totalPrice = self.model.price * orderCount;
                    self.txtFTotalPrice.text = [NSString stringWithFormat:@"%.2lf", totalPrice];
                    [self.orderInfoTableView reloadData];
                }
            }
        };
    }else if(indexPath.row == 0){
        
        cell = [tableView dequeueReusableCellWithIdentifier:SW_PRODUCT_INFO_CELL_IDENTITY];
        [((SWOrderProductInfoTableViewCell *)cell) setModel:self.model];
        [((SWOrderProductInfoTableViewCell *)cell) updateProductOrderCount:self.orderCount];
        
    }else if(indexPath.row == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:SW_ORDER_REMARK_CELL_IDENTITY];
        WeakObj(self);
        ((SWOrderRemarkTableViewCell *)cell).remarkChangeBlock = ^(NSString *remark) {
            StrongObj(self);
            if (self) {
                self.orderRemark = remark;
            }
        };
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        textField.text = @"0.00";
    }else {
        CGFloat totalCount = textField.text.floatValue;
        textField.text = [NSString stringWithFormat:@"%.2lf", totalCount];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.text isEqualToString:@"0.00"]) {
        textField.text = string;
        return NO;
    }
    return YES;
}

#pragma mark - Notification
- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notificaiton {
    NSDictionary *info = notificaiton.userInfo;
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if (self.txtFTotalPrice.isFirstResponder) {
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(-1.0);
            make.right.equalTo(self).offset(1.0);
            make.bottom.equalTo(self).offset(-kbSize.height - SW_MARGIN);
            make.height.equalTo(@60);
        }];
        self.okBtn.hidden = YES;
    }else {
        self.orderInfoTableView.contentInset = UIEdgeInsetsMake(0, 0, kbSize.height - 60, 0);  // 60 是最下方button的高度
        self.orderInfoTableView.contentOffset = CGPointMake(0, kbSize.height - 10 - SW_KEYBOARD_ACCESSVIEW_HEIGHT);
    }
    
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    if (self.txtFTotalPrice.isFirstResponder) {
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_orderInfoTableView.mas_bottom);
            make.bottom.equalTo(self).offset(-SW_MARGIN);
            make.left.equalTo(self).offset(-1.0);
            make.right.equalTo(self).offset(1.0);
        }];
        self.okBtn.hidden = NO;
    }else {
        self.orderInfoTableView.contentInset = UIEdgeInsetsZero;
        self.orderInfoTableView.contentOffset = CGPointMake(0, 0);
    }
}
@end
