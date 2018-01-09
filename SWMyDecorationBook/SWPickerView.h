//
//  SWPickerView.h
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/8/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SWPickerView;
@protocol SWPickerViewDelegate<NSObject>
@required
- (NSInteger)SWPickerView:(SWPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
- (NSString *)SWPickerView:(SWPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

@optional
- (NSInteger)numberOfComponentsInSWPickerView:(SWPickerView *)pickerView ;
- (void)SWPickerView:(SWPickerView *)pickerView didClickOKForRow:(NSInteger)row forComponent:(NSInteger)component;
- (void)cancelSelectInSWPickerView:(SWPickerView *)pickerView;
- (nullable NSAttributedString *)SWPickerView:(SWPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component;
@end

@interface SWPickerView : UIView
@property(nonatomic, weak) id<SWPickerViewDelegate> delegate;

- (void)attachSWPickerViewInView:(UIView *)view;
- (void)showPickerView;
- (void)removePickerView;
@end
