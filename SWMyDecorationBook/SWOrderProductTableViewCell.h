//
//  SWOrderProductTableViewCell.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/4/23.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWProductItem.h"

@interface SWOrderProductTableViewCell : UITableViewCell
- (void)setModel:(SWProductItem *)productItem;
- (void)updateProductOrderCount:(NSInteger)orderCount;
@end
