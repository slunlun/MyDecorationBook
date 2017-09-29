//
//  SWDragMoveTableViewController.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/26/17.
//  Copyright © 2017 Eren. All rights reserved.
//
#import  <QuartzCore/QuartzCore.h>
#import "SWDragMoveTableViewController.h"
#import "Masonry.h"

@interface SWDelItemView : UIView
@end

@implementation SWDelItemView

- (void)drawRect:(CGRect)rect {
    
}

@end

@interface SWDragMoveTableViewCell()<UIGestureRecognizerDelegate>

@end
@implementation SWDragMoveTableViewCell
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if (self.isEdit) {
            return YES;
        }else {
            return NO;
        }
    }
    return YES;
}

- (NSString*)description {
    return self.title;
}

- (void)setEdit:(BOOL)edit {
    if (_edit != edit) {
        _edit = edit;
        
        if (_edit == YES) {
            [UIView animateWithDuration:1.8 delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
                 [self setNeedsDisplay];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

- (void)drawRect:(CGRect)rect {
    if (self.edit) {
        UIBezierPath* p = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.frame.origin.x + self.frame.size.width - 25,5,20,20)];
        [[UIColor redColor] setFill];
        [p fill];
        
        UIBezierPath *pLine = [UIBezierPath bezierPathWithRect:CGRectMake(self.frame.origin.x + self.frame.size.width - 30, 5, 15, 5)];
        [[UIColor whiteColor] setFill];
        [pLine fill];
        
    }else {
        
    }

}

- (void)startShake {

}

- (void)endShake {

}

@end

CGFloat const SWDragMoveTableViewCellHeight = 80.0f;
@interface SWDragMoveTableViewController ()
@property(nonatomic, strong) NSMutableArray *tableViewCells;
@property(nonatomic, strong) NSMutableArray *movedViewCells;
@property(nonatomic, strong) UIScrollView *contentScorllView;
@property(nonatomic, assign) CGPoint preTranslationPoint;
@property(nonatomic, assign) CGFloat preTranslateInY;
@property(nonatomic, assign) UIView *preTargetView;
@property(nonatomic, assign) CGRect startFrame;
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
        _contentScorllView.backgroundColor = [UIColor whiteColor];
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
            [self.contentScorllView addSubview:cell];
            [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.equalTo(self.contentScorllView);
                make.width.height.equalTo(@(SWDragMoveTableViewCellHeight));
            }];
            
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureCallBack:)];
            [cell addGestureRecognizer:longPress];
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureCallBack:)];
            [cell addGestureRecognizer:pan];
            
            preCell = cell;
        }else {
            [self.contentScorllView addSubview:cell];
            [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(preCell.mas_bottom);
                make.left.equalTo(preCell.mas_left);
                make.width.height.equalTo(@(SWDragMoveTableViewCellHeight));
            }];
    
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureCallBack:)];
            [cell addGestureRecognizer:longPress];
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureCallBack:)];
            [cell addGestureRecognizer:pan];
            
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
            NSAssert([panGesture.view isKindOfClass:[SWDragMoveTableViewCell class]], @"Only SWDragMoveTableViewCell can be draged");
            self.preTranslationPoint = CGPointZero;
            self.preTranslateInY = 0.0f;
            [self.contentScorllView bringSubviewToFront:panGesture.view];
            self.preTargetView = panGesture.view;
            self.movedViewCells = [NSMutableArray arrayWithArray:self.tableViewCells];
            self.startFrame = panGesture.view.frame;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            
            SWDragMoveTableViewCell *dragView = (SWDragMoveTableViewCell *)panGesture.view;
            CGPoint translationPoint = [panGesture translationInView:self.contentScorllView];
            CGFloat translateInY = translationPoint.y - self.preTranslationPoint.y;
            
            CGFloat moveY = [self dragView:dragView moveInYBytranslateY:translateInY];
            dragView.frame = CGRectMake(dragView.frame.origin.x, dragView.frame.origin.y + moveY, dragView.frame.size.width, dragView.frame.size.height);
            self.preTranslationPoint = translationPoint;
            
           // [self updateCellItemDataSource:(panGesture.view) translationInY:translateInY];
            self.preTranslateInY = translateInY;
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            [self updateCellItemDataSource:(panGesture.view) translationInY:self.preTranslateInY];
            [self updateLayoutDidMovedView:panGesture.view];
        }
            break;
            
        default:
            break;
    }
}

