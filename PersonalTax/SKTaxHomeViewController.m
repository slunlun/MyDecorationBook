//
//  SKTaxHomeViewController.m
//  SKIncomeTaxCalculator
//
//  Created by Stepanoval (Xinxin) Huang on 2018/12/25.
//  Copyright © 2018 skyline. All rights reserved.
//

#import "SKTaxHomeViewController.h"
#import "Masonry.h"
#import "SKDef.h"
#import "SKTaxHomeTableViewCell.h"
#import "SKTaxPaymentItemDataModel.h"
#import "SKUniversalSingleSelectionPickerView.h"
#import "SKCityChooseViewController.h"
#import "SKAllResultViewController.h"
#import "SKTaxContext.h"
#import "SKSpecialAdditionalDeductionDetailVC.h"
#import "SKSettingPageViewController.h"

@import GoogleMobileAds;

@interface SKTaxHomeViewController ()<UITableViewDelegate,UITableViewDataSource,SKBasePickerViewDelegate,SKTaxHomeTableViewCellDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate, GADBannerViewDelegate>

@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UITextField *lastYearTextField;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *cityChooseButton;
@property (nonatomic,strong) UIButton *cityDisplayButton;
@property (nonatomic,strong) UIButton *taxCalculateButton;
@property (nonatomic,strong) NSArray *data;
@property (nonatomic,strong) UILabel *promptLabel;

