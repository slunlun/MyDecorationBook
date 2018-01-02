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
#import "UIView+UIExt.h"

@interface SWDelItemView : UIView
@end

@implementation SWDelItemView

- (void)drawRect:(CGRect)rect {
    [self cornerRadian:self.frame.size.width / 2];
    UIBezierPath *linePath = [UIBezierPath bezierPathWithRect:CGRectMake(5, self.frame.size.height / 2 - 1.5, self.frame.size.width - 10 , 3)];
    [[UIColor whiteColor] setFill];
    [linePath fill];
}

@end

#define DEL_VIEW_TAG 123321
@interface SWDragMoveTableViewCell()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSArray *animationType;
@end
@implementation SWDragMoveTableViewCell
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *retView = [super hitTest:point withEvent:event];
    if ([retView isEqual:self]) {
        if (self.isEdit) {
            return retView;
        }else {
            return nil;
        }
    }
    return retView;
}

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
            // step1. 添加删除按钮
            UIView *delView = [[SWDelItemView alloc] init];
            delView.backgroundColor = [UIColor redColor];
            delView.frame = CGRectMake(self.frame.origin.x + self.frame.size.width - 5, 5, 0, 0);
            delView.tag = DEL_VIEW_TAG;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDragMoveTableViewCell:)];
            [delView addGestureRecognizer:tapGesture];
            [self addSubview:delView];
            [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                delView.frame = CGRectMake(self.frame.origin.x + self.frame.size.width - 25, 5, 20, 20);
            } completion:^(BOOL finished) {
                if (finished) {  // 添加抖动效果
                    [self startDelShake];
                }
            }];
        }else {
            UIView *delView = [self viewWithTag:DEL_VIEW_TAG];
            
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                delView.frame = CGRectMake(delView.frame.origin.x + 10, delView.frame.origin.y + 10, 0, 0);
                [self endDelShake];
            } completion:^(BOOL finished) {
                if (finished) {
                    [delView removeFromSuperview];
                }
            }];
        }
    }
}

#define kToRadian(A) (A/360.0 * (M_PI * 2))
- (void)startDelShake {
    CAKeyframeAnimation *keyframeAni = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    keyframeAni.duration = 0.3;
 

    keyframeAni.values = self.animationType;
    
    keyframeAni.repeatCount = MAXFLOAT;
    [self.layer addAnimation:keyframeAni forKey:@"DelShake"];
    
}

- (void)endDelShake {
    [self.layer removeAnimationForKey:@"DelShake"];
}

- (void)removeDragMoveTableViewCell : (UITapGestureRecognizer *)tapGesture {
    NSLog(@"Move");
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Init
- (instancetype)initWithTableViewCells:(NSArray *)tableViewCells {
    if (self = [super init]) {
        _tableViewCells = [[NSMutableArray alloc] initWithArray:tableViewCells];
        _contentScorllView = [[UIScrollView alloc] init];
        _contentScorllView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _contentScorllView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.view addSubview:_contentScorllView];
        [_contentScorllView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(40);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
    }
    return self;
}

- (void)commonInit {
    SWDragMoveTableViewCell *preCell = nil;
    NSArray *type1 = @[@(kToRadian(2)),@(kToRadian(0)),@(kToRadian(-2)),@(kToRadian(0)),@(kToRadian(2))];
    NSArray *type2 = @[@(kToRadian(0)),@(kToRadian(2)),@(kToRadian(0)),@(kToRadian(-2)),@(kToRadian(0))];
    NSArray *type3 = @[@(kToRadian(-2)),@(kToRadian(0)),@(kToRadian(2)),@(kToRadian(0)),@(kToRadian(-2))];
    NSArray *type4 = @[@(kToRadian(0)),@(kToRadian(-2)),@(kToRadian(0)),@(kToRadian(2)),@(kToRadian(0))];
    NSArray *animationTypes = @[type1, type2, type3, type4];
    NSInteger animationIndex = 0;
    for (SWDragMoveTableViewCell *cell in self.tableViewCells) {
        ++animationIndex;
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
            
            cell.animationType = animationTypes[animationIndex % 4];
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
            cell.animationType = animationTypes[animationIndex % 4];
            preCell = cell;
        }
    }
   self.contentScorllView.contentSize = CGSizeMake(SWDragMoveTableViewCellHeight, SWDragMoveTableViewCellHeight * self.tableViewCells.count);
   self.view.backgroundColor = [UIColor whiteColor];
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
            
            if (ABS(translateInY) < 1.5f ){
                return;
            }
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
