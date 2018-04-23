//
//  SWAddSubView.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/4/20.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWAddSubView.h"
#import "SWUIDef.h"
#import "Masonry.h"

@interface SWAddSubView()<UITextFieldDelegate>
@property(nonatomic, strong) UIButton *btnAdd;
@property(nonatomic, strong) UIButton *btnSub;
@property(nonatomic, strong) UITextField *txtFCount;
@end

@implementation SWAddSubView
- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}
#pragma mark - UI Init
- (void)commonInit {
    self.backgroundColor = [UIColor whiteColor];
  
    _btnSub = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnSub setImage:[UIImage imageNamed:@"Subtraction"] forState:UIControlStateNormal];
    [_btnSub addTarget:self action:@selector(subBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_btnSub setBackgroundColor:SW_DISABLIE_THIN_WHITE];
    _btnSub.userInteractionEnabled = NO;
    [self addSubview:_btnSub];
    [_btnSub mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self);
        make.width.equalTo(@25);
    }];
    
    _txtFCount = [[UITextField alloc] init];
    _txtFCount.textAlignment = NSTextAlignmentCenter;
    _txtFCount.keyboardType = UIKeyboardTypeNumberPad;
    _txtFCount.text = @"1";
    _txtFCount.font = SW_DEFAULT_MIN_FONT;
    _txtFCount.backgroundColor = SW_DISABLIE_WHITE;
    _txtFCount.delegate = self;
    [self addSubview:_txtFCount];
    [_txtFCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(_btnSub.mas_right).offset(1);
        make.width.equalTo(@40);
    }];
    
    _btnAdd = [[UIButton alloc] init];
    [_btnAdd setImage:[UIImage imageNamed:@"Add-Cross"] forState:UIControlStateNormal];
    [_btnAdd addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_btnAdd setBackgroundColor:SW_DISABLIE_WHITE];
    [self addSubview:_btnAdd];
    [_btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(_txtFCount.mas_right).offset(1);
        make.width.equalTo(@25);
    }];
    
    UILongPressGestureRecognizer* addLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addBtnLong:)];
    addLongPress.minimumPressDuration=0.8;//定义按的时间
    [_btnAdd addGestureRecognizer:addLongPress];
    
    UILongPressGestureRecognizer* subLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(subBtnLong:)];
    subLongPress.minimumPressDuration=0.8;//定义按的时间
    [_btnSub addGestureRecognizer:addLongPress];
    
    

    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        textField.text = @"0";
    }
    if (self.delegate) {
        [self.delegate SWAddSubView:self didUpdateCount:textField.text.integerValue];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.text isEqualToString:@"0"]) {
        textField.text = string;
        return NO;
    }
    
    return YES;
}

#pragma mark - UI Response
- (void)addBtnClicked:(UIButton *)addBtn {
    NSInteger count = self.txtFCount.text.integerValue;
    count++;
    self.btnSub.userInteractionEnabled = YES;
    self.btnSub.backgroundColor = SW_DISABLIE_WHITE;
    self.txtFCount.text = [NSString stringWithFormat:@"%ld",(long)count];
    if (self.delegate) {
        [self.delegate SWAddSubView:self didUpdateCount:count];
    }
}

- (void)subBtnLong:(UILongPressGestureRecognizer *)longPress {
    [self subBtnClicked:nil];
}

- (void)addBtnLong:(UILongPressGestureRecognizer *)longPress {
    [self addBtnClicked:nil];
}

- (void)subBtnClicked:(UIButton *)subBtn {
    NSInteger count = self.txtFCount.text.integerValue;
    count--;
    if (count < 0) {
        count = 0;
        self.btnSub.userInteractionEnabled = NO;
        self.btnSub.backgroundColor = SW_DISABLIE_THIN_WHITE;
    }
    self.txtFCount.text = [NSString stringWithFormat:@"%ld",(long)count];
    if (self.delegate) {
        [self.delegate SWAddSubView:self didUpdateCount:count];
    }
}
@end
