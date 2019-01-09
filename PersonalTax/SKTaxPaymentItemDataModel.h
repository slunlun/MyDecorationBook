//
//  SKTaxPaymentItemDataModel.h
//  SKIncomeTaxCalculator
//
//  Created by Stepanoval (Xinxin) Huang on 2018/12/26.
//  Copyright © 2018 skyline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKTaxContext.h"

typedef NS_ENUM(NSInteger, SKTaxModelType) {
    SKTaxModelTypeSpecialAdditionalDeduction = 1,
    SKTaxModelTypeChildEducation = 2,
    SKTaxModelTypeContinuingEducation = 3,
    SKTaxModelTypeHousingSituation = 4,
    SKTaxModelTypeSupportForTheElderly = 5,
};

NS_ASSUME_NONNULL_BEGIN

@interface SKTaxPaymentItemDataModel : NSObject<NSCopying>

@property (nonatomic,copy) NSString *itemTitle;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *placeholder;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,assign) SKTaxModelType type;

@property (nonatomic,assign) SKChildStatus childStatus;
@property (nonatomic,assign) SKAdultEducationStatus adultEduStatus;
@property (nonatomic,assign) SKHousingStatus houseStatus;
@property (nonatomic,assign) SKParentsSupportStatus parentsSupportStatus;

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content placeholder:(NSString *)placeholder isSelected:(BOOL)isSelected modelType:(SKTaxModelType)type;

@end

NS_ASSUME_NONNULL_END