@property(nonatomic, strong) GADBannerView *topBannerView;
@property(nonatomic, strong) GADBannerView *bottomBannerView;
@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation SKTaxHomeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _textField = [[UITextField alloc] init];
        _lastYearTextField = [[UITextField alloc] init];
        _data = [[NSArray alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个税计算器";
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickBackground:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    [self tableData];
    
    // 初始化广告
    // In this case, we instantiate the banner with desired ad size.
    self.bottomBannerView = [[GADBannerView alloc]
                             initWithAdSize:kGADAdSizeSmartBannerPortrait];
    self.bottomBannerView.adUnitID = GAD_BOTTOMBANNER_ID;
    self.bottomBannerView.rootViewController = self;
    self.bottomBannerView.delegate = self;
    [self.bottomBannerView loadRequest:[GADRequest request]];
    [self addBottomBannerViewToView:self.bottomBannerView];
    self.topBannerView = [[GADBannerView alloc]
                          initWithAdSize:kGADAdSizeSmartBannerPortrait];
    self.topBannerView.adUnitID = GAD_TOPBANNER_ID;
    self.topBannerView.rootViewController = self;
    self.topBannerView.delegate = self;
    [self.topBannerView loadRequest:[GADRequest request]];
    [self addTopBannerViewToView:self.topBannerView];
    
    [self commonInit];
  //  [self commonInitNavgationBar];
    
    // Do any additional setup after loading the view.
}

-(NSArray *)tableData
{
    if (self.data.count == 0) {
        NSMutableArray *dataModelArray = [[NSMutableArray alloc] init];
        
        SKTaxPaymentItemDataModel *model1 = [[SKTaxPaymentItemDataModel alloc] initWithTitle:@"专项附加扣除:" content:@"" placeholder:@"" isSelected:NO modelType:SKTaxModelTypeSpecialAdditionalDeduction];
        SKTaxPaymentItemDataModel *model2 = [[SKTaxPaymentItemDataModel alloc] initWithTitle:@"子女教育:" content:@"" placeholder:@"选择受教育子女" isSelected:NO modelType:SKTaxModelTypeChildEducation];
        SKTaxPaymentItemDataModel *model3 = [[SKTaxPaymentItemDataModel alloc] initWithTitle:@"继续教育:" content:@"" placeholder:@"选择继续教育情况" isSelected:NO modelType:SKTaxModelTypeContinuingEducation];
        SKTaxPaymentItemDataModel *model4 = [[SKTaxPaymentItemDataModel alloc] initWithTitle:@"住房情况:" content:@"" placeholder:@"选择住房/租房类型" isSelected:NO modelType:SKTaxModelTypeHousingSituation];
        SKTaxPaymentItemDataModel *model5 = [[SKTaxPaymentItemDataModel alloc] initWithTitle:@"赡养老人:" content:@"" placeholder:@"选择赡养老人情况" isSelected:NO modelType:SKTaxModelTypeSupportForTheElderly];
        
        [dataModelArray addObject:model1];
        [dataModelArray addObject:model2];
        [dataModelArray addObject:model3];
        [dataModelArray addObject:model4];
        [dataModelArray addObject:model5];
        
        self.data = [dataModelArray copy];
    }
    return self.data;
}

- (void)commonInit
{
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
   
    
    self.textField.placeholder = @"请输入税前月薪";
    self.textField.delegate = self;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [scrollView addSubview:_textField];
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.text = @"(*去年月薪用于三险一金计算，不填默认使用当年月薪)";
    promptLabel.textColor = [UIColor redColor];
    promptLabel.font = [UIFont systemFontOfSize:12];
    promptLabel.numberOfLines = 0;
    [scrollView addSubview:promptLabel];
    
    self.lastYearTextField.placeholder = @"请输入去年税前月薪";
    self.lastYearTextField.delegate = self;
    self.lastYearTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.lastYearTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [scrollView addSubview:_lastYearTextField];
    
    UIButton *cityButton = [[UIButton alloc] init];
    cityButton.backgroundColor = [UIColor clearColor];
    [cityButton setTitle:@"所在地区" forState:UIControlStateNormal];
    [cityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cityButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cityButton setImage:[UIImage imageNamed:@"accessoryIcon"] forState:UIControlStateNormal];
    cityButton.titleEdgeInsets = UIEdgeInsetsMake(0, - cityButton.imageView.bounds.size.width - 40.0, 0, cityButton.imageView.bounds.size.width);
    cityButton.imageEdgeInsets = UIEdgeInsetsMake(0, cityButton.imageView.bounds.size.width + 68.0, 0, 0);
    [cityButton addTarget:self action:@selector(cityChooseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.cityChooseButton = cityButton;
    [scrollView addSubview:cityButton];
    
    UIButton *cityDisplayButton = [[UIButton alloc] init];
    cityDisplayButton.backgroundColor = [UIColor clearColor];
    NSString *dispalyName = [SKTaxContext sharedInstance].currentSecurityStrategy.SS_TITLE;
    [cityDisplayButton addTarget:self action:@selector(cityDisplayButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    cityDisplayButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    [cityDisplayButton setTitle:dispalyName forState:UIControlStateNormal];
    [cityDisplayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cityDisplayButton.titleLabel.font = [UIFont systemFontOfSize:16];
    cityDisplayButton.titleLabel.textAlignment = NSTextAlignmentRight;
    cityDisplayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.cityDisplayButton = cityDisplayButton;
    [scrollView addSubview:cityDisplayButton];
    
    UIButton *calculateButton = [[UIButton alloc] init];
    calculateButton.layer.cornerRadius = 2.0;
    calculateButton.backgroundColor = [UIColor clearColor];
    [calculateButton setTitle:@"计算" forState:UIControlStateNormal];
    [calculateButton addTarget:self action:@selector(calculateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [calculateButton setBackgroundColor:[UIColor colorWithRed:57.0/255.0 green:150.0/255.0 blue:73.0/255.0 alpha:1.0]];
    calculateButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.taxCalculateButton = calculateButton;
    [scrollView addSubview:calculateButton];
    
    //init tableview
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.cellLayoutMarginsFollowReadableWidth = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 50;
    tableView.backgroundColor = [UIColor clearColor];
    
    
    [tableView registerClass:[SKTaxHomeTableViewCell class] forCellReuseIdentifier:@"TAX_HOME_TABLEVIEW_CELL"];
    tableView.allowsMultipleSelection = NO;
    //tableView.contentInset = UIEdgeInsetsMake(0, 0, kMargin * 4, 0);
    tableView.tableFooterView =[[UIView alloc]init];
    self.tableView = tableView;
    [scrollView addSubview:tableView];
    
    
    CGFloat textFieldWidth = self.view.frame.size.width - 20*2;
    //CGFloat topBannerViewHeight = self.topBannerView.frame.size.height;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.topBannerView.mas_bottom);
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(20);
        make.right.equalTo(scrollView.mas_right).offset(-20);
       // make.top.equalTo(self.scrollView.mas_bottom).offset(2 + topBannerViewHeight);
         make.top.equalTo(self.scrollView.mas_bottom).offset(2);
        make.width.equalTo(@(textFieldWidth));
        make.height.equalTo(@45);
    }];
    
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(scrollView).offset(20);
        make.right.equalTo(scrollView.mas_right).offset(-20);
        make.top.equalTo(self.textField.mas_bottom).offset(2);
        make.width.equalTo(@(textFieldWidth));
        make.height.equalTo(@30);
    }];
    
    [_lastYearTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(20);
        make.right.equalTo(scrollView.mas_right).offset(-20);
        make.top.equalTo(promptLabel.mas_bottom).offset(10);
        make.width.equalTo(@(textFieldWidth));
        make.height.equalTo(@45);
    }];
    
   // [_lastYearTextField setBackgroundColor:[UIColor orangeColor]];
    
    [_cityChooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(20);
        make.height.equalTo(@(35));
        make.width.equalTo(@(90));
        make.top.equalTo(self.lastYearTextField.mas_bottom).offset(8);
    }];
    
    //[_cityChooseButton setBackgroundColor:[UIColor cyanColor]];
    
    [_cityDisplayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(scrollView).offset(-20);
        make.height.equalTo(@(35));
        make.left.equalTo(self.cityChooseButton.mas_right).offset(10);
        make.top.equalTo(self.lastYearTextField.mas_bottom).offset(8);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lastYearTextField.mas_bottom).offset(64);
        make.left.equalTo(scrollView);
        make.right.equalTo(scrollView);
        make.height.equalTo(@(220));
        //make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];

    [calculateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(20);
        make.right.equalTo(scrollView).offset(-20);
        make.height.equalTo(@(45));
        make.top.equalTo(self.tableView.mas_bottom).offset(5);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-60);
    }];
    
    //    self.textField.backgroundColor = [UIColor orangeColor];
    //    self.cityChooseButton.backgroundColor = [UIColor greenColor];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.scrollView layoutIfNeeded];
    [self.view layoutIfNeeded];
    
    if (self.view.frame.size.height > 568) {
          //self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 0);
    }else{
          self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 50);
    }
}

