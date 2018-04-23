//
//  SWAddSubView.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/4/20.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SWAddSubView;

@protocol SWAddSubViewDelegate
- (void)SWAddSubView:(SWAddSubView *)addSubView didUpdateCount:(NSInteger)count;
@end

@interface SWAddSubView : UIView
@property(nonatomic, weak)id<SWAddSubViewDelegate> delegate;
@end
