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
#import "SWPriceUnitStorage.h"

@interface SWSystemConfigViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *configTableView;
@property(nonatomic, strong) UIButton *okBtn;
@property(nonatomic, strong) UIButton *cancelBtn;

// record result
@property(nonatomic, strong) NSString* totalBudget;
@property(nonatomic, assign) BOOL syncContactOn;
@property(nonatomic, strong) NSMutableArray *storedItemUnitArray;
@property(nonatomic, strong) NSMutableArray *addedItemUnitArray;
@property(nonatomic, strong) NSMutableArray *updateItemUnitArray;
@property(nonatomic, strong) NSMutableArray *delItemUnitArray;
@end

@implementation SWSystemConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"系统设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.syncContactOn = [[NSUserDefaults standardUserDefaults] boolForKey:SW_SYNC_CONTACT_TO_SYS_KEY];
    self.totalBudget = [[NSUserDefaults standardUserDefaults] objectForKey:SW_BUDGET_KEY];
    if (self.totalBudget == nil) {
        self.totalBudget = @"0.00";
    }
    self.storedItemUnitArray = [NSMutableArray arrayWithArray:[SWPriceUnitStorage allPriceUnit]];
    [self commonInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Setter/Getter
- (NSMutableArray *)updateItemUnitArray {
    if (_updateItemUnitArray == nil) {
        _updateItemUnitArray = [[NSMutableArray alloc] init];
    }
    return _updateItemUnitArray;
}

- (NSMutableArray *)delItemUnitArray {
    if (_delItemUnitArray == nil) {
        _delItemUnitArray = [[NSMutableArray alloc] init];
    }
    return _delItemUnitArray;
}

- (NSMutableArray *)addedItemUnitArray {
    if (_addedItemUnitArray == nil) {
        _addedItemUnitArray = [[NSMutableArray alloc] init];
    }
    return _addedItemUnitArray;
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
        make.leftMargin.equalTo(bkView.mas_left).offset(SW_CELL_LEFT_MARGIN);
        make.topMargin.equalTo(self.configTableView.mas_bottom).offset(SW_MARGIN);
        make.bottomMargin.equalTo(bkView.mas_bottom).offset(-SW_MARGIN);
        make.width.equalTo(bkView.mas_width).multipliedBy(0.5).offset(-SW_MARGIN);
    }];
    
    _okBtn = [[UIButton alloc] init];
    _okBtn.titleLabel.font = SW_DEFAULT_FONT_LARGE_BOLD;
    [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_okBtn setTitle:@"保 存" forState:UIControlStateNormal];
    [_okBtn setBackgroundColor:SW_RMC_GREEN];
    _okBtn.layer.cornerRadius = SW_DEFAULT_CORNER_RADIOUS;
    _okBtn.clipsToBounds = YES;
    [_okBtn addTarget:self action:@selector(okBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_okBtn];
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.cancelBtn.mas_right).offset(SW_MARGIN);
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
    if (section == 2) {
        return self.storedItemUnitArray.count + 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:  // 家装预算
        {
            SWBudgetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SWBudgetCell_Identify" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell updateBudget:self.totalBudget];
            WeakObj(self);
            cell.budgetUpdate = ^(NSString *totalBudget) {
                StrongObj(self);
                self.totalBudget = totalBudget;
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 2: // 商品单位
        {
            if (indexPath.row < self.storedItemUnitArray.count) {
                SWProductUnitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SWProductUnitCell_Identify" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                SWItemUnit *itemUnit = self.storedItemUnitArray[indexPath.row];
                [cell setModel:itemUnit];
                
                WeakObj(self);
                cell.unitUpdateBlock = ^(SWItemUnit *itemUnit) {
                    StrongObj(self);
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"单位名称" preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
                        textField.placeholder = itemUnit.unitTitle;
                    }];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        UITextField *textField = alertController.textFields[0];
                        if (![textField.text isEqualToString:@""] && ![textField.text isEqualToString:itemUnit.unitTitle]) {
                            SWItemUnit *updateUnit = [itemUnit copy];
                            updateUnit.unitTitle = textField.text;
                            itemUnit.unitTitle = textField.text;
                            [self.updateItemUnitArray addObject:updateUnit];
                            [self.configTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
                        }
                    }];
                    [alertController addAction:cancelAction];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                };
                
               
                cell.unitDeleteBlock = ^(SWItemUnit *itemUnit) {
                    StrongObj(self);
                    if (itemUnit.shopItemAssociated) {
                        NSString *messageString = @"单位已与商品绑定，不能删除!";
                        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:messageString preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                        }];
                        [alertController addAction:okAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                        return;
                    }
                    
                    NSString *messageString = [NSString stringWithFormat:@"确定删除 %@ 吗?", itemUnit.unitTitle];
                    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:messageString preferredStyle:UIAlertControllerStyleAlert];//UIAlertControllerStyleAlert视图在中央
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        SWItemUnit *delUnit = [itemUnit copy];
                        [self.delItemUnitArray addObject:delUnit];
                        [self.storedItemUnitArray removeObject:itemUnit];
                        [self.configTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
                    }];
                    [alertController addAction:cancelAction];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                };
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NORMAL_CELL"];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NORMAL_CELL"];
                }
                cell.textLabel.text = @"添加单位";
                cell.textLabel.textColor = SW_DISABLE_GRAY;
                cell.imageView.image = [UIImage imageNamed:@"BigAdd"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            
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
    if (indexPath.section == 2) { // 商品单位
        return 50;
    }
    return SW_CELL_DEFAULT_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row == self.storedItemUnitArray.count) {  // 添加单位
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"新建单位" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = @"单位名称";
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = alertController.textFields[0];
            if (![textField.text isEqualToString:@""]) {
                NSString *itemUnitName = textField.text;
                BOOL itemExisted = NO;
                for (SWItemUnit *itemUnit in self.storedItemUnitArray) {
                    if ([itemUnit.unitTitle isEqualToString:itemUnitName]) {
                        itemExisted = YES;
                        break;
                    }
                }
                if (!itemExisted) {
                    SWItemUnit *newItemUnit = [[SWItemUnit alloc] initWithUnit:itemUnitName];
                    [self.storedItemUnitArray addObject:newItemUnit];
                    [self.addedItemUnitArray addObject:newItemUnit];
                    [self.configTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - UI response
- (void)okBtnClicked:(UIButton *)btn {
    
    [[NSUserDefaults standardUserDefaults] setBool:self.syncContactOn forKey:SW_SYNC_CONTACT_TO_SYS_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:self.totalBudget forKey:SW_BUDGET_KEY];
    
    // 添加单位
    for (SWItemUnit *itemUnit in self.addedItemUnitArray) {
        [SWPriceUnitStorage insertPriceUnit:itemUnit];
    }
    
    // 修改单位
    for (SWItemUnit *itemUnit in self.updateItemUnitArray) {
        [SWPriceUnitStorage updatePriceUnit:itemUnit];
    }
    // 删除单位
    for (SWItemUnit *itemUnit in self.delItemUnitArray) {
        [SWPriceUnitStorage removePriceUnit:itemUnit];
    }
    
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
