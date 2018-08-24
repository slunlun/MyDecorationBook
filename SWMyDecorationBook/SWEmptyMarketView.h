//
//  SWEmptyMarketView.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/8/24.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SWEmptyMarketViewDelegate <NSObject>
- (void)didClickedEmptyView;
@end
@interface SWEmptyMarketView : UIView
@property(nonatomic, weak) id<SWEmptyMarketViewDelegate> delegate;
@end
