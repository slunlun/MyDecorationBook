//
//  SWOrderProductInfoTableViewCell.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/4/25.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWProductItem.h"

@interface SWOrderProductInfoTableViewCell : UITableViewCell
- (void)setModel:(SWProductItem *)productItem;
- (void)updateProductOrderCount:(CGFloat)orderCount;
@end
