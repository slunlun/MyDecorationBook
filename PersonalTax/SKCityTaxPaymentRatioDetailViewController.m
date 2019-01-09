//
//  SKCityTaxPaymentRatioDetailViewController.m
//  SKIncomeTaxCalculator
//
//  Created by Stepanoval (Xinxin) Huang on 2018/12/28.
//  Copyright © 2018 skyline. All rights reserved.
//

#import "SKCityTaxPaymentRatioDetailViewController.h"
#import "Masonry.h"

typedef NS_ENUM(NSInteger, textFieldType) {
    textFieldTypePensionForPersonal = 1,
    textFieldTypePensionForComapny = 2,
    textFieldTypeMedicalForPersonal = 3,
    textFieldTypeMedicalForComapny = 4,
    textFieldTypeUnemployementForPersonal = 5,
    textFieldTypeUnemployementForCompany = 6,
    textFieldTypeHouseFundForPersonal = 7,
    textFieldTypeHouseFundForCompany = 8,
    textFieldTypTaxPayMAX = 9,
    textFieldTypTaxPaySocialSecurityMAX = 10,
};

@interface SKCityTaxPaymentRatioDetailViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong,nonnull) SKSocialSecurityStrategy *strategyModel;

@property (nonatomic,weak,readwrite) UIView *scrollView;

@property (nonatomic,weak,readwrite) UILabel *personalTitleLabel;
@property (nonatomic,weak,readwrite) UILabel *companyTitleLabel;

@property (nonatomic,weak,readwrite) UIImageView *horizontalLine;
@property (nonatomic,weak,readwrite) UIImageView *verticalLine;

@property (nonatomic,weak,readwrite) UILabel *pensionItemLabel;
@property (nonatomic,weak,readwrite) UILabel *medicalItemLabel;
@property (nonatomic,weak,readwrite) UILabel *unemploymentItemLabel;
@property (nonatomic,weak,readwrite) UILabel *housingFundItemLabel;

@property (nonatomic,weak,readwrite) UITextField *pensionForPersonalTextfield;
@property (nonatomic,weak,readwrite) UITextField *pensionForCompanyTextfield;

@property (nonatomic,weak,readwrite) UITextField *medicalForPersonalTextfield;
@property (nonatomic,weak,readwrite) UITextField *medicalForCompanyTextfield;

@property (nonatomic,weak,readwrite) UITextField *unemploymentForPersonalTextfield;
@property (nonatomic,weak,readwrite) UITextField *unemploymentForCompanyTextfield;

@property (nonatomic,weak,readwrite) UITextField *housingFundForPersonalTextfield;
@property (nonatomic,weak,readwrite) UITextField *housingFundForCompanyTextfield;

@property (nonatomic,weak,readwrite) UILabel *basePayMaxLabel;
@property (nonatomic,weak,readwrite) UITextField *basePayMaxTextField;

@property (nonatomic,weak,readwrite) UILabel *basePaysSocialSecurityMaxLabel;
@property (nonatomic,weak,readwrite) UITextField *basePaySocialSecurityMaxTextField;

@property (nonatomic,weak,readwrite) UIButton *saveDataButton;




@end

@implementation SKCityTaxPaymentRatioDetailViewController

