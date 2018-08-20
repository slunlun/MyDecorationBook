//
//  SWProductTableViewCell.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/30/17.
//  Copyright © 2017 Eren. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SWProductItem.h"
#import "SWMarketItem.h"

@class SWProductTableViewCell;
@protocol SWProductTableViewCellDelegate <NSObject>
- (void)productTableViewCell:(SWProductTableViewCell *)cell didSelectImage:(UIImage *)image;
- (void)productTableViewCell:(SWProductTableViewCell *)cell didClickEditProduct:(SWProductItem *)productItem;
- (void)productTableViewCell:(SWProductTableViewCell *)cell didClickDelProduct:(SWProductItem *)productItem;
- (void)productTableViewCell:(SWProductTableViewCell *)cell didClickBuyProduct:(SWProductItem *)productItem;
- (void)productTableViewCell:(SWProductTableViewCell *)cell didUnBuyProduct:(SWProductItem *)productItem;
- (void)productTableViewCell:(SWProductTableViewCell *)cell didClickTakeProductPhoto:(SWProductItem *)productItem;

@end

@interface SWProductTableViewCell : UITableViewCell
@property(nonatomic, strong) UIButton *buyBtn;
@property(nonatomic, strong) SWProductItem *productItem;
@property(nonatomic, weak) id<SWProductTableViewCellDelegate> delegate;
@end
