//
//  SKSocialSecurityCell.m
//  SKIncomeTaxCalculator
//
//  Created by Tim (Xinyin) Liu on 2018/12/26.
//  Copyright © 2018 skyline. All rights reserved.
//

#import "SKSocialSecurityCell.h"
#import "Masonry.h"
@interface SKSocialSecurityCell ()
@property (nonatomic, strong) UILabel *infoLabel;
@end
@implementation SKSocialSecurityCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit {
    UILabel *label = [[UILabel alloc]init];
//    label.font = [UIFont systemFontOfSize:14];
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderColor = [UIColor blackColor].CGColor;
    label.layer.borderWidth = 1.0;
    [self.contentView addSubview:label];
    self.infoLabel = label;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}
- (void)setInfoStr:(NSString *)infoStr {
    _infoStr = infoStr;
    self.infoLabel.text = infoStr;
    
}
- (void)setTextColor:(UIColor *)textColor {
    self.infoLabel.textColor = textColor;
}
@end
