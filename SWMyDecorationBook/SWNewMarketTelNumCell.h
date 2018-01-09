//
//  SWNewMarketTelNumCell.h
//  SWMyDecorationBook
//
//  Created by ShiTeng on 2018/1/2.
//  Copyright © 2018年 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWMarketContact.h"
@interface SWNewMarketTelNumCell : UITableViewCell
@property(nonatomic, strong) SWMarketContact *marketContact;
@property(nonatomic, strong) UITextField *contactNameTextField;
@property(nonatomic, strong) UITextField *telNumTextField;
@end
