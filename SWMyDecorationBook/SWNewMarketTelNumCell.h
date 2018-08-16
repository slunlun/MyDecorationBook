//
//  SWNewMarketTelNumCell.h
//  SWMyDecorationBook
//
//  Created by ShiTeng on 2018/1/2.
//  Copyright © 2018年 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWMarketContact.h"
typedef void(^defaultContactConfigBlock)(SWMarketContact * contact);
typedef void(^contactNameChangedBlock)(NSString *contactName);
typedef void(^contactTelNumChangedBlock)(NSString *contactTelNum);
typedef void(^contactDelBlock)();
@interface SWNewMarketTelNumCell : UITableViewCell
@property(nonatomic, strong) SWMarketContact *marketContact;
@property(nonatomic, strong) UITextField *contactNameTextField;
@property(nonatomic, strong) UITextField *telNumTextField;
@property(nonatomic, copy) defaultContactConfigBlock defaultContactSetBlock;
@property(nonatomic, copy) contactNameChangedBlock contactNameChangedBlock;
@property(nonatomic, copy) contactTelNumChangedBlock contactTelNumChangedBlock;
@property(nonatomic, copy) contactDelBlock contactDelBlock;
@end
