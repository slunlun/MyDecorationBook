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
@property(nonatomic, strong) UILabel *telNumLabel;
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
    marketBtn.titleLabel.font = SW_DEFAULT_MIN_FONT;
    [marketBtn setTitleColor:[UIColor colorWithHexString:SW_BLACK_COLOR] forState:UIControlStateNormal];
    [marketBtn addTarget:self action:@selector(marketBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    marketBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    marketBtn.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0); // 调节button的title与他的image对齐到中心线
    self.marketNameBtn = marketBtn;
    [self.contentView addSubview:marketBtn];
    
    UIImageView *accessorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrow"]];
    UITapGestureRecognizer *imageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(marketBtnClicked:)];
    [accessorView addGestureRecognizer:imageViewTap];
    accessorView.userInteractionEnabled = YES;
    accessorView.contentMode = UIViewContentModeScaleAspectFit;
    self.accessImageView = accessorView;
    [self.contentView addSubview:accessorView];
    
    UILabel *defTelNumLab = [[UILabel alloc] initWithFrame:CGRectZero];
    [defTelNumLab setFont:SW_DEFAULT_MIN_FONT];
    [defTelNumLab setTextColor:SW_MAIN_BLUE_COLOR];
    UITapGestureRecognizer *telNumTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(defTelNumClicked:)];
    [defTelNumLab addGestureRecognizer:telNumTap];
    defTelNumLab.userInteractionEnabled = YES;
    self.telNumLabel = defTelNumLab;
    [self.contentView addSubview:defTelNumLab];
    
    [self.marketNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.contentView.mas_left).offset(SW_MARGIN);
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
        make.bottomMargin.equalTo(self.contentView.mas_bottom).offset(-SW_MARGIN);
    }];
    
    [self.accessImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN);
        make.bottomMargin.equalTo(self.contentView.mas_bottom).offset(-SW_MARGIN);
        make.left.equalTo(self.marketNameBtn.mas_right);
        make.width.equalTo(@20);
    }];
    
    [self.telNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.topMargin.equalTo(self.contentView.mas_top).offset(SW_MARGIN + 2);
        make.rightMargin.equalTo(self.contentView.mas_right).offset(-SW_MARGIN);
    }];
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
    NSString *defTelText = [NSString stringWithFormat:@"联系: %@", [markItem.defaultTelNum stringValue]];
    self.telNumLabel.text = defTelText;
}

#pragma mark - UI response
- (void)marketBtnClicked:(UIButton *)button {
    NSLog(@"marketBtn clicked");
    if (self.actionBlock) {
        self.actionBlock(self.markItem);
    }
}

- (void)defTelNumClicked:(UITapGestureRecognizer *)tapGesture {
    NSString *telNum = [NSString stringWithFormat:@"tel://%@", self.markItem.defaultTelNum.stringValue];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNum] options:@{} completionHandler:^(BOOL success) {
        NSLog(@"为你打call");
    }];
}
@end
