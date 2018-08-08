//
//  SWNotebookBarChartView.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/3.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWNotebookBarChartView;
@protocol SWNotebookBarChartViewDelegate<NSObject>
- (void)SWNotebookBarChartView:(SWNotebookBarChartView *)barCharView didSelectOrderCategory:(NSDictionary *)dict;
@end

@interface SWNotebookBarChartView : UIView
- (instancetype)init;
- (void)updateData;

@property(nonatomic, weak) id<SWNotebookBarChartViewDelegate> delegate;
@end
