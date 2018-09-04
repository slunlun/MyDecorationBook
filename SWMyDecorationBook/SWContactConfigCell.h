//
//  SWContactConfigCell.h
//  SWMyDecorationBook
//
//  Created by Eren on 2018/9/3.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^configChangedBlock)(BOOL state);
@interface SWContactConfigCell : UITableViewCell
- (void)updateSwitchState:(BOOL)state;
@property(nonatomic, copy) configChangedBlock stateChanged;
@end
