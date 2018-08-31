//
//  SWNotebookHomeViewController.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/5/2.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWNotebookHomeViewController.h"
#import "SWShoppingItemHomePageVC.h"
#import "AppDelegate.h"
#import "SWShoppingOrderManager.h"
#import "Masonry.h"
#import "SWUIDef.h"
#import "SWNotebookBarChartView.h"
#import "SWNotebookPieChartView.h"
#import "SWOrderListinCategoryViewController.h"
#import "xlsxwriter.h"
#import "SWMarketContact.h"

@interface SWNotebookHomeViewController ()<SWNotebookPieChartViewDelegate, SWNotebookBarChartViewDelegate, UINavigationControllerDelegate>
@property(nonatomic, strong) NSArray *orderInfoArray;
@property(nonatomic, strong) UIView *focusView;
@property(nonatomic, strong) UIView *guideBarView;
@property(nonatomic, strong) SWNotebookPieChartView *pieChartView;
@property(nonatomic, strong) SWNotebookBarChartView *barChartView;
@end

@implementation SWNotebookHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self commonInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _orderInfoArray = [[SWShoppingOrderManager sharedInstance] loadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
     [_pieChartView updateSummarizingData];
    self.navigationController.delegate = self; // 在这里设置navigationController.delegate，确保第一次push到本vc时，delegate方法不被调用
}

#pragma mark - Common init
- (void)commonInit {
    // 初始化navigation bar
    UIBarButtonItem *shoppingItemHomePage = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MarketBig"] style:UIBarButtonItemStylePlain target:self action:@selector(shoppingItemHomePageClicked:)];
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareMyOrderClicked:)];
    self.navigationItem.leftBarButtonItem = shoppingItemHomePage;
    self.navigationItem.rightBarButtonItem = shareBtn;
    self.navigationItem.title = @"账本";
    
    // 初始化汇总视图的导航栏
    UIView *guideBarView = [[UIView alloc] init];
    guideBarView.backgroundColor = SW_DISABLIE_THIN_WHITE;
    [self.view addSubview:guideBarView];
    [guideBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.mas_topLayoutGuideBottom);
        }
        make.height.equalTo(@40);
    }];
    _guideBarView = guideBarView;
    
    UIButton *barChartBtn = [[UIButton alloc] init];
    [barChartBtn addTarget:self action:@selector(barChartBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    barChartBtn.titleLabel.font = SW_DEFAULT_FONT;
    [barChartBtn setTitle:@"条状图" forState:UIControlStateNormal];
    [barChartBtn setTitleColor:SW_TAOBAO_BLACK forState:UIControlStateNormal];
    [guideBarView addSubview:barChartBtn];
    [barChartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(guideBarView);
        make.right.equalTo(guideBarView.mas_right).offset(-SW_MARGIN);
        make.width.equalTo(@60);
    }];
    
    
    UIButton *pieChartBtn = [[UIButton alloc] init];
    [pieChartBtn addTarget:self action:@selector(pieChartBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    pieChartBtn.titleLabel.font = SW_DEFAULT_FONT;
    [pieChartBtn setTitle:@"饼图" forState:UIControlStateNormal];
    [pieChartBtn setTitleColor:SW_TAOBAO_BLACK forState:UIControlStateNormal];
    [guideBarView addSubview:pieChartBtn];
    [pieChartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(guideBarView);
        make.right.equalTo(barChartBtn.mas_left);
        make.width.equalTo(@60);
    }];
    
    UIView *focusView = [[UIView alloc] init];
    focusView.backgroundColor = SW_TAOBAO_ORANGE;
    focusView.alpha = 0.1f;
    [guideBarView addSubview:focusView];
    // 默认选中饼图
    [focusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(guideBarView);
        make.left.equalTo(pieChartBtn.mas_left);
        make.width.equalTo(@60);
    }];
    
    UIView *focusSubView = [[UIView alloc] init];
    focusSubView.backgroundColor = SW_TAOBAO_ORANGE;
    [guideBarView addSubview:focusSubView];
    [focusSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(focusView);
        make.height.equalTo(@2);
    }];
    _focusView = focusView;
    
    // 初始化饼图view和条形图view
    _pieChartView = [[SWNotebookPieChartView alloc] init];
    _pieChartView.backgroundColor = [UIColor whiteColor];
    _pieChartView.delegate = self;
    [self.view addSubview:_pieChartView];
    [_pieChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_guideBarView.mas_bottom);
    }];
    
    _barChartView = [[SWNotebookBarChartView alloc] init];
    _barChartView.backgroundColor = [UIColor whiteColor];
    _barChartView.delegate = self;
    [self.view addSubview:_barChartView];
    [_barChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_guideBarView.mas_bottom);
        make.bottom.equalTo(self.view);
        make.left.equalTo(_pieChartView.mas_right);
        make.width.equalTo(self.view.mas_width);
    }];
}

