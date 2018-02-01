//
//  SWShoppingItemRemarkCell.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/9/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWProductItem.h"
@interface SWShoppingItemRemarkCell : UITableViewCell
@property(nonatomic, strong) UITextView *remarkTextView;
@property(nonatomic, strong) SWProductItem *productItem;
@end