#pragma mark - view positioning
- (void)addTopBannerViewToView:(UIView *)bannerView {
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bannerView];
    if (@available(ios 11.0, *)) {
        // In iOS 11, we need to constrain the view to the safe area.
        [self positionBannerViewFullWidthAtTopOfSafeArea:bannerView];
    } else {
        // In lower iOS versions, safe area is not available so we use
        // bottom layout guide and view edges.
        [self positionBannerViewFullWidthAtTopOfView:bannerView];
    }
}

- (void)positionBannerViewFullWidthAtTopOfSafeArea:(UIView *_Nonnull)bannerView {
    // Position the banner. Stick it to the bottom of the Safe Area.
    // Make it constrained to the edges of the safe area.
    UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
    
    [NSLayoutConstraint activateConstraints:@[
                                              [guide.leftAnchor constraintEqualToAnchor:bannerView.leftAnchor],
                                              [guide.rightAnchor constraintEqualToAnchor:bannerView.rightAnchor],
                                              [guide.topAnchor constraintEqualToAnchor:bannerView.topAnchor]
                                              ]];
}

- (void)positionBannerViewFullWidthAtTopOfView:(UIView *_Nonnull)bannerView {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bannerView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bannerView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bannerView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.topLayoutGuide
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:0]];
}

- (void)addBottomBannerViewToView:(UIView *)bannerView {
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bannerView];
    if (@available(ios 11.0, *)) {
        // In iOS 11, we need to constrain the view to the safe area.
        [self positionBannerViewFullWidthAtBottomOfSafeArea:bannerView];
    } else {
        // In lower iOS versions, safe area is not available so we use
        // bottom layout guide and view edges.
        [self positionBannerViewFullWidthAtBottomOfView:bannerView];
    }
}

- (void)positionBannerViewFullWidthAtBottomOfSafeArea:(UIView *_Nonnull)bannerView NS_AVAILABLE_IOS(11.0) {
    // Position the banner. Stick it to the bottom of the Safe Area.
    // Make it constrained to the edges of the safe area.
    UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
    
    [NSLayoutConstraint activateConstraints:@[
                                              [guide.leftAnchor constraintEqualToAnchor:bannerView.leftAnchor],
                                              [guide.rightAnchor constraintEqualToAnchor:bannerView.rightAnchor],
                                              [guide.bottomAnchor constraintEqualToAnchor:bannerView.bottomAnchor]
                                              ]];
}

- (void)positionBannerViewFullWidthAtBottomOfView:(UIView *_Nonnull)bannerView {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bannerView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bannerView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bannerView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.bottomLayoutGuide
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0]];
}


