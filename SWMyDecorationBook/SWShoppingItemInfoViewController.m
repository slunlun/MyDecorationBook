//
//  SWShoppingItemInfoViewController.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/9/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWShoppingItemInfoViewController.h"
#import "SWShoppingItemPhotoCell.h"
#import "SWShoppingItemPriceCell.h"
#import "SWShoppingItemRemarkCell.h"
#import "SWMarketNameCell.h"
#import "Masonry.h"
#import "SWUIDef.h"
#import "SWShoppingItem+CoreDataClass.h"

static NSString *PHOTO_CELL_IDENTIFY = @"PHOTO_CELL_IDENTIFY";
static NSString *PRICE_CELL_IDENTIFY = @"PRICE_CELL_IDENTIFY";
static NSString *REMARK_CELL_IDENTIFY = @"REMARK_CELL_IDENTIFY";
static NSString *NAME_CELL_IDENTIFY = @"NAME_CELL_IDENTIFY";

@interface SWShoppingItemInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *shoppingItemTableView;
@property(nonatomic, strong) UIButton *okBtn;
@property(nonatomic, strong) UIButton *cancelBtn;



@end

@implementation SWShoppingItemInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _shoppingItemTableView = [[UITableView alloc] init];
    [_shoppingItemTableView registerClass:[SWShoppingItemPhotoCell class] forCellReuseIdentifier:PHOTO_CELL_IDENTIFY];
    [_shoppingItemTableView registerClass:[SWShoppingItemPriceCell class] forCellReuseIdentifier:PRICE_CELL_IDENTIFY];
    [_shoppingItemTableView registerClass:[SWShoppingItemRemarkCell class] forCellReuseIdentifier:REMARK_CELL_IDENTIFY];
    [_shoppingItemTableView registerClass:[SWMarketNameCell class] forCellReuseIdentifier:NAME_CELL_IDENTIFY];
    _shoppingItemTableView.dataSource = self;
    _shoppingItemTableView.delegate = self;
    [self.view addSubview:_shoppingItemTableView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self commonInit];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.shoppingItem == nil) {
        self.shoppingItem = [[SWProductItem alloc] init];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Set/Get
- (void)setShoppingItem:(SWProductItem *)shoppingItem {
    _shoppingItem = shoppingItem;
    [self.shoppingItemTableView reloadData];
}

#pragma mark - Common init
- (void)commonInit {
    self.view.backgroundColor = SW_TAOBAO_BLACK;
    [_shoppingItemTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-90);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.mas_topLayoutGuideBottom);
        }
    }];
    
    _okBtn = [[UIButton alloc] init];
    _okBtn.titleLabel.font = SW_DEFAULT_FONT;
    [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_okBtn setBackgroundColor:SW_RMC_GREEN];
    _okBtn.layer.cornerRadius = SW_DEFAULT_CORNER_RADIOUS;
    _okBtn.clipsToBounds = YES;
    [_okBtn addTarget:self action:@selector(okBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_okBtn];
    
    _cancelBtn = [[UIButton alloc] init];
    _cancelBtn.titleLabel.font = SW_DEFAULT_FONT;
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setBackgroundColor:SW_WARN_RED];
    _cancelBtn.layer.cornerRadius = SW_DEFAULT_CORNER_RADIOUS;
    _cancelBtn.clipsToBounds = YES;
    [_cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelBtn];
    
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.view.mas_left).offset(SW_MARGIN);
        make.topMargin.equalTo(_shoppingItemTableView.mas_bottom).offset(SW_MARGIN);
        make.bottomMargin.equalTo(self.view.mas_bottom).offset(-SW_MARGIN * 2);
        make.rightMargin.equalTo(self.view.mas_centerX).offset(-SW_MARGIN);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.rightMargin.equalTo(self.view.mas_right).offset(-SW_MARGIN);
        make.topMargin.equalTo(_shoppingItemTableView.mas_bottom).offset(SW_MARGIN);
        make.bottomMargin.equalTo(self.view.mas_bottom).offset(-SW_MARGIN * 2);
        make.leftMargin.equalTo(self.view.mas_centerX).offset(SW_MARGIN);
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.row) {
        case 0:{
            cell = [tableView dequeueReusableCellWithIdentifier:NAME_CELL_IDENTIFY];
            ((SWMarketNameCell *)cell).titleLab.text = @"商品名称";
            if (self.shoppingItem.productName) {
                ((SWMarketNameCell *)cell).marketNameTextField.text = self.shoppingItem.productName;
            }
        }
            break;
        case 1:{
            cell = [tableView dequeueReusableCellWithIdentifier:PRICE_CELL_IDENTIFY];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            ((SWShoppingItemPriceCell *)cell).priceUnitActionBlock = ^(SWShoppingItemPriceCell *cell) {
                NSLog(@"TODO");
            };
            if (self.shoppingItem.price != -1.0f) {
                ((SWShoppingItemPriceCell *)cell).priceTextField.text = [NSString stringWithFormat:@"%.2f", self.shoppingItem.price];
            }
        }
            break;
        case 2: {
            cell = [tableView dequeueReusableCellWithIdentifier:REMARK_CELL_IDENTIFY];
            if (self.shoppingItem.productRemark != nil && ![self.shoppingItem.productRemark isEqualToString:@""]) {
                ((SWShoppingItemRemarkCell *)cell).remarkTextView.text = self.shoppingItem.productRemark;
            }
            
        }
            break;
        case 3: {
            cell = [tableView dequeueReusableCellWithIdentifier:PHOTO_CELL_IDENTIFY];
            if (self.shoppingItem.productPhotos) {
                ((SWShoppingItemPhotoCell *)cell).photos = [NSMutableArray arrayWithArray:self.shoppingItem.productPhotos];
            }
        }
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        return 180;
    }
    
    if (indexPath.row == 3)  {
        return 120;
    }
    return 40;
}

#pragma mark - UI Response
- (void)okBtnClicked:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancleBtnClicked:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