-(instancetype)initWithStragetyModel:(SKSocialSecurityStrategy *)strategyModel
{
    self = [super init];
    if (self) {
        _strategyModel = strategyModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _strategyModel.SS_TITLE;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickBackground:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
    [self commonInitNavgationBar];
    [self commonInit];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
     [super viewWillAppear:animated];
    //注册键盘出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    //注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)commonInitNavgationBar {
   // self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClcik:)];
    [rightBarButton setTitle:@"保存"];
    rightBarButton.accessibilityValue = @"HOME_PAGE_SET_BTN";
    self.navigationItem.rightBarButtonItems = @[rightBarButton];
    // add rightButton just for titleView is center.
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    leftButton.enabled = NO;
//    self.navigationItem.leftBarButtonItems = @[leftButton];
    
}

- (void)commonInit{
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.contentSize = CGSizeMake(0, self.view.frame.size.height);
    scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView = scrollView;
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:scrollView];
    
    UIImageView *hozLine = [[UIImageView alloc] init];
    [hozLine setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
    self.horizontalLine = hozLine;
    [scrollView addSubview:hozLine];
    
    UIImageView *verticalLine = [[UIImageView alloc] init];
    [verticalLine setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
    self.verticalLine = verticalLine;
    [scrollView addSubview:verticalLine];
    
    UILabel *personalTitleLabel = [[UILabel alloc] init];
    personalTitleLabel.text = @"个人";
    personalTitleLabel.font = [UIFont systemFontOfSize:18];
    self.personalTitleLabel = personalTitleLabel;
  //  personalTitleLabel.backgroundColor = [UIColor redColor];
    [scrollView addSubview:personalTitleLabel];
    
    UILabel *companyTitleLabel = [[UILabel alloc] init];
    self.companyTitleLabel = companyTitleLabel;
   // companyTitleLabel.backgroundColor = [UIColor redColor];
    companyTitleLabel.text = @"单位";
    [scrollView addSubview:companyTitleLabel];
    
    UILabel *pensionItemLabel = [[UILabel alloc] init];
    pensionItemLabel.text = @"养老";
   // pensionItemLabel.backgroundColor = [UIColor redColor];
    self.pensionItemLabel = pensionItemLabel;
    [scrollView addSubview:pensionItemLabel];
    
    UILabel *medicalItemLabel = [[UILabel alloc] init];
    medicalItemLabel.text = @"医疗";
    self.medicalItemLabel = medicalItemLabel;
    [scrollView addSubview:medicalItemLabel];
    
    UILabel *unemploymentItemLabel = [[UILabel alloc] init];
    unemploymentItemLabel.text = @"失业";
    self.unemploymentItemLabel = unemploymentItemLabel;
    [scrollView addSubview:unemploymentItemLabel];
    
    UILabel *houseFoundItemLabel = [[UILabel alloc] init];
    houseFoundItemLabel.text = @"公积金";
    self.housingFundItemLabel = houseFoundItemLabel;
    [scrollView addSubview:houseFoundItemLabel];
    
    UILabel *basePayItemLabel = [[UILabel alloc] init];
    basePayItemLabel.text = @"公积金缴费基数封顶数";
    self.basePayMaxLabel = basePayItemLabel;
    [scrollView addSubview:basePayItemLabel];
    
    UILabel *basePaysSocialSecurityMaxLabel = [[UILabel alloc] init];
    basePaysSocialSecurityMaxLabel.text = @"社保缴费基数封顶数";
    self.basePaysSocialSecurityMaxLabel = basePaysSocialSecurityMaxLabel;
    [scrollView addSubview:basePaysSocialSecurityMaxLabel];
    
    UITextField *pensionForPersonalTextField = [[UITextField alloc] init];
    pensionForPersonalTextField.delegate = self;
    pensionForPersonalTextField.text = [NSString stringWithFormat:@"%.2lf",(_strategyModel.P_ED.floatValue * 100)];
    pensionForPersonalTextField.tag = textFieldTypePensionForPersonal;
    pensionForPersonalTextField.borderStyle = UITextBorderStyleRoundedRect;
    pensionForPersonalTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.pensionForPersonalTextfield = pensionForPersonalTextField;
    //pensionForPersonalTextField.backgroundColor = [UIColor orangeColor];
    [scrollView addSubview:pensionForPersonalTextField];
    
    UITextField *pensionForCompanyTextfield = [[UITextField alloc] init];
    pensionForCompanyTextfield.text = [NSString stringWithFormat:@"%.2lf",(_strategyModel.C_ED.stringValue.floatValue * 100)];
    pensionForCompanyTextfield.tag = textFieldTypePensionForComapny;
      pensionForCompanyTextfield.delegate = self;
    pensionForCompanyTextfield.borderStyle = UITextBorderStyleRoundedRect;
    pensionForCompanyTextfield.keyboardType = UIKeyboardTypeNumberPad;
    self.pensionForCompanyTextfield = pensionForCompanyTextfield;
    //pensionForCompanyTextfield.backgroundColor = [UIColor yellowColor];
    [scrollView addSubview:pensionForCompanyTextfield];
    
    UITextField *medicalForPersonalTextfield = [[UITextField alloc] init];
    medicalForPersonalTextfield.text = [NSString stringWithFormat:@"%.2lf",(_strategyModel.P_MD.floatValue * 100)];
    medicalForPersonalTextfield.tag = textFieldTypeMedicalForPersonal;
     medicalForPersonalTextfield.delegate = self;
    medicalForPersonalTextfield.keyboardType = UIKeyboardTypeNumberPad;
    medicalForPersonalTextfield.borderStyle = UITextBorderStyleRoundedRect;
    self.medicalForPersonalTextfield = medicalForPersonalTextfield;
   // medicalForPersonalTextfield.backgroundColor = [UIColor orangeColor];
    [scrollView addSubview:medicalForPersonalTextfield];
    
    UITextField *medicalForCompanyTextfield = [[UITextField alloc] init];
    medicalForCompanyTextfield.text = [NSString stringWithFormat:@"%.2lf",(_strategyModel.C_MD.floatValue * 100)];
    medicalForCompanyTextfield.tag = textFieldTypeMedicalForComapny;
      medicalForCompanyTextfield.delegate = self;
    medicalForCompanyTextfield.borderStyle = UITextBorderStyleRoundedRect;
    medicalForCompanyTextfield.keyboardType = UIKeyboardTypeNumberPad;
   // medicalForCompanyTextfield.backgroundColor = [UIColor yellowColor];
    self.medicalForCompanyTextfield = medicalForCompanyTextfield;
    [scrollView addSubview:medicalForCompanyTextfield];
    
    UITextField *unemploymentForPersonalTextfield = [[UITextField alloc] init];
    unemploymentForPersonalTextfield.text = [NSString stringWithFormat:@"%.2lf",(_strategyModel.P_UE.floatValue * 100)];
    unemploymentForPersonalTextfield.tag = textFieldTypeUnemployementForPersonal;
    unemploymentForPersonalTextfield.delegate = self;
    unemploymentForPersonalTextfield.borderStyle = UITextBorderStyleRoundedRect;
    unemploymentForPersonalTextfield.keyboardType = UIKeyboardTypeNumberPad;
   // unemploymentForPersonalTextfield.backgroundColor = [UIColor orangeColor];
    self.unemploymentForPersonalTextfield = unemploymentForPersonalTextfield;
    [scrollView addSubview:unemploymentForPersonalTextfield];
    
    UITextField *unemploymentForCompanyTextfield = [[UITextField alloc] init];
    unemploymentForCompanyTextfield.text = [NSString stringWithFormat:@"%.2lf",(_strategyModel.C_UE.floatValue * 100)];
    unemploymentForCompanyTextfield.tag = textFieldTypeUnemployementForCompany;
    unemploymentForCompanyTextfield.delegate = self;
    unemploymentForCompanyTextfield.borderStyle = UITextBorderStyleRoundedRect;
    unemploymentForCompanyTextfield.keyboardType = UIKeyboardTypeNumberPad;
   // unemploymentForCompanyTextfield.backgroundColor = [UIColor yellowColor];
    self.unemploymentForCompanyTextfield = unemploymentForCompanyTextfield;
    [scrollView addSubview:unemploymentForCompanyTextfield];
    
    UITextField *housingFundForPersonalTextfield = [[UITextField alloc] init];
    housingFundForPersonalTextfield.text = [NSString stringWithFormat:@"%.2lf",(_strategyModel.P_HF.floatValue * 100)];
    housingFundForPersonalTextfield.tag = textFieldTypeHouseFundForPersonal;
    housingFundForPersonalTextfield.delegate = self;
    housingFundForPersonalTextfield.keyboardType = UIKeyboardTypeNumberPad;
    housingFundForPersonalTextfield.borderStyle = UITextBorderStyleRoundedRect;
    //housingFundForPersonalTextfield.backgroundColor = [UIColor orangeColor];
    self.housingFundForPersonalTextfield = housingFundForPersonalTextfield;
    [scrollView addSubview:housingFundForPersonalTextfield];
    
    UITextField *housingFundForCompanyTextfield = [[UITextField alloc] init];
    housingFundForCompanyTextfield.text =  [NSString stringWithFormat:@"%.2lf",(_strategyModel.C_HF.floatValue * 100)];
    housingFundForCompanyTextfield.tag = textFieldTypeHouseFundForCompany;
    housingFundForCompanyTextfield.delegate = self;
    housingFundForCompanyTextfield.keyboardType = UIKeyboardTypeNumberPad;
      housingFundForCompanyTextfield.borderStyle = UITextBorderStyleRoundedRect;
   // housingFundForCompanyTextfield.backgroundColor = [UIColor yellowColor];
    self.housingFundForCompanyTextfield = housingFundForCompanyTextfield;
    [scrollView addSubview:housingFundForCompanyTextfield];
    
    UITextField *basePayMaxTextField = [[UITextField alloc] init];
       basePayMaxTextField.text =  [NSString stringWithFormat:@"%.2lf",( _strategyModel.MAX_PF_BASELINE.floatValue )];
    basePayMaxTextField.tag = textFieldTypTaxPayMAX;
    basePayMaxTextField.delegate = self;
    basePayMaxTextField.keyboardType = UIKeyboardTypeNumberPad;
    basePayMaxTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.basePayMaxTextField = basePayMaxTextField;
    [scrollView addSubview:basePayMaxTextField];
    
    UITextField *basePaySocialSecurityMaxTextField = [[UITextField alloc] init];
    basePaySocialSecurityMaxTextField.text =  [NSString stringWithFormat:@"%.2lf",(_strategyModel.MAX_SS_BASELINE.floatValue)];
    basePaySocialSecurityMaxTextField.tag = textFieldTypTaxPaySocialSecurityMAX;
    basePaySocialSecurityMaxTextField.delegate = self;
    basePaySocialSecurityMaxTextField.keyboardType = UIKeyboardTypeNumberPad;
    basePaySocialSecurityMaxTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.basePaySocialSecurityMaxTextField = basePaySocialSecurityMaxTextField;
    [scrollView addSubview:basePaySocialSecurityMaxTextField];
    
//    UIButton *saveButton = [[UIButton alloc] init];
//    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
//    [saveButton addTarget:self action:@selector(onTapSaveButton:) forControlEvents:UIControlEventTouchUpInside];
//    [saveButton setBackgroundColor:[UIColor colorWithRed:252.0/255.0 green:83.0/255.0 blue:84.0/255.0 alpha:1.0]];
//    self.saveDataButton = saveButton;
//    [self.view addSubview:saveButton];
    
    UILabel *percentageLabel1 = [[UILabel alloc] init];
    percentageLabel1.text = @"%";
    [scrollView addSubview:percentageLabel1];
    
    UILabel *percentageLabel2 = [[UILabel alloc] init];
    percentageLabel2.text = @"%";
    [scrollView addSubview:percentageLabel2];
    
    UILabel *percentageLabel3 = [[UILabel alloc] init];
    percentageLabel3.text = @"%";
    [scrollView addSubview:percentageLabel3];
    
    UILabel *percentageLabel4 = [[UILabel alloc] init];
    percentageLabel4.text = @"%";
    [scrollView addSubview:percentageLabel4];
    
    UILabel *percentageLabel5 = [[UILabel alloc] init];
    percentageLabel5.text = @"%";
    [scrollView addSubview:percentageLabel5];
    
    UILabel *percentageLabel6 = [[UILabel alloc] init];
    percentageLabel6.text = @"%";
    [scrollView addSubview:percentageLabel6];
    
    UILabel *percentageLabel7 = [[UILabel alloc] init];
    percentageLabel7.text = @"%";
    [scrollView addSubview:percentageLabel7];
    
    UILabel *percentageLabel8 = [[UILabel alloc] init];
    percentageLabel8.text = @"%";
    [scrollView addSubview:percentageLabel8];
    
    
//    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@(120));
//        make.height.equalTo(@(45));
//        make.left.equalTo(scrollView).offset(20);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
//    }];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_topLayoutGuideBottom);
//        make.left.equalTo(self.view);
//        make.right.equalTo(self.view.mas_right);
//        make.bottom.equalTo(self.saveDataButton.mas_top).offset(-20);
          make.edges.equalTo(self.view);
    }];
    
    [hozLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(scrollView);
        make.height.equalTo(@(2));
        make.top.equalTo(scrollView).offset(40);
    }];
    
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(568));
        make.width.equalTo(@(2));
        make.top.equalTo(scrollView).offset(5);
        make.left.equalTo(self.view.mas_centerX).offset(40);
    }];
    
    [personalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(40));
        make.height.equalTo(@(30));
        make.right.equalTo(verticalLine).offset(-45);
        make.bottom.equalTo(hozLine).offset(-5);
    }];
    
    [companyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(40));
        make.height.equalTo(@(30));
        make.left.equalTo(verticalLine).offset(40);
        make.bottom.equalTo(hozLine).offset(-5);
    }];
    
    [pensionItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(20);
        make.top.equalTo(hozLine).offset(20);
        make.width.equalTo(@(60));
        make.height.equalTo(@(40));
    }];
    
    [medicalItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(20);
        make.top.equalTo(pensionItemLabel.mas_bottom).offset(30);
        make.width.equalTo(@(60));
        make.height.equalTo(@(40));
    }];
    
    [unemploymentItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(20);
        make.top.equalTo(medicalItemLabel.mas_bottom).offset(30);
        make.width.equalTo(@(60));
        make.height.equalTo(@(40));
    }];
    
    [houseFoundItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(20);
        make.top.equalTo(unemploymentItemLabel.mas_bottom).offset(30);
        make.width.equalTo(@(60));
        make.height.equalTo(@(40));
    }];
    
    
    
    [pensionForPersonalTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(pensionItemLabel.mas_right).offset(30);
        make.width.equalTo(@(60));
        make.right.equalTo(verticalLine.mas_left).offset(-40);
        make.height.equalTo(@(50));
        make.top.equalTo(hozLine.mas_bottom).offset(10);
    }];
    
    [medicalForPersonalTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(medicalItemLabel.mas_right).offset(30);
           make.width.equalTo(@(60));
        make.right.equalTo(verticalLine.mas_left).offset(-40);
        make.height.equalTo(@(50));
        make.top.equalTo(pensionForPersonalTextField.mas_bottom).offset(20);
    }];
    
    [unemploymentForPersonalTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(unemploymentItemLabel.mas_right).offset(30);
           make.width.equalTo(@(60));
        make.right.equalTo(verticalLine.mas_left).offset(-40);
        make.height.equalTo(@(50));
        make.top.equalTo(medicalForPersonalTextfield.mas_bottom).offset(20);
    }];
    
    [housingFundForPersonalTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(houseFoundItemLabel.mas_right).offset(30);
        make.width.equalTo(@(60));
        make.right.equalTo(verticalLine.mas_left).offset(-40);
        make.height.equalTo(@(50));
        make.top.equalTo(unemploymentForPersonalTextfield.mas_bottom).offset(20);
    }];
    
    
    
    [pensionForCompanyTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalLine.mas_right).offset(25);
        make.top.equalTo(hozLine.mas_bottom).offset(10);
        make.height.equalTo(@(50));
        make.width.equalTo(@(60));
    }];
    
    [medicalForCompanyTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalLine.mas_right).offset(25);
        make.top.equalTo(pensionForCompanyTextfield.mas_bottom).offset(20);
        make.height.equalTo(@(50));
        make.width.equalTo(@(60));
    }];
    
    [unemploymentForCompanyTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalLine.mas_right).offset(25);
        make.top.equalTo(medicalForCompanyTextfield.mas_bottom).offset(20);
        make.height.equalTo(@(50));
        make.width.equalTo(@(60));
    }];
    
    [housingFundForCompanyTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalLine.mas_right).offset(25);
        make.top.equalTo(unemploymentForCompanyTextfield.mas_bottom).offset(20);
        make.height.equalTo(@(50));
        make.width.equalTo(@(60));
    }];
    
    [percentageLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(15));
        make.height.equalTo(@(50));
        make.left.equalTo(pensionForPersonalTextField.mas_right).offset(5);
        make.top.equalTo(hozLine.mas_bottom).offset(10);
    }];
    
    [percentageLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(15));
        make.height.equalTo(@(50));
        make.left.equalTo(medicalForPersonalTextfield.mas_right).offset(5);
        make.top.equalTo(percentageLabel1.mas_bottom).offset(20);
    }];
    
    [percentageLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(15));
        make.height.equalTo(@(50));
        make.left.equalTo(unemploymentForPersonalTextfield.mas_right).offset(5);
        make.top.equalTo(percentageLabel2.mas_bottom).offset(20);
    }];
    
    [percentageLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(15));
        make.height.equalTo(@(50));
        make.left.equalTo(housingFundForPersonalTextfield.mas_right).offset(5);
        make.top.equalTo(percentageLabel3.mas_bottom).offset(20);
    }];
    
    [percentageLabel5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(15));
        make.height.equalTo(@(50));
        make.left.equalTo(pensionForCompanyTextfield.mas_right).offset(5);
        make.top.equalTo(hozLine.mas_bottom).offset(10);
    }];
    
    [percentageLabel6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(15));
        make.height.equalTo(@(50));
        make.left.equalTo(medicalForCompanyTextfield.mas_right).offset(5);
        make.top.equalTo(percentageLabel5.mas_bottom).offset(20);
    }];
    
    [percentageLabel7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(15));
        make.height.equalTo(@(50));
        make.left.equalTo(unemploymentForCompanyTextfield.mas_right).offset(5);
        make.top.equalTo(percentageLabel6.mas_bottom).offset(20);
    }];
    
    [percentageLabel8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(15));
        make.height.equalTo(@(50));
        make.left.equalTo(housingFundForCompanyTextfield.mas_right).offset(5);
        make.top.equalTo(percentageLabel7.mas_bottom).offset(20);
    }];
    
    /////////
    [basePayItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(20);
        make.top.equalTo(houseFoundItemLabel.mas_bottom).offset(20);
        make.width.equalTo(@(180));
        make.height.equalTo(@(40));
    }];
    
    [basePayMaxTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(20);
        make.top.equalTo(basePayItemLabel.mas_bottom).offset(20);
        make.width.equalTo(@(120));
        make.height.equalTo(@(50));
    }];
    
    [basePaysSocialSecurityMaxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(20);
        make.top.equalTo(basePayMaxTextField.mas_bottom).offset(20);
        make.width.equalTo(@(180));
        make.height.equalTo(@(40));
    }];
    
    [basePaySocialSecurityMaxTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(20);
        make.top.equalTo(basePaysSocialSecurityMaxLabel.mas_bottom).offset(20);
        make.width.equalTo(@(120));
        make.height.equalTo(@(50));
    }];
}