#pragma mark - UI Response
- (void)shoppingItemHomePageClicked:(UIBarButtonItem *)barItem {
    [((AppDelegate *)[UIApplication sharedApplication].delegate).drawerVC dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)shareMyOrderClicked:(UIBarButtonItem *)barItem {
    NSURL *url = [self generateSharedExcel];
    UIDocumentInteractionController *vc = [UIDocumentInteractionController
     interactionControllerWithURL:url];
    [vc presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
}


- (void)pieChartBtnClicked:(UIButton *)button {
    [self.focusView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.guideBarView);
        make.left.equalTo(button.mas_left);
        make.width.equalTo(@60);
    }];
    
    [_pieChartView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_guideBarView.mas_bottom);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
}

- (void)barChartBtnClicked:(UIButton *)button {
    [self.focusView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.guideBarView);
        make.left.equalTo(button.mas_left);
        make.width.equalTo(@60);
    }];
    
    [_pieChartView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_guideBarView.mas_bottom);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view.mas_left);
        make.width.equalTo(self.view);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            // 更新bar chart 信息
            [_barChartView updateData];
        }
    }];
}

#pragma mark - SWNotebookPieChartViewDelegate
- (void)SWNotebookPieChartView:(SWNotebookPieChartView *)pieCharView didSelectOrderCategory:(NSDictionary *)dict {
    SWShoppingOrderCategoryModle *orderCategory = dict.allKeys.firstObject;
    SWOrderListinCategoryViewController *vc = [[SWOrderListinCategoryViewController alloc] initWithShoppingCategory:orderCategory];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - SWNotebookBarChartViewDelegate
- (void)SWNotebookBarChartView:(SWNotebookBarChartView *)barCharView didSelectOrderCategory:(NSDictionary *)dict {
    SWShoppingOrderCategoryModle *orderCategory = dict.allKeys.firstObject;
    SWOrderListinCategoryViewController *vc = [[SWOrderListinCategoryViewController alloc] initWithShoppingCategory:orderCategory];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isEqual:self]) {
        _barChartView.needUpdata = YES;
    }
}

