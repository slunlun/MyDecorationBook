//
//  SWNewMarketTelNumCell.m
//  SWMyDecorationBook
//
//  Created by ShiTeng on 2018/1/2.
//  Copyright © 2018年 Eren. All rights reserved.
//

#import "SWNewMarketTelNumCell.h"
#import "Masonry.h"
@interface SWNewMarketTelNumCell()
@property(nonatomic, strong) UITextField *contactNameTextField;
@property(nonatomic, strong) UITextField *telNumTextField;
@property(nonatomic, strong) UIButton *defaultTelBtn;
@end
@implementation SWNewMarketTelNumCell

#pragma mark - INIT
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }
    return self;
}

#pragma mark - UI COMMON INIT
- (void)commonInit {
    _contactNameTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_contactNameTextField];
    
    _telNumTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_telNumTextField];
    
    _defaultTelBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_defaultTelBtn];
}

@end
