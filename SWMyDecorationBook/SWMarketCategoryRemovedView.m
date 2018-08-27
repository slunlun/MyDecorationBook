//
//  SWMarketCategoryRemovedView.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/27.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWMarketCategoryRemovedView.h"
#import "Masonry.h"
#import "SWUIDef.h"

@implementation SWMarketCategoryRemovedView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"EmptyBig"]];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_centerY).offset(-SW_MARGIN * 0.5);
        make.width.height.equalTo(@100);
    }];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.numberOfLines = 0;
    lab.font = SW_DEFAULT_FONT_LARGE;
    lab.textColor = SW_DISABLE_GRAY;
    lab.text = @"目前商品分类为空，请先在侧滑菜单中创建一个商品分类";
    [self addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(SW_MARGIN * 0.5);
        make.width.equalTo(self).multipliedBy(0.7);
    }];
}
@end