#pragma mark - Generate shared excel
- (NSURL *)generateSharedExcel {
    // 文件保存的路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [documentPath stringByAppendingPathComponent:@"家装清单.xlsx"];
    // 创建新xlsx文件
    lxw_workbook  *workbook  = workbook_new([filename UTF8String]);
    // 创建sheet
    lxw_worksheet *worksheet = workbook_add_worksheet(workbook, NULL);
   
    
    // excel文件title
    lxw_format *excelTitleFormat = workbook_add_format(workbook);
    format_set_bold(excelTitleFormat);
    format_set_font_size(excelTitleFormat, 28);
    format_set_align(excelTitleFormat, LXW_ALIGN_CENTER);
    format_set_align(excelTitleFormat, LXW_ALIGN_VERTICAL_CENTER);//垂直居中
    NSString *excelTitleStr = @"家装清单";
    worksheet_merge_range(worksheet, 0, 0, 0, 5, [excelTitleStr cStringUsingEncoding:NSUTF8StringEncoding], excelTitleFormat);
    
    // 设置家装随手记的标语
    lxw_format *APPLogoFormat = workbook_add_format(workbook);
    format_set_font_size(APPLogoFormat, 15);
    worksheet_set_column(worksheet, 0, 6, 15, NULL);
    format_set_font_color(APPLogoFormat, LXW_COLOR_BLUE);
    format_set_align(APPLogoFormat, LXW_ALIGN_RIGHT);
    NSString *APPLogoStr = @"powder by 家装随手记APP";
    worksheet_merge_range(worksheet, 1, 0, 1, 5, [APPLogoStr cStringUsingEncoding:NSUTF8StringEncoding], APPLogoFormat);
    
    // 设置清单内容
    // 订单总额格式
    lxw_format *orderTotalCostFormat = workbook_add_format(workbook);
    format_set_align(orderTotalCostFormat, LXW_ALIGN_LEFT);
    format_set_font_color(orderTotalCostFormat, 0xe74c3c);
    format_set_font_size(orderTotalCostFormat, 25);
    
    // 订单分类名称格式
    lxw_format* orderCategoryNameFormat = workbook_add_format(workbook);
    format_set_bg_color(orderCategoryNameFormat, 0xB5D4F5);
    format_set_align(orderCategoryNameFormat, LXW_ALIGN_LEFT);
    format_set_font_size(orderCategoryNameFormat, 25);
    worksheet_set_column(worksheet, 0, 6, 25, NULL);
    
    // 订单分类总计格式
    lxw_format* orderCategoryTotalPriceFormat = workbook_add_format(workbook);
    format_set_align(orderCategoryTotalPriceFormat, LXW_ALIGN_RIGHT);
    format_set_font_size(orderCategoryTotalPriceFormat, 25);
    format_set_font_color(orderCategoryTotalPriceFormat, 0xe74c3c);
    format_set_bg_color(orderCategoryTotalPriceFormat, 0xB5D4F5);
    
    // 商铺名称格式
    lxw_format* marketNameFormat = workbook_add_format(workbook);
    format_set_bg_color(marketNameFormat, 0x7FF3A1);
    format_set_align(marketNameFormat, LXW_ALIGN_LEFT);
    format_set_font_size(marketNameFormat, 20);
    format_set_font_color(marketNameFormat, LXW_COLOR_GRAY);

    
    // 商家总支出格式
    lxw_format* marketTotalExpendFormat = workbook_add_format(workbook);
    format_set_align(marketTotalExpendFormat, LXW_ALIGN_RIGHT);
    format_set_font_size(marketTotalExpendFormat, 20);
    format_set_bg_color(marketTotalExpendFormat, 0x7FF3A1);
    
    
    // 商家联系人格式
    lxw_format* marketContactFormat = workbook_add_format(workbook);
    format_set_align(marketContactFormat, LXW_ALIGN_LEFT);
    format_set_font_size(marketContactFormat, 15);
    format_set_font_color(marketContactFormat, 0xB5D4F5);
    
    // 联系人
    lxw_format* marketContactTitleFormat = workbook_add_format(workbook);
    format_set_align(marketContactTitleFormat, LXW_ALIGN_LEFT);
    format_set_font_size(marketContactTitleFormat, 18);
    format_set_bold(marketContactTitleFormat);

    
    // 商铺订单明细分类格式
    lxw_format* marketOrderDetailTitleFormat = workbook_add_format(workbook);
    format_set_bold(marketOrderDetailTitleFormat);
    format_set_align(marketOrderDetailTitleFormat, LXW_ALIGN_CENTER);
    format_set_align(marketOrderDetailTitleFormat, LXW_ALIGN_VERTICAL_CENTER);//垂直居中
    format_set_font_size(marketOrderDetailTitleFormat, 18);
    format_set_font_color(marketOrderDetailTitleFormat, LXW_COLOR_BROWN);
    
    // 商铺订单明细内容格式
    lxw_format* marketOrderDetailFormat = workbook_add_format(workbook);
    format_set_align(marketOrderDetailFormat, LXW_ALIGN_CENTER);
    format_set_align(marketOrderDetailFormat, LXW_ALIGN_VERTICAL_CENTER);//垂直居中
    format_set_font_size(marketOrderDetailFormat, 15);
    
    // 空行
    lxw_format* spaceLineFormat = workbook_add_format(workbook);
    format_set_font_size(spaceLineFormat, 25);
    
    int rowNum = 2;
    // 写内容
    // ================================
    // 总支出
    CGFloat totalCost = 0;
    for (NSDictionary *infoDict in self.orderInfoArray) {
        SWShoppingOrderCategoryModle *model = infoDict.allKeys.firstObject;
        totalCost += model.totalCost;
    }
    NSString * totalCostStr = [NSString stringWithFormat:@"总支出 ¥ %.2f", totalCost];
    worksheet_merge_range(worksheet, rowNum, 0, rowNum, 5, [totalCostStr cStringUsingEncoding:NSUTF8StringEncoding], orderTotalCostFormat);
    ++rowNum;
    
    
    // 各个分类
    for (NSDictionary *infoDict in self.orderInfoArray) {
        // 空行
        worksheet_merge_range(worksheet, rowNum, 0, rowNum, 5, "", spaceLineFormat);
        ++rowNum;
        // 分类名称
        SWShoppingOrderCategoryModle *model = infoDict.allKeys.firstObject;
        NSString *categoryNameStr = model.orderCategoryName;
        worksheet_merge_range(worksheet, rowNum, 0, rowNum, 3, [categoryNameStr cStringUsingEncoding:NSUTF8StringEncoding], orderCategoryNameFormat);
        NSString *totalCostStr =  [NSString stringWithFormat:@"¥ %.2f", model.totalCost];
        
        worksheet_merge_range(worksheet, rowNum, 4, rowNum, 5, [totalCostStr cStringUsingEncoding:NSUTF8StringEncoding], orderCategoryTotalPriceFormat);
        ++rowNum;
        
        // 为当前分类下的订单按照商铺归类
        NSArray *orderList = infoDict[model];
        NSMutableArray *sortedArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *dict = nil;
        for (SWOrder *order in orderList) {
            if (dict == nil) {
                dict = [[NSMutableDictionary alloc] init];
                NSMutableArray *array = [NSMutableArray arrayWithObject:order];
                [dict setObject:array forKey:order.marketItem.itemID];
            }else {
                NSString *dictKey = (NSString *)dict.allKeys.firstObject;
                if ([dictKey isEqualToString:order.marketItem.itemID]) {
                    NSMutableArray *orderArray = [dict objectForKey:dictKey];
                    [orderArray addObject:order];
                }else {
                    [sortedArray addObject:dict];
                    dict = [[NSMutableDictionary alloc] init];
                    NSMutableArray *array = [NSMutableArray arrayWithObject:order];
                    [dict setObject:array forKey:order.marketItem.itemID];
                }
            }
        }
        if (dict != nil) {
            [sortedArray addObject:dict];
        }
        
        // 归类完毕，依次显示商家订单信息
        for (NSDictionary *orderDict in sortedArray) {
            NSString *key = orderDict.allKeys.firstObject;
            NSArray *marketOrderArray = orderDict[key];
            SWOrder *firstOrder = marketOrderArray.firstObject;
            // 商家信息
            worksheet_merge_range(worksheet, rowNum, 0, rowNum, 3, [firstOrder.marketItem.marketName cStringUsingEncoding:NSUTF8StringEncoding], marketNameFormat);
            int marketRowNum = rowNum;
            rowNum++;
            
            // 联系人
            worksheet_merge_range(worksheet, rowNum, 0, rowNum, 5, "联系人", marketContactTitleFormat);
            rowNum++;
            
            // 商家联系方式
            for (SWMarketContact *contact in firstOrder.marketItem.telNums) {
                worksheet_merge_range(worksheet, rowNum, 0, rowNum, 2, [contact.name cStringUsingEncoding:NSUTF8StringEncoding], marketContactFormat);
                worksheet_merge_range(worksheet, rowNum, 3, rowNum, 5, [contact.telNum cStringUsingEncoding:NSUTF8StringEncoding], marketContactFormat);
                rowNum++;
            }
            
            
            // 订单明细分类
            worksheet_write_string(worksheet, rowNum, 0, "商品", marketOrderDetailTitleFormat);
            worksheet_write_string(worksheet, rowNum, 1, "单价", marketOrderDetailTitleFormat);
            worksheet_write_string(worksheet, rowNum, 2, "数量", marketOrderDetailTitleFormat);
            worksheet_write_string(worksheet, rowNum, 3, "日期", marketOrderDetailTitleFormat);
            worksheet_write_string(worksheet, rowNum, 4, "备注", marketOrderDetailTitleFormat);
            worksheet_write_string(worksheet, rowNum, 5, "总价", marketOrderDetailTitleFormat);
            rowNum++;
            
            // 订单明细内容
            CGFloat marketOrderTotalPrice = 0.0f; // 记录在当前商家上的总支出
            for(SWOrder *order in marketOrderArray) {
                marketOrderTotalPrice += order.orderTotalPrice;
                
                worksheet_write_string(worksheet, rowNum, 0, [order.productItem.productName cStringUsingEncoding:NSUTF8StringEncoding], marketOrderDetailFormat);
                
                NSString *productPriceStr = [NSString stringWithFormat:@"￥%.2f/%@", order.productItem.price, order.productItem.itemUnit.unitTitle];
                worksheet_write_string(worksheet, rowNum, 1, [productPriceStr cStringUsingEncoding:NSUTF8StringEncoding], marketOrderDetailFormat);
                
                NSString *orderCountStr = [NSString stringWithFormat:@"%.2f", order.itemCount];
                worksheet_write_string(worksheet, rowNum, 2, [orderCountStr cStringUsingEncoding:NSUTF8StringEncoding], marketOrderDetailFormat);
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                //设置格式：zzz表示时区
                [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
                //NSDate转NSString
                NSString *orderDateStr = [dateFormatter stringFromDate:order.orderDate];
                worksheet_write_string(worksheet, rowNum, 3, [orderDateStr cStringUsingEncoding:NSUTF8StringEncoding], marketOrderDetailFormat);
                
                worksheet_write_string(worksheet, rowNum, 4, [order.orderRemark cStringUsingEncoding:NSUTF8StringEncoding], marketOrderDetailFormat);
                
                NSString *totalPriceStr = [NSString stringWithFormat:@"￥%.2f", order.orderTotalPrice];
                worksheet_write_string(worksheet, rowNum, 5, [totalPriceStr cStringUsingEncoding:NSUTF8StringEncoding], marketOrderDetailFormat);
                rowNum++;
            }
            
            // 返回商家总支出行，写总支出
            NSString *marketTotalExpend = [NSString stringWithFormat:@"￥%.2f", marketOrderTotalPrice];
            worksheet_merge_range(worksheet, marketRowNum, 4, marketRowNum, 5, [marketTotalExpend cStringUsingEncoding:NSUTF8StringEncoding], marketTotalExpendFormat);
        }
        
    }
    // 生成excel
    workbook_close(workbook);
    NSURL *filePath = [NSURL fileURLWithPath:filename];
    return filePath;
}
@end
