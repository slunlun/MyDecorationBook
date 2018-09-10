//
//  SWOrderCountTableViewCell.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/4/20.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWOrder.h"
typedef void(^orderCountUpdateBlock)(CGFloat orderCount);

@interface SWOrderCountTableViewCell : UITableViewCell
- (void)setOrderInfo:(SWOrder *)orderInfo;
- (void)updateOrderCount:(CGFloat)orderCount;
@property(nonatomic, copy) orderCountUpdateBlock orderCountUpdateBlock;
@end
