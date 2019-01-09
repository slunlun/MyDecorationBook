//
//  SKUniversalSingleSelectionPickerView.h
//  YMOCCodeStandard
//
//  Created by iOS on 2018/11/13.
//  Copyright © 2018 iOS. All rights reserved.
//

#import "SKBasePickerView.h"
#import "SKTaxPaymentItemDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SKUniversalSingleSelectionPickerView : SKBasePickerView

/** 结果字典 */
@property (nonatomic, strong) NSDictionary *resultDict;
/** block 存在时候回调 */
@property (nonatomic, copy) void(^resultBlock)(SKTaxPaymentItemDataModel *model);

@end

NS_ASSUME_NONNULL_END