#pragma -mark tap event
-(void)onTapSaveButton:(id)sender
{
    if (self.pensionForPersonalTextfield.text.length > 0) {
        float value = self.pensionForPersonalTextfield.text.floatValue/100.0;
        _strategyModel.P_ED = [NSNumber numberWithFloat:value];
    }else{
        _strategyModel.P_ED = [NSNumber numberWithFloat:0.0];
    }
    
    if (self.pensionForCompanyTextfield.text.length > 0) {
        float value = self.pensionForPersonalTextfield.text.floatValue/100.0;
        _strategyModel.C_ED = [NSNumber numberWithFloat:value];
    }else{
        _strategyModel.C_ED = [NSNumber numberWithFloat:0.0];
    }
    
    if (self.medicalForPersonalTextfield.text.length > 0) {
        float value = self.medicalForPersonalTextfield.text.floatValue/100.0;
        _strategyModel.P_MD = [NSNumber numberWithFloat:value];
    }else{
        _strategyModel.P_MD = [NSNumber numberWithFloat:0.0];
    }
    
    if (self.medicalForCompanyTextfield.text.length > 0) {
        float value = self.medicalForCompanyTextfield.text.floatValue/100.0;
        _strategyModel.C_MD = [NSNumber numberWithFloat:value];
    }else{
        _strategyModel.C_MD = [NSNumber numberWithFloat:0.0];
    }
    
    if (self.unemploymentForPersonalTextfield.text.length > 0) {
        float value = self.unemploymentForPersonalTextfield.text.floatValue/100.0;
        _strategyModel.P_UE = [NSNumber numberWithFloat:value];
    }else{
        _strategyModel.P_UE = [NSNumber numberWithFloat:0.0];
    }
    
    if (self.unemploymentForCompanyTextfield.text.length > 0) {
        float value = self.unemploymentForCompanyTextfield.text.floatValue/100.0;
        _strategyModel.C_UE = [NSNumber numberWithFloat:value];
    }else{
        _strategyModel.C_UE = [NSNumber numberWithFloat:0.0];
    }
    
    if (self.housingFundForPersonalTextfield.text.length > 0) {
        float value = self.housingFundForPersonalTextfield.text.floatValue/100.0;
        _strategyModel.P_HF = [NSNumber numberWithFloat:value];
    }else{
        _strategyModel.P_HF = [NSNumber numberWithFloat:0.0];
    }
    
    if (self.housingFundForCompanyTextfield.text.length > 0) {
        float value = self.housingFundForPersonalTextfield.text.floatValue/100.0;
        _strategyModel.C_HF = [NSNumber numberWithFloat:value];
    }else{
        _strategyModel.C_HF = [NSNumber numberWithFloat:0.0];
    }
    
    if (self.basePayMaxTextField.text.length > 0) {
        float value = self.basePayMaxTextField.text.floatValue;
        _strategyModel.MAX_PF_BASELINE = [NSNumber numberWithFloat:value];
    }else{
        _strategyModel.MAX_PF_BASELINE = [NSNumber numberWithFloat:0.0];
    }
    
    if (self.basePaySocialSecurityMaxTextField.text.length > 0) {
        float value = self.basePaySocialSecurityMaxTextField.text.floatValue;
        _strategyModel.MAX_SS_BASELINE = [NSNumber numberWithFloat:value];
    }else{
        _strategyModel.MAX_SS_BASELINE = [NSNumber numberWithFloat:0.0];
    }
    
    [[SKTaxContext sharedInstance] updateCurrentSecurityStrategy:_strategyModel];
    
    if (self.saveButtonClickedBlock) {
        self.saveButtonClickedBlock(_strategyModel.SS_TITLE);
    }
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma -mark UITextfield Delagate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case textFieldTypePensionForPersonal:
            
            break;
            
        case textFieldTypePensionForComapny:
            
            break;
            
        case textFieldTypeMedicalForPersonal:
            
            break;
            
        case textFieldTypeMedicalForComapny:
            
            break;
            
        case textFieldTypeUnemployementForPersonal:
            
            break;
            
        case textFieldTypeUnemployementForCompany:
            
            break;
            
        case textFieldTypeHouseFundForPersonal:
            
            break;
            
        case textFieldTypeHouseFundForCompany:
            
            break;
            
            
        case textFieldTypTaxPayMAX:
            
            break;
            
        case textFieldTypTaxPaySocialSecurityMAX:
            
            break;
            
        default:
            break;
    }
}

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

