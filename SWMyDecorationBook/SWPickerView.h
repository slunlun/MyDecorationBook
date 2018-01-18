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
- (NSInteger)SWPickerView:(SWPickerView *_Nonnull)pickerView numberOfRowsInComponent:(NSInteger)component;
- (NSString *_Nonnull)SWPickerView:(SWPickerView *_Nonnull)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

@optional
- (NSInteger)numberOfComponentsInSWPickerView:(SWPickerView *_Nonnull)pickerView ;
- (void)SWPickerView:(SWPickerView *_Nonnull)pickerView didClickOKForRow:(NSInteger)row forComponent:(NSInteger)component;
- (void)cancelSelectInSWPickerView:(SWPickerView *_Nonnull)pickerView;
- (nullable NSAttributedString *)SWPickerView:(SWPickerView *_Nonnull)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component;
@end

@interface SWPickerView : UIView
@property(nonatomic, weak) id<SWPickerViewDelegate> _Nullable delegate;

- (void)attachSWPickerViewInView:(UIView *_Nonnull)view;
- (void)showPickerView;
- (void)removePickerView;
@end
