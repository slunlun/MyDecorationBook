//
//  SWOrderProductInfoView.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/4/24.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWProductItem.h"

@interface SWOrderProductInfoView : UIView
- (void)setModel:(SWProductItem *)productItem;
- (void)updateProductOrderCount:(NSInteger)orderCount;
@end
