//
//  SWOrderDetailTableViewCell.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/9.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWOrder.h"
@interface SWOrderDetailTableViewCell : UITableViewCell
- (void)updateOrderInfo:(SWOrder *)orderInfo;
@property(nonatomic, assign) BOOL shouldDispalyRemark;
@end
