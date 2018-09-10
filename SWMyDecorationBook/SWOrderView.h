//
//  SWOrderView.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/4/19.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWOrder.h"

@class SWOrderView;
@protocol SWOrderViewDelegate<NSObject>
- (void)SWOrderView:(SWOrderView *)orderView didOrderItem:(SWOrder *)productOrder;
- (void)SWOrderView:(SWOrderView *)orderView cancelOrderItem:(SWProductItem *)product;
- (void)SWOrderView:(SWOrderView *)orderView didDelOrder:(SWProductItem *)product;
- (void)SWOrderView:(SWOrderView *)orderView didUpdateOrder:(SWOrder *)product;
@end

@interface SWOrderView : UIView
- (instancetype)initWithProductItem:(SWProductItem *)productItem;
- (void)attachToView:(UIView *)parentView;
- (void)showOrderView;
- (void)dismissOrderView;

@property(nonatomic, strong) SWProductItem *model;
@property(nonatomic, weak) id<SWOrderViewDelegate> delegate;
@end
