//
//  SWMarketContactSectionHeaderView.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/4/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^addContactActionBlock)();
@interface SWMarketContactSectionHeaderView : UITableViewHeaderFooterView
@property(nonatomic, copy) addContactActionBlock addContactAction;
@end