#pragma -mark keyboard event
- (void)keyboardDidShow:(NSNotification *)notif
{
    // 获得键盘尺寸
    NSDictionary *info = notif.userInfo;

    NSValue *aValue = [info objectForKeyedSubscript:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;


    //重新定义ScrollView的尺寸
    CGRect viewFrame = self.scrollView.frame;

    viewFrame.size.height -=(keyboardSize.height);  //原来的尺寸减去键盘的高度
    self.scrollView.frame = viewFrame;
//
//
//    //获取当前文本框架大小
   // CGRect textFieldRect = [self.basePayMaxTextField frame];
}

- (void)keyboardDidHide:(NSNotification *)notif
{
    //TODO
}

#pragma mark - OnClick Event
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

- (void)rightBarButtonItemClcik:(id)sender
{
    if (self.pensionForPersonalTextfield.text.length > 0) {
        float value = self.pensionForPersonalTextfield.text.floatValue/100.0;
        _strategyModel.P_ED = [NSNumber numberWithFloat:value];
    }else{
        _strategyModel.P_ED = [NSNumber numberWithFloat:0.0];
    }
    
    if (self.pensionForCompanyTextfield.text.length > 0) {
        float value = self.pensionForPersonalTextfield.text.floatValue/100.0;
        _strategyModel.C_ED = [NSNumber numberWithFloat:value];
    }else{
        _strategyModel.C_ED = [NSNumber numberWithFloat:0.0];
    }
    
    if (self.medicalForPersonalTextfield.text.length > 0) {
        float value = self.medicalForPersonalTextfield.text.floatValue/100.0;
        _strategyModel.P_MD = [NSNumber numberWithFloat:value];
    }else{
        _strategyModel.P_MD = [NSNumber numberWithFloat:0.0];
    }
    
    if (self.medicalForCompanyTextfield.text.length > 0) {
        float value = self.medicalForCompanyTextfield.text.floatValue/100.0;
        _strategyModel.C_MD = [NSNumber numberWithFloat:value];
    }else{
        _strategyModel.C_MD = [NSNumber numberWithFloat:0.0];
    }
    
    if (self.unemploymentForPersonalTextfield.text.length > 0) {
        float value = self.unemploymentForPersonalTextfield.text.floatValue/100.0;
        _strategyModel.P_UE = [NSNumber numberWithFloat:value];
    }else{
        _strategyModel.P_UE = [NSNumber numberWithFloat:0.0];
    }
    
    if (self.unemploymentForCompanyTextfield.text.length > 0) {
        float value = self.unemploymentForCompanyTextfield.text.floatValue/100.0;
        _strategyModel.C_UE = [NSNumber numberWithFloat:value];
    }else{
        _strategyModel.C_UE = [NSNumber numberWithFloat:0.0];
    }
    
    if (self.housingFundForPersonalTextfield.text.length > 0) {
        float value = self.housingFundForPersonalTextfield.text.floatValue/100.0;
        _strategyModel.P_HF = [NSNumber numberWithFloat:value];
    }else{
        _strategyModel.P_HF = [NSNumber numberWithFloat:0.0];
    }
    
    if (self.housingFundForCompanyTextfield.text.length > 0) {
        float value = self.housingFundForPersonalTextfield.text.floatValue/100.0;
        _strategyModel.C_HF = [NSNumber numberWithFloat:value];
    }else{
        _strategyModel.C_HF = [NSNumber numberWithFloat:0.0];
    }
    
    if (self.basePayMaxTextField.text.length > 0) {
        float value = self.basePayMaxTextField.text.floatValue;
        _strategyModel.MAX_PF_BASELINE = [NSNumber numberWithFloat:value];
    }else{
        _strategyModel.MAX_PF_BASELINE = [NSNumber numberWithFloat:0.0];
    }
    
    if (self.basePaySocialSecurityMaxTextField.text.length > 0) {
        float value = self.basePaySocialSecurityMaxTextField.text.floatValue;
        _strategyModel.MAX_SS_BASELINE = [NSNumber numberWithFloat:value];
    }else{
        _strategyModel.MAX_SS_BASELINE = [NSNumber numberWithFloat:0.0];
    }
    
    [[SKTaxContext sharedInstance] updateCurrentSecurityStrategy:_strategyModel];
    
    if (self.saveButtonClickedBlock) {
        self.saveButtonClickedBlock(_strategyModel.SS_TITLE);
    }
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma -mark Dealloc Method

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

@end
