//
//  UITextView+OKToolBar.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/4/25.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "UITextField+OKToolBar.h"
#import "SWUIDef.h"

@implementation UITextField (OKToolBar)
- (void)addOKToolBar {
    self.inputAccessoryView = [self addToolbar];
}

- (UIToolbar *)addToolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), SW_KEYBOARD_ACCESSVIEW_HEIGHT)];
    toolbar.tintColor = [UIColor blueColor];
    toolbar.backgroundColor = SW_DISABLIE_THIN_WHITE;
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(textFieldDone)];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = SW_DEFAULT_FONT_LARGE;
    attrs[NSForegroundColorAttributeName] = SW_MAIN_BLUE_COLOR;
    [bar setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    toolbar.items = @[space, bar];
    return toolbar;
}

- (void)textFieldDone {
    [self resignFirstResponder];
}
@end
