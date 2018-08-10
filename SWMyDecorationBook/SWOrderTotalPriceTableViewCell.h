//
//  SWOrderTotalPriceTableViewCell.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/10.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWOrder.h"

typedef void(^orderTotalPriceChangedBlock)(CGFloat totalPrice);
@interface SWOrderTotalPriceTableViewCell : UITableViewCell
- (void)setOrderInfo:(SWOrder *)orderInfo;
@property(nonatomic, copy) orderTotalPriceChangedBlock priceChangedBlock;
@end
