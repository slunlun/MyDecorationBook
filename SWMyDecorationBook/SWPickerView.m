//
//  SWPickerView.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/8/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWPickerView.h"
#import "SWUIDef.h"
#import "Masonry.h"
@interface SWPickerView()<UIPickerViewDelegate, UIPickerViewDataSource>
@property(nonatomic, strong) UIPickerView *pickerView;
@property(nonatomic, strong) UIButton *cancelBtn;
@property(nonatomic, strong) UIButton *okBtn;
@property(nonatomic, strong) UIView *coverView;

@property(nonatomic, assign) NSInteger curSelRow;
@property(nonatomic, assign) NSInteger curSelComponent;
@end

#define SW_PICKER_VIEW_HEIGHT 150
@implementation SWPickerView
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        _curSelRow = -1;
        _curSelComponent = -1;
        [self commonInit];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        _curSelRow = -1;
        _curSelComponent = -1;
        [self commonInit];
    }
    return self;
}

#pragma mark - Public interface
- (void)attachSWPickerViewInView:(UIView *)parentView {
    if (parentView) {
        [parentView addSubview:self];
        CGRect screenFrame = [UIScreen mainScreen].bounds;
        self.frame = CGRectMake(0, screenFrame.size.height + SW_PICKER_VIEW_HEIGHT, screenFrame.size.width, SW_PICKER_VIEW_HEIGHT);
    }
}

- (void)showPickerView {
    UIView *parentView = [self superview];
    if (parentView) {
        CGRect screenFrame = [UIScreen mainScreen].bounds;
         [self showCoverView];
        [UIView animateWithDuration:0.4 animations:^{
            self.frame = CGRectMake(0, parentView.frame.size.height - SW_PICKER_VIEW_HEIGHT, screenFrame.size.width, SW_PICKER_VIEW_HEIGHT);
        } completion:^(BOOL finished) {
            if (finished) {
                _curSelRow = 0;
            }
        }];
    }
}

- (void)removePickerView {
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    [self removeCoverView];
    [UIView animateWithDuration:0.6 animations:^{
        self.frame = CGRectMake(0, screenFrame.size.height + SW_PICKER_VIEW_HEIGHT, screenFrame.size.width, SW_PICKER_VIEW_HEIGHT);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - Common init
- (void)commonInit {
    self.backgroundColor = [UIColor whiteColor];
    
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_pickerView];
    
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    _cancelBtn.titleLabel.font = SW_DEFAULT_FONT;
    [_cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:SW_MAIN_BLUE_COLOR forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelBtn];
    
    _okBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    _okBtn.titleLabel.font = SW_DEFAULT_FONT;
    [_okBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [_okBtn setTitleColor:SW_MAIN_BLUE_COLOR forState:UIControlStateNormal];
    [_okBtn addTarget:self action:@selector(okBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_okBtn];
    
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top).offset(40);
    }];
    
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self).offset(15);
        make.width.equalTo(@60);
        make.height.equalTo(@20);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(15);
        make.width.equalTo(@60);
        make.height.equalTo(@20);
    }];
    
    self.coverView = [[UIView alloc] initWithFrame:CGRectZero];
    self.coverView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewTapped:)];
    [self.coverView addGestureRecognizer:tapGesture];
    
}

#pragma mark - Private
- (void)showCoverView {
    UIView *parentView = [self superview];
    [parentView addSubview:self.coverView];
    self.coverView.frame = parentView.frame;
    [parentView bringSubviewToFront:self];
}

- (void)removeCoverView {
    [self.coverView removeFromSuperview];
}

#pragma mark - UI Response
- (void)cancelBtnClicked:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(cancelSelectInSWPickerView:)]) {
        [self.delegate cancelSelectInSWPickerView:self];
    }
    [self removePickerView];
}

- (void)okBtnClicked:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(SWPickerView:didClickOKForRow:forComponent:)]) {
        [self.delegate SWPickerView:self didClickOKForRow:self.curSelRow forComponent:self.curSelComponent];
    }
    [self removePickerView];
}

- (void)backgroundViewTapped:(UITapGestureRecognizer *)tapGesture {
    [self removePickerView];
    if ([self.delegate respondsToSelector:@selector(cancelSelectInSWPickerView:)]) {
        [self.delegate cancelSelectInSWPickerView:self];
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if ([self.delegate respondsToSelector:@selector(numberOfComponentsInSWPickerView:)]) {
        return [self.delegate numberOfComponentsInSWPickerView:self];
    }else {
        return 1;
    }
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.delegate SWPickerView:self numberOfRowsInComponent:component];
}

#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.delegate SWPickerView:self titleForRow:row forComponent:component];
    
}

- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if([self.delegate respondsToSelector:@selector(SWPickerView:attributedTitleForRow:forComponent:)]) {
        return [self.delegate SWPickerView:self attributedTitleForRow:row forComponent:component];
    }else {
        return nil;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.curSelRow = row;
    self.curSelComponent = component;
}
@end
