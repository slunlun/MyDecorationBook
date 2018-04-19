//
//  SWOrderView.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/4/19.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWOrderView.h"
#define SW_ORDER_VIEW_HEIGHT 300
@interface SWOrderView()
@property(nonatomic, strong) UIButton *cancelBtn;
@property(nonatomic, strong) UIButton *okBtn;
@property(nonatomic, strong) UIView *coverView;
@end

@implementation SWOrderView
- (instancetype)initWithProductItem:(SWProductItem *)productItem {
    if (self = [super init]) {
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
    
}
#pragma mark - UI Response

@end
