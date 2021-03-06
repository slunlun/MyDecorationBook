//
//  SWMarketHeaderView.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/2/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWMarketHeaderView.h"
#import "Masonry.h"
#import "SWUIDef.h"
#import "HexColor.h"
@interface SWMarketHeaderView()
@property(nonatomic, strong) UIButton *marketNameBtn;
@property(nonatomic, strong) UIImageView *accessImageView;
@property(nonatomic, strong) UIButton *callContactBtn;
@end


@implementation SWMarketHeaderView
#pragma mark - INIT
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    UIButton *marketBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [marketBtn setImage:[UIImage imageNamed:@"Market"] forState:UIControlStateNormal];
    marketBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    marketBtn.titleLabel.font = SW_DEFAULT_FONT_LARGE;
    marketBtn.titleLabel.lineBreakMode = NSLineBreakByClipping;
    [marketBtn setTitleColor:SW_TAOBAO_BLACK forState:UIControlStateNormal];
    [marketBtn addTarget:self action:@selector(marketBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    marketBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    marketBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0); // 调节button的title与他的image对齐到中心线
    self.marketNameBtn = marketBtn;
    [self.contentView addSubview:marketBtn];
    [self.marketNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.contentView.mas_left).offset(SW_MARGIN);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    UIImageView *accessorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow"]];
    UITapGestureRecognizer *imageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(marketBtnClicked:)];
    [accessorView addGestureRecognizer:imageViewTap];
    accessorView.userInteractionEnabled = YES;
    accessorView.contentMode = UIViewContentModeScaleAspectFit;
    self.accessImageView = accessorView;
    [self.contentView addSubview:accessorView];
    [self.accessImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.marketNameBtn.mas_right);
        make.width.equalTo(@20);
    }];
    
    _callContactBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_callContactBtn setTitleColor:SW_MAIN_BLUE_COLOR forState:UIControlStateNormal];
    _callContactBtn.titleLabel.font = SW_DEFAULT_FONT;
    [_callContactBtn setImage:[UIImage imageNamed:@"Phone"] forState:UIControlStateNormal];
    _callContactBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_callContactBtn addTarget:self action:@selector(defTelNumClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_callContactBtn];
    [_callContactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.rightMargin.equalTo(self.contentView.mas_right).offset(-0.5 * SW_MARGIN);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.equalTo(@100);
    }];
    
    //self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFBA57"];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
}

#pragma mark - SETTER/GETTER
- (void)setMarkItem:(SWMarketItem *)markItem {
    _markItem = markItem;
    NSString *titleName = [NSString stringWithFormat:@" %@", markItem.marketName];
    CGSize titleSize = [titleName sizeWithAttributes:@{NSFontAttributeName:self.marketNameBtn.titleLabel.font}];
    CGFloat fWidth = titleSize.width + 30; // 这button 图片的大小
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    fWidth = fWidth < screenWidth * 0.4?fWidth:screenWidth * 0.4;
    NSNumber *widthNum = [NSNumber numberWithFloat:fWidth];
    [self.marketNameBtn setTitle:titleName forState:UIControlStateNormal];
    [self.marketNameBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(widthNum);
    }];
    [self.callContactBtn setTitle:markItem.defaultContactName forState:UIControlStateNormal];
}

#pragma mark - UI response
- (void)marketBtnClicked:(UIButton *)button {
    if (self.actionBlock) {
        self.actionBlock(self.markItem);
    }
}

- (void)defTelNumClicked:(UIButton *)button {
    if (self.marketContactClickBlock) {
        self.marketContactClickBlock(self.markItem);
    }
}
@end
