//
//  SWShoppingItemPriceCell.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/9/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWItemUnit.h"
#import "SWProductItem.h"
typedef void(^priceChangeAction)(NSString *price);
@interface SWShoppingItemPriceCell : UITableViewCell
@property(nonatomic, strong) SWProductItem *productItem;
@property(nonatomic, copy) priceChangeAction priceChangeBlock;
@end
