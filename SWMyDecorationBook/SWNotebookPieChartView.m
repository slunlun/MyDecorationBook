//
//  SWNotebookPieChartView.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/3.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWNotebookPieChartView.h"
#import "SWPieChat.h"
#import "SWSpeechBubble.h"
#import "Masonry.h"
#import "SWUIDef.h"
#import "SWShoppingOrderManager.h"
#import "HexColor.h"

@interface SWNotebookPieChartView()<SWPieChatDelegate>
@property(nonatomic, strong) SWPieChat *pieChart;
@property(nonatomic, strong) SWSpeechBubble *speechBubble;
@property(nonatomic, strong) NSArray *summarizingData;
@property(nonatomic, strong) NSArray *segColor;
@property(nonatomic, strong) SWPieChatSegment *currentSegmetn;
@end

@implementation SWNotebookPieChartView
#pragma mark - Init
- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}
#pragma mark - updateData
- (void)updateSummarizingData {
    _summarizingData = [[SWShoppingOrderManager sharedInstance] loadData];
    if (_summarizingData.count) {
        NSMutableArray *segArray = [[NSMutableArray alloc] init];
        NSInteger colorIndex = 0;
        for (NSDictionary *dict in _summarizingData) {
            SWShoppingOrderCategoryModle *modle = dict.allKeys.firstObject;
            colorIndex = colorIndex % _segColor.count;
            UIColor *segColor = _segColor[colorIndex];
            ++colorIndex;
            SWPieChatSegment *seg = [[SWPieChatSegment alloc] initWithValue:modle.totalCost title:modle.orderCategoryName color:segColor];
            seg.appendInfo = dict;
            [segArray addObject:seg];
        }
        [_pieChart updateProportions:segArray];
    }
}
#pragma mark - Common init
- (void)commonInit {
    // 一共支持18种颜色
    _segColor = @[[UIColor colorWithHexString:@"#e74c3c"],
                  [UIColor colorWithHexString:@"#3652C3"],
                  [UIColor colorWithHexString:@"#C336B5"],
                  [UIColor colorWithHexString:@"#2ecc71"],
                  [UIColor colorWithHexString:@"#6D7D44"],
                  [UIColor colorWithHexString:@"#ABEAE3"],
                  [UIColor colorWithHexString:@"#bdc3c7"],
                  [UIColor colorWithHexString:@"#B5DE51"],
                  [UIColor colorWithHexString:@"#DED651"],
                  [UIColor colorWithHexString:@"#D68E7D"],
                  [UIColor colorWithHexString:@"#3498db"],
                  [UIColor colorWithHexString:@"#9b59b6"],
                  [UIColor colorWithHexString:@"#E4BA80"],
                  [UIColor colorWithHexString:@"#E4B6C3"],
                  [UIColor colorWithHexString:@"#CDDBEC"],
                  [UIColor colorWithHexString:@"#3FDCEC"],
                  [UIColor colorWithHexString:@"#B9EC3F"],
                  [UIColor colorWithHexString:@"#E8B08D"]
                  ];
    
    // pie chart
    _pieChart = [[SWPieChat alloc] init];
    _pieChart.delegate = self;
    _pieChart.backgroundColor = [UIColor whiteColor];
    [self addSubview:_pieChart];
    [_pieChart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.topMargin.equalTo(self.mas_top).offset(SW_MARGIN);
        make.left.equalTo(self.mas_left).offset(SW_MARGIN);
        make.right.equalTo(self.mas_right).offset(-SW_MARGIN);
        make.height.equalTo(self.mas_width).offset(-SW_MARGIN);
    }];
    
    // speech bubble
    _speechBubble = [[SWSpeechBubble alloc] init];
    _speechBubble.backgroundColor = [UIColor whiteColor];
    [self addSubview:_speechBubble];
    [_speechBubble mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(1.5 * SW_MARGIN);
        make.right.equalTo(self.mas_right).offset(-1.5 * SW_MARGIN);
        make.top.equalTo(self.mas_bottom).offset(100);
        make.height.equalTo(@60);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(speechBubbleTapped:)];
    [_speechBubble addGestureRecognizer:tap];
}
#pragma mark - SWPieChatDelegate
- (void)pieChatDidShow:(SWPieChat *)pieChat defaultSegment:(SWPieChatSegment *)pieChatSegment {
    [_speechBubble mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(1.5 * SW_MARGIN);
        make.right.equalTo(self.mas_right).offset(-1.5 * SW_MARGIN);
        make.top.equalTo(self.pieChart.mas_bottom);
        make.height.equalTo(@60);
    }];
    
    NSString *title = [NSString stringWithFormat:@"%@ %.2f%%", pieChatSegment.segmentTitle, pieChatSegment.segmentRatio * 100];
    self.speechBubble.speechTitleLab.textColor = pieChatSegment.segmentColor;
    self.speechBubble.speechTitleLab.text = title;
    
    NSString *value = [NSString stringWithFormat:@"¥ %.2f", pieChatSegment.segmentValue];
    self.speechBubble.speechContentLab.textColor = pieChatSegment.segmentColor;
    self.speechBubble.speechContentLab.text = value;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }];
    
    self.currentSegmetn = pieChatSegment;
}

- (void)pieChat:(SWPieChat *)pieChat didSelectSegment:(SWPieChatSegment *)pieChatSegment {
    NSString *title = [NSString stringWithFormat:@"%@ %.2f%%", pieChatSegment.segmentTitle, pieChatSegment.segmentRatio * 100];
    self.speechBubble.speechTitleLab.textColor = pieChatSegment.segmentColor;
    self.speechBubble.speechTitleLab.text = title;
    
    NSString *value = [NSString stringWithFormat:@"¥ %.2f", pieChatSegment.segmentValue];
    self.speechBubble.speechContentLab.textColor = pieChatSegment.segmentColor;
    self.speechBubble.speechContentLab.text = value;
    
    self.currentSegmetn = pieChatSegment;
}

#pragma mark - UI Response
- (void)speechBubbleTapped:(UITapGestureRecognizer *)tapGesture {
    NSDictionary *orderInfoDict = self.currentSegmetn.appendInfo;
    if ([self.delegate respondsToSelector:@selector(SWNotebookPieChartView:didSelectOrderCategory:)]) {
        [self.delegate SWNotebookPieChartView:self didSelectOrderCategory:orderInfoDict];
    }
    
}
@end
