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

@interface SWShoppingItemPriceCell : UITableViewCell
@property(nonatomic, strong) UILabel *priceUnitLab;
@property(nonatomic, strong) NSString *priceUnitStr;
@property(nonatomic, strong) UITextField *priceTextField;
@property(nonatomic, strong) SWProductItem *productItem;
@end