- (void)longPressGestureCallBack:(UILongPressGestureRecognizer *)longPressGesture {
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            for (SWDragMoveTableViewCell *cell in self.tableViewCells) {
                cell.edit = !cell.edit;
            }
            NSLog(@"OK, let's move");

        }
            break;
        default:
            break;
    }
}

#pragma mark - Help
- (CGFloat)dragView:(UIView *)view moveInYBytranslateY:(CGFloat)translationY {
    CGFloat currentY = view.frame.origin.y;
    CGFloat newLocationInY = currentY + translationY;
    if (newLocationInY < 0.0f || newLocationInY > SWDragMoveTableViewCellHeight * (self.tableViewCells.count - 1)) {
        return 0.0f;
    }
    
    return translationY;
}

- (void)updateCellItemDataSource:(UIView *)movedView translationInY:(CGFloat)translationInY{
    if ((self.preTranslateInY >= 0 && translationInY < 0) || (self.preTranslateInY <= 0 && translationInY > 0)) { // 这意味着用户改变了拖动的方向，我们需要重置data 数组来追踪用户的移动
        self.movedViewCells = [NSMutableArray arrayWithArray:self.tableViewCells];
        NSLog(@"Reset move cell %@", self.movedViewCells);
        
    }
    UIView *targetView = nil;
    for (NSInteger index = 0; index < self.movedViewCells.count; ++index) {
        if ([self.movedViewCells[index] isEqual:movedView]) {
            continue;
        }
        
        UIView *cell = self.movedViewCells[index];
        if ((translationInY < 0 && CGRectContainsPoint(cell.frame, movedView.frame.origin)) || (translationInY > 0 && CGRectContainsPoint(cell.frame, CGPointMake(movedView.frame.origin.x, movedView.frame.origin.y + movedView.frame.size.height)))) {
            targetView = cell;
        }
    }
    
    if (targetView && targetView != self.preTargetView) {
        NSInteger targetIndex = [self.movedViewCells indexOfObject:targetView];
        NSInteger movedViewIndex = [self.movedViewCells indexOfObject:movedView];
        if (targetIndex != movedViewIndex) {
            [self.movedViewCells removeObject:movedView];
            [self.movedViewCells insertObject:movedView atIndex:targetIndex];
            
            self.preTargetView = targetView;
            NSLog(@"Now the array is %@", self.movedViewCells);
        }
    }
    
}

- (void)updateLayoutDidMovedView:(UIView *)movedView {
    // update layout
    SWDragMoveTableViewCell *preCell = nil;
    NSLog(@"Will arange in order %@", self.movedViewCells);
    if([self.movedViewCells isEqualToArray:self.tableViewCells]) {
        [UIView animateWithDuration:0.5f delay:0.0f options:0 animations:^{
            movedView.frame = self.startFrame;
        } completion:^(BOOL finished) {
            if (finished) {
                self.tableViewCells = [NSMutableArray arrayWithArray:self.movedViewCells];
            }
        }];

    }else {
        for (SWDragMoveTableViewCell *cell in self.movedViewCells) {
            if (preCell == nil) {
                [cell mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.equalTo(self.contentScorllView);
                    make.width.height.equalTo(@(SWDragMoveTableViewCellHeight));
                }];
                
                preCell = cell;
            }else {
                
                [cell mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(preCell.mas_bottom);
                    make.left.equalTo(preCell.mas_left);
                    make.width.height.equalTo(@(SWDragMoveTableViewCellHeight));
                }];
                preCell = cell;
            }
        }
        
        [UIView animateWithDuration:0.5f delay:0.0f options:0 animations:^{
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded]; // here set layoutIfNeed to make animate change
            
            [self.view updateConstraints];
            [self.view updateConstraintsIfNeeded];
            
        } completion:^(BOOL finished) {
            if (finished) {
                self.tableViewCells = [NSMutableArray arrayWithArray:self.movedViewCells];
            }
        }];

    }
}

@end
