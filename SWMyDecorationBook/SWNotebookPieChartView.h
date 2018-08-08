//
//  SWNotebookPieChartView.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/3.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SWNotebookPieChartView;
@protocol SWNotebookPieChartViewDelegate<NSObject>
- (void)SWNotebookPieChartView:(SWNotebookPieChartView *)pieCharView didSelectOrderCategory:(NSDictionary *)dict;
@end

@interface SWNotebookPieChartView : UIView
- (void)updateSummarizingData;
@property(nonatomic, weak) id<SWNotebookPieChartViewDelegate> delegate;
@end
