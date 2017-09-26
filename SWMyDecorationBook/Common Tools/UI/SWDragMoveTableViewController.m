//
//  SWDragMoveTableViewController.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/26/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import "SWDragMoveTableViewController.h"
#import "Masonry.h"

CGFloat const SWDragMoveTableViewCellHeight = 80.0f;

@interface SWDragMoveTableViewCell()<UIGestureRecognizerDelegate>

@end
@implementation SWDragMoveTableViewCell
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if (self.isActive) {
            return YES;
        }else {
            return NO;
        }
    }
    return YES;
}
@end

@interface SWDragMoveTableViewController ()
@property(nonatomic, strong) NSMutableArray *tableViewCells;
@property(nonatomic, strong) UIScrollView *contentScorllView;
@end

@implementation SWDragMoveTableViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init
- (instancetype)initWithTableViewCells:(NSArray *)tableViewCells {
    if (self = [super init]) {
        _tableViewCells = [[NSMutableArray alloc] initWithArray:tableViewCells];
        _contentScorllView = [[UIScrollView alloc] init];
        [self.view addSubview:_contentScorllView];
        [_contentScorllView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.view);
            make.width.height.equalTo(self.view);
        }];
    }
    return self;
}

- (void)commonInit {
    SWDragMoveTableViewCell *preCell = nil;
    for (SWDragMoveTableViewCell *cell in self.tableViewCells) {
        if (preCell == nil) {
            [self.view addSubview:cell];
            [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.equalTo(self.view);
                make.width.height.equalTo(@(SWDragMoveTableViewCellHeight));
            }];
            
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureCallBack:)];
            [cell addGestureRecognizer:longPress];
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureCallBack:)];
            [cell addGestureRecognizer:pan];
            
            preCell = cell;
        }else {
            [self.view addSubview:cell];
            [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(preCell.mas_bottom);
                make.left.equalTo(preCell.mas_left);
                make.width.height.equalTo(@(SWDragMoveTableViewCellHeight));
            }];
    
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureCallBack:)];
            [cell addGestureRecognizer:longPress];
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureCallBack:)];
            [cell addGestureRecognizer:pan];
            pan.enabled = NO;
            
            preCell = cell;
        }
    }
    self.contentScorllView.contentSize = CGSizeMake(SWDragMoveTableViewCellHeight, SWDragMoveTableViewCellHeight * self.tableViewCells.count);
}

#pragma mark - Getter/Setter
- (NSMutableArray *)tableViewCells
{
    if (_tableViewCells == nil) {
        _tableViewCells = [[NSMutableArray alloc] init];
    }
    return _tableViewCells;
}

#pragma mark - Operation about dragMoveCell
- (void)removeDragMoveTableViewCell:(SWDragMoveTableViewCell *)cell {

}

- (void)addDragMoveTableViewCell:(SWDragMoveTableViewCell *)cell {

}

#pragma mark - Gesture recognize
- (void)panGestureCallBack:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
        }
            break;
            
        default:
            break;
    }
}

- (void)longPressGestureCallBack:(UILongPressGestureRecognizer *)longPressGesture {
    for (SWDragMoveTableViewCell *cell in self.tableViewCells) {
        cell.active = YES;
        
    }
}

#pragma mark - Help


@end
