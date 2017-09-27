//
//  SWDragMoveTableViewController.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/26/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWDragMoveTableViewCell : UIView
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) UIImage *image;
//@property(nonatomic, strong) UIColor *backgroundColor;

@property(nonatomic, assign, getter=isEdit) BOOL edit;

@end


@interface SWDragMoveTableViewController : UIViewController
- (instancetype)initWithTableViewCells:(NSArray *)tableViewCells;

- (void)removeDragMoveTableViewCell:(SWDragMoveTableViewCell *)cell;
- (void)addDragMoveTableViewCell:(SWDragMoveTableViewCell *)cell;
@end