- (void)commonInitNavgationBar {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIBarButtonItem *setBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Settings.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClcik:)];
    setBarButton.accessibilityValue = @"HOME_PAGE_SET_BTN";
    self.navigationItem.leftBarButtonItems = @[setBarButton];
    // add rightButton just for titleView is center.
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    rightButton.enabled = NO;
    self.navigationItem.rightBarButtonItems = @[rightButton];
    
}

- (void)leftBarButtonItemClcik:(UIBarButtonItem *) sender {
    //TODO
    NSLog(@"left button clicked!");
//
//    SKSettingPageViewController *vc = [[SKSettingPageViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKTaxHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TAX_HOME_TABLEVIEW_CELL"];
    cell.delegate = self;
    if (!cell) {
        cell = [[SKTaxHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TAX_HOME_TABLEVIEW_CELL"];
    }
    
    SKTaxPaymentItemDataModel *model = self.data[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    SKTaxPaymentItemDataModel *model = self.data[indexPath.row];
    
    //pickView
    SKUniversalSingleSelectionPickerView *pickerView = [[SKUniversalSingleSelectionPickerView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight) delegate:self title:@"" leftBtnTitle:@"" rightBtnTitle:@"完成" dataModel:model];
    //    self.resultDict = pickerView.resultDict;
    pickerView.resultBlock = ^(SKTaxPaymentItemDataModel *newModel) {
        //        ws.resultDict = [[NSDictionary alloc] initWithDictionary:dict];
        switch (newModel.type) {
            case SKTaxModelTypeSpecialAdditionalDeduction:
                break;
            case SKTaxModelTypeChildEducation:
            {
                 [[SKTaxContext sharedInstance] updateChildDeduction:newModel.childStatus];
                model.childStatus = newModel.childStatus;
            }
            break;
            case SKTaxModelTypeHousingSituation:
            {
                [[SKTaxContext sharedInstance] updateHousingDeduction:newModel.houseStatus];
                model.houseStatus = newModel.houseStatus;
            }
                break;
            case SKTaxModelTypeContinuingEducation:
            {
                 [[SKTaxContext sharedInstance] updateAdultEducationDeduction:newModel.adultEduStatus];
                model.adultEduStatus = newModel.adultEduStatus;
            }
                break;
            case SKTaxModelTypeSupportForTheElderly:
            {
                  [[SKTaxContext sharedInstance] updateParentsSupportDeduction:newModel.parentsSupportStatus];
                model.parentsSupportStatus = newModel.parentsSupportStatus;
            }
                break;
            default:
                break;
        }
        SKTaxPaymentItemDataModel *specialModel = self.data[0];
        if ([SKTaxContext sharedInstance].specialDeductionCount >0) {
            NSString *specialModelContent = [NSString stringWithFormat:@"%.2lf",[SKTaxContext sharedInstance].specialDeductionCount];
            specialModel.content = specialModelContent;
        }else{
            specialModel.content = @"";
        }
        
        model.content = newModel.content;
        [self.tableView reloadData];
    };
    
    [pickerView show];
    
    NSLog(@"%@--------clicked",model.itemTitle);
}

#pragma -mark SKBasePickerViewDelegate
- (void)actionWithButton:(UIButton *)sender title:(nonnull NSString *)title {
    switch (sender.tag) {
        case 100:
        {
            //            [YMBlackSmallAlert showAlertWithMessage:sender.titleLabel.text time:2.0f];
        }
            break;
        case 101:
        {
            //            NSLog(@"self.resultDict-- == %@", self.resultDict);
            //            NSString *pickerViewTitle = self.resultDict[@"pickerViewTitle"];
            //            [YMBlackSmallAlert showAlertWithMessage:pickerViewTitle time:2.0f];
            //
            //            if (![title isEqualToString:@"时间选择"]) {
            //                [[YMObtainUserLocationManager shareManager] transferMapWithAddress:pickerViewTitle view:self.view];
            //            }
        }
            break;
        default:
            break;
    }
}

#pragma -mark SKTaxHomeTableViewCellDelegate
- (void)actionWithDeleteButton:(SKTaxHomeTableViewCell *)cell dataModel:(SKTaxPaymentItemDataModel *)model
{
    switch (model.type) {
        case SKTaxModelTypeSpecialAdditionalDeduction:
            break;
        case SKTaxModelTypeChildEducation:
        {
            [[SKTaxContext sharedInstance] updateChildDeduction:SKChildStatusNONE];
        }
            break;
        case SKTaxModelTypeHousingSituation:
        {
            [[SKTaxContext sharedInstance] updateHousingDeduction:SKHousingStatusNONE];
        }
            break;
        case SKTaxModelTypeContinuingEducation:
        {
            [[SKTaxContext sharedInstance] updateAdultEducationDeduction:SKAdultEducationStatusNONE];
        }
            break;
        case SKTaxModelTypeSupportForTheElderly:
        {
            [[SKTaxContext sharedInstance] updateParentsSupportDeduction:SKParentsSupportStatusNONE];
        }
            break;
        default:
            break;
    }
    
    SKTaxPaymentItemDataModel *specialModel = self.data[0];
    if ([SKTaxContext sharedInstance].specialDeductionCount >0) {
        NSString *specialModelContent = [NSString stringWithFormat:@"%.2lf",[SKTaxContext sharedInstance].specialDeductionCount];
        specialModel.content = specialModelContent;
    }else{
        specialModel.content = @"";
    }
    
    [self.tableView reloadData];
}

- (void)actionWithDetailButton:(SKTaxHomeTableViewCell *)cell dataModel:(SKTaxPaymentItemDataModel *)model;
{
    SKSpecialAdditionalDeductionDetailVC *detailInfoVC = [[SKSpecialAdditionalDeductionDetailVC alloc] initWithDataArray:self.data];
    [self.navigationController pushViewController:detailInfoVC animated:NO];
}

#pragma -mark button click event

- (void)cityChooseButtonClicked:(id)sender
{
    SKCityChooseViewController *vc = [[SKCityChooseViewController alloc] init];
    [vc setChooseCompletedBlock:^(NSString *cityName) {
        [self.cityDisplayButton setTitle:cityName forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)cityDisplayButtonClicked:(id)sender
{
    SKCityChooseViewController *vc = [[SKCityChooseViewController alloc] init];
    [vc setChooseCompletedBlock:^(NSString *cityName) {
        [self.cityDisplayButton setTitle:cityName forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)calculateButtonClicked:(id)sender
{
    [SKTaxContext sharedInstance].salary = [self.textField.text floatValue];
    if ([self.lastYearTextField.text floatValue] != 0) {
        [SKTaxContext sharedInstance].lastSalary = [self.lastYearTextField.text floatValue];
    }else {
        [SKTaxContext sharedInstance].lastSalary = [SKTaxContext sharedInstance].salary;
    }
    
    CGFloat salaryValue = [SKTaxContext sharedInstance].salary;
    CGFloat socialValue = [[SKTaxContext sharedInstance] calculatePersonalSocialSecurityAndHousingFund];
    NSArray *resultArray = [[SKTaxContext sharedInstance] calculatePersonalIncomeTax];
    NSMutableArray *dataArray = [NSMutableArray array];
    NSArray *taxInfoDataArray = resultArray;
    
    for (NSDictionary *dic in resultArray) {
        NSNumber *taxValue = dic[PERSONAL_TAX_COUNT];
        CGFloat incomeValue = salaryValue - socialValue - [taxValue floatValue];
        NSArray *detailArray = [NSArray arrayWithObjects:[self valueStringWith:salaryValue],[self valueStringWith:socialValue],[self valueStringWith:[taxValue floatValue]],[self valueStringWith:incomeValue], nil];
        [dataArray addObject:detailArray];
    }
    
    SKAllResultViewController *allResultVC = [[SKAllResultViewController alloc]init];
    allResultVC.dataArray = dataArray;
    allResultVC.taxInfoDataArray = taxInfoDataArray;
    [self.navigationController pushViewController:allResultVC animated:YES];
}

- (NSString *)valueStringWith:(CGFloat)floatValue {
    NSString *string = [NSString stringWithFormat:@"%.2f 元",floatValue];
    return string;
}
#pragma -mark UITextfield Delagate

// 限制只能输入数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

#pragma mark - OnClick Background Event
- (void)onClickBackground:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    if ([touch.view isKindOfClass:[UIScrollView class]]){
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - GADBannerViewDelegate
/// Tells the delegate an ad request loaded an ad.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    adView.alpha = 0;
    [UIView animateWithDuration:1.0 animations:^{
        adView.alpha = 1;
    }];
}

@end


