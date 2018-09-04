//
//  SWSystemConfigViewController.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/9/3.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SWSystemConfigViewControllerDelegate<NSObject>
- (void)dismissVC;
@end
@interface SWSystemConfigViewController : UIViewController
@property(nonatomic, weak) id<SWSystemConfigViewControllerDelegate>delegate;
@end
