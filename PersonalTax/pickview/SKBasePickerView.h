//
//  SKBasePickerView.h
//  YMOCCodeStandard
//
//  Created by iOS on 2018/11/12.
//  Copyright © 2018 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKTaxPaymentItemDataModel.h"
#import "SKPickerToolBarView.h"

NS_ASSUME_NONNULL_BEGIN

/** 内容视图高度 */
static CGFloat kContentViewHeight = 300;
/** 工具栏高度 */
static CGFloat kToolBarViewHeight = 48;

/** 协议方法 */
@protocol SKBasePickerViewDelegate <NSObject>

@optional;
/** 按钮点击代理方法 */
- (void)actionWithButton:(UIButton *)sender;
/** 标题带出 */
- (void)actionWithButton:(UIButton *)sender title:(NSString *)title;

@end

@interface SKBasePickerView : UIView

/** 代理 */
@property (nonatomic, weak) id<SKBasePickerViewDelegate> delegate;

/** 内容视图 */
@property (nonatomic, strong, readonly) UIView *contentView;

/** 工具栏 */
@property (nonatomic, strong) SKPickerToolBarView *toolBarView;

/**
 析构函数

 @param frame frame
 @param delegate 代理
 @param title 标题
 @param leftBtnTitle 左侧按钮文字
 @param rightBtnTitle 右侧按钮文字
 @return dataModel 模型
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SKBasePickerViewDelegate>)delegate title:(NSString *)title leftBtnTitle:(NSString *)leftBtnTitle rightBtnTitle:(NSString *)rightBtnTitle;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SKBasePickerViewDelegate>)delegate title:(NSString *)title leftBtnTitle:(NSString *)leftBtnTitle rightBtnTitle:(NSString *)rightBtnTitle dataModel:(SKTaxPaymentItemDataModel *)dataModel;

/**
 加载视图
 */
- (void)loadSubviews;


/**
 配置属性
 */
- (void)configProprty;


/**
 加载数据
 */
- (void)loadData;
- (void)loadData:(SKTaxPaymentItemDataModel *)dataModel;


/**
 显示
 */
- (void)show;

/**
 隐藏
 */
- (void)hide ;
@end

NS_ASSUME_NONNULL_END
