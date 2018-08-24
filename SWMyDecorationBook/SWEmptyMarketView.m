//
//  SWEmptyMarketView.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/24.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWEmptyMarketView.h"
#import "Masonry.h"
#import "SWUIDef.h"
@implementation SWEmptyMarketView
- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundClicked:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundClicked:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - CommonInit
- (void)commonInit {
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AddMarketBig"]];
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
    lab.text = @"当前分类下商家列表为空，可点击屏幕添加";
    [self addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(SW_MARGIN * 0.5);
    }];
}

#pragma mark - UI Response
- (void)backgroundClicked:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(didClickedEmptyView)]) {
        [self.delegate didClickedEmptyView];
    }
}
@end
