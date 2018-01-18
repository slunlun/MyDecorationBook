//
//  SWMarketNameCell.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/5/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^nameInputFinishBlock)(NSString *inputName);
@interface SWMarketNameCell : UITableViewCell
@property(nonatomic, readonly, strong) UITextField *marketNameTextField;
@property(nonatomic, strong) UILabel *titleLab;
@property(nonatomic, assign) nameInputFinishBlock finishBlock;
@end
