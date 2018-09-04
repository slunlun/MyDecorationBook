//
//  SWSystemConfigViewController.m
//  SWMyDecorationBook
//
//  Created by Eren on 2018/9/3.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWSystemConfigViewController.h"
#import "SWUIDef.h"
#import "Masonry.h"
#import "SWContactConfigCell.h"
#import "SWBudgetCell.h"
#import "SWProductUnitCell.h"
#import "SWDef.h"

@interface SWSystemConfigViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *configTableView;
@property(nonatomic, strong) UIButton *okBtn;
@property(nonatomic, strong) UIButton *cancelBtn;

// record result
@property(nonatomic, strong) NSString* totalBudget;
@property(nonatomic, assign) BOOL syncContactOn;

@end

@implementation SWSystemConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"系统设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.syncContactOn = [[NSUserDefaults standardUserDefaults] boolForKey:SW_SYNC_CONTACT_TO_SYS_KEY];
    self.totalBudget = [[NSUserDefaults standardUserDefaults] objectForKey:SW_BUDGET_KEY];
    
    [self commonInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Common init
- (void)commonInit {
    UIView *bkView = [[UIView alloc] init];
    bkView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bkView];
    [bkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.mas_topLayoutGuideBottom);
        }
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
    }];
    
    _configTableView = [[UITableView alloc] init];
    _configTableView.dataSource = self;
    _configTableView.delegate = self;
    _configTableView.tableFooterView = [[UIView alloc] init];
    [_configTableView registerClass:[SWContactConfigCell class] forCellReuseIdentifier:@"SWContactConfigCell_Identify"];
    [_configTableView registerClass:[SWBudgetCell class] forCellReuseIdentifier:@"SWBudgetCell_Identify"];
    [_configTableView registerClass:[SWProductUnitCell class] forCellReuseIdentifier:@"SWProductUnitCell_Identify"];
    [bkView addSubview:_configTableView];
    [_configTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(bkView);
        make.bottom.equalTo(bkView.mas_bottom).offset(-75);
    }];
    
    _okBtn = [[UIButton alloc] init];
    _okBtn.titleLabel.font = SW_DEFAULT_FONT_LARGE_BOLD;
    [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_okBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [_okBtn setBackgroundColor:SW_RMC_GREEN];
    _okBtn.layer.cornerRadius = SW_DEFAULT_CORNER_RADIOUS;
    _okBtn.clipsToBounds = YES;
    [_okBtn addTarget:self action:@selector(okBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_okBtn];
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(bkView.mas_left).offset(SW_CELL_LEFT_MARGIN);
        make.topMargin.equalTo(self.configTableView.mas_bottom).offset(SW_MARGIN);
        make.bottomMargin.equalTo(bkView.mas_bottom).offset(-SW_MARGIN);
        make.width.equalTo(bkView.mas_width).multipliedBy(0.5).offset(-SW_MARGIN);
    }];
    
    _cancelBtn = [[UIButton alloc] init];
    _cancelBtn.titleLabel.font = SW_DEFAULT_FONT_LARGE_BOLD;
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
    [_cancelBtn setBackgroundColor:SW_WARN_RED];
    _cancelBtn.layer.cornerRadius = SW_DEFAULT_CORNER_RADIOUS;
    _cancelBtn.clipsToBounds = YES;
    [_cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelBtn];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.okBtn.mas_right).offset(SW_MARGIN);
        make.topMargin.equalTo(self.configTableView.mas_bottom).offset(SW_MARGIN);
        make.bottomMargin.equalTo(bkView.mas_bottom).offset(-SW_MARGIN);
        make.rightMargin.equalTo(bkView.mas_right).offset(-SW_CELL_LEFT_MARGIN);
    }];
}



#pragma mark - UITableViewDataSource
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            return @"家装预算";
        }
            break;
        case 1:
        {
            return @"商家联系人";
        }
            break;
        case 2:
        {
            return @"商品单位";
        }
            break;
        default:
            break;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:  // 家装预算
        {
            SWBudgetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SWBudgetCell_Identify" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell updateBudget:[[NSUserDefaults standardUserDefaults] stringForKey:SW_BUDGET_KEY]];
            WeakObj(self);
            cell.budgetUpdate = ^(NSString *totalBudget) {
                StrongObj(self);
                self.totalBudget = totalBudget;
            };
            
            return cell;
        }
            break;
        case 1:  // 商家联系人
        {
            SWContactConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SWContactConfigCell_Identify" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell updateSwitchState:[[NSUserDefaults standardUserDefaults] boolForKey:SW_SYNC_CONTACT_TO_SYS_KEY]];
            WeakObj(self);
            cell.stateChanged = ^(BOOL state) {
                StrongObj(self);
                self.syncContactOn = state;
            };
            return cell;
        }
            break;
        case 2: // 商品单位
        {
            SWProductUnitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SWProductUnitCell_Identify" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SW_CELL_DEFAULT_HEIGHT;
}

#pragma mark - UI response
- (void)okBtnClicked:(UIButton *)btn {
    
    [[NSUserDefaults standardUserDefaults] setBool:self.syncContactOn forKey:SW_SYNC_CONTACT_TO_SYS_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:self.totalBudget forKey:SW_BUDGET_KEY];
    if ([self.delegate respondsToSelector:@selector(dismissVC)]) {
        [self.delegate dismissVC];
    }
}

- (void)cancelBtnClicked:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(dismissVC)]) {
        [self.delegate dismissVC];
    }
}
@end
