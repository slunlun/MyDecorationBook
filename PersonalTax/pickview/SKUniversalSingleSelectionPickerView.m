//
//  SKUniversalSingleSelectionPickerView.m
//  YMOCCodeStandard
//
//  Created by iOS on 2018/11/13.
//  Copyright © 2018 iOS. All rights reserved.
//

#import "SKUniversalSingleSelectionPickerView.h"


@interface SKUniversalSingleSelectionPickerView ()
<UIPickerViewDelegate, UIPickerViewDataSource>

/** pickerView */
@property (nonatomic, strong) UIPickerView *pickerView;
/** 数据源数组 */
@property (nonatomic, strong) NSMutableArray *dataMarr;

@property (nonatomic, strong) SKTaxPaymentItemDataModel *model;
@property (nonatomic, strong) SKTaxPaymentItemDataModel *fakeModel;

@end

@implementation SKUniversalSingleSelectionPickerView {
    /** 这一行是否选中 */
    BOOL _rowIsSelect;
}

#pragma mark - - 加载视图
- (void)loadSubviews {
    [super loadSubviews];
    
    [self.contentView addSubview:self.pickerView];
}

#pragma mark - - 配置视图
- (void)configProprty {
    [super configProprty];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
}

#pragma mark - - 布局视图
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.pickerView.frame = CGRectMake(0, kToolBarViewHeight, self.width, kContentViewHeight - kToolBarViewHeight);
}

#pragma mark - - delegate && dataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataMarr.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    for (UIView *lineView in pickerView.subviews) {
        if (lineView.height < 1) {
            lineView.backgroundColor = [UIColor colorWithRed:180.0/255.0 green:182.0/255.0 blue:187.0/255.0 alpha:1.0];
        }
    }
    
    NSString *textContent = self.dataMarr[row];
    UILabel *label = [[UILabel alloc] init];
    label.text = textContent;
//    if ([model.select isEqualToString:@"0"]) {
//        label.font = [UIFont systemFontOfSize:14];
//        label.textColor = [UIColor colorWithHexString:@"999999"];
//    } else {
        label.font = [UIFont systemFontOfSize:17];
        [UIColor colorWithRed:124.0/255.0 green:125.0/255.0 blue:128.0/255.0 alpha:1.0];
//    }
    label.textAlignment = NSTextAlignmentCenter;
    
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (row == 0) {
         [_pickerView selectRow:1 inComponent:0 animated:YES];
        NSString *textContent = self.dataMarr[row + 1];
        self.model.content = textContent;
        self.fakeModel.content = textContent;
    }else{
          [_pickerView selectRow:row inComponent:0 animated:YES];
          NSString *textContent = self.dataMarr[row];
          self.model.content = textContent;
        self.fakeModel.content = textContent;
    }
    
    NSInteger index = 0;
    if (row == 0) {
        index = row + 1;
    }else{
        index = row;
    }
    
    switch (self.model.type) {
         
        case SKTaxModelTypeSpecialAdditionalDeduction:
            break;
        case SKTaxModelTypeChildEducation:
        {
            self.fakeModel.childStatus = index;
        }
            break;
        case SKTaxModelTypeHousingSituation:
        {
            self.fakeModel.houseStatus = index;
        }
            break;
        case SKTaxModelTypeContinuingEducation:
        {
            self.fakeModel.adultEduStatus = index;
        }
            break;
        case SKTaxModelTypeSupportForTheElderly:
        {
            self.fakeModel.parentsSupportStatus = index;
        }
            break;
        default:
            break;
    }
    [self.pickerView reloadComponent:component];
}

//#pragma mark  按钮点击调用
- (void)buttonClickMethod {
    __weak typeof(&*self) ws = self;
  
    // 工具栏左侧按钮点击调用
    self.toolBarView.leftBtnClickBlock = ^(UIButton * _Nonnull sender) {
        [ws hide];
    };

    // 工具栏右侧按钮点击调用
    self.toolBarView.rightBtnClickBlcok = ^(UIButton * _Nonnull sender) {
        ws.model = ws.fakeModel;
        if (ws.resultBlock) {
            ws.resultBlock(ws.model);
        }
        [ws hide];
    };
}


#pragma mark - - 加载数据
- (void)loadData {
   
}

- (void)loadData:(SKTaxPaymentItemDataModel *)model
{
    [super loadData:model];
    self.model = model;
    self.fakeModel = [model copy];
    NSMutableArray *dataM = [[NSMutableArray alloc] init];
    
    switch (model.type) {
    case SKTaxModelTypeChildEducation:
        {
            NSArray *childEduListArray = [[NSArray alloc] initWithObjects:@"选择受教育子女数",@"1位",@"2位",@"3位", nil];
            dataM = [childEduListArray mutableCopy];
        }
        
        break;
            
    case SKTaxModelTypeContinuingEducation:
        {
              NSArray *continueEduListArr = [[NSArray alloc] initWithObjects:@"请选择继续教育情况",@"学历教育",@"职业资格教育", nil];
             dataM = [continueEduListArr mutableCopy];
        }
            
        break;
            
    case SKTaxModelTypeHousingSituation:
        {
             NSArray *housingSituationListArray = [[NSArray alloc] initWithObjects:@"选择住房/租房类型",@"首套房贷款",@"租房于省会/直辖市/计划单列市等大城市",@"租房于人口超过100万的城市",@"租房于人口未超过100万的城市", nil];
             dataM = [housingSituationListArray mutableCopy];
            
        }
        break;
            
    case SKTaxModelTypeSupportForTheElderly:
        {
             NSArray *supportForTheElderlyListArray = [[NSArray alloc] initWithObjects:@"选择赡养老人情况",@"我不是独生子女",@"我是独生子女", nil];
             dataM = [supportForTheElderlyListArray mutableCopy];
        }
            
        break;
    default:
        break;
    }
    _dataMarr = dataM;
    
    [self.pickerView reloadAllComponents];
     __block NSUInteger index = 0;
    if (model.content.length > 0) {
        [_dataMarr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:model.content]) {
                index = idx;
                *stop = YES;
            }
        }];
    }
    //NSInteger index =  [self.pickerView selectedRowInComponent:0];
    [self pickerView:self.pickerView didSelectRow:index inComponent:0];
}

#pragma mark - - lazyLoadUI
- (UIPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] init];
    }
    return _pickerView;
}

#pragma mark - - lazyLoadData
- (NSMutableArray *)dataMarr {
    if (_dataMarr == nil) {
        _dataMarr = [[NSMutableArray alloc] init];
    }
    return _dataMarr;
}

@end
