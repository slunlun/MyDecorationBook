//
//  SWOrderTotalPriceTableViewCell.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/10.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWOrderTotalPriceTableViewCell.h"
#import "Masonry.h"
@interface SWOrderTotalPriceTableViewCell()
@property(nonatomic, strong) UITextField *txtFTotalPrice;
@end

@implementation SWOrderTotalPriceTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
}

@end
