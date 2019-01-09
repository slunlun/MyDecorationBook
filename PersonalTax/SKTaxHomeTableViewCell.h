//
//  SKTaxHomeTableViewCell.h
//  SKIncomeTaxCalculator
//
//  Created by Stepanoval (Xinxin) Huang on 2018/12/27.
//  Copyright © 2018 skyline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKTaxPaymentItemDataModel.h"
@class SKTaxHomeTableViewCell;

/** 协议方法 */
@protocol SKTaxHomeTableViewCellDelegate <NSObject>
/** 删除按钮点击代理方法 */
- (void)actionWithDeleteButton:(SKTaxHomeTableViewCell *)cell dataModel:(SKTaxPaymentItemDataModel *)model;
- (void)actionWithDetailButton:(SKTaxHomeTableViewCell *)cell dataModel:(SKTaxPaymentItemDataModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SKTaxHomeTableViewCell : UITableViewCell

@property (nonatomic, weak) id<SKTaxHomeTableViewCellDelegate> delegate;


@property(nonatomic, weak, readonly) UILabel *titleLabel;
@property(nonatomic, weak, readonly) UILabel *contentLabel;
@property(nonatomic, weak, readonly) UIView *customAccessView;
@property(nonatomic, weak, readonly) UIButton *deleteButton;

@property(nonatomic, strong) SKTaxPaymentItemDataModel *model;

@end
NS_ASSUME_NONNULL_END

