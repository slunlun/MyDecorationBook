//
//  SWMarketViewController.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 1/4/18.
//  Copyright © 2018 Eren. All rights reserved.
//

#import "SWMarketViewController.h"
#import "SWMarketItem.h"
#import "SWNewMarketTelNumCell.h"
#import "SWMarketContactSectionHeaderView.h"
#import "SWMarketNameCell.h"
#import "SWUIDef.h"
#import "SWDef.h"
#import "SWPickerView.h"
#import "Masonry.h"
#import "SWMarketStorage.h"
#import "SWMarketCategoryStorage.h"

static NSString *TEL_CELL_IDENTIFIER = @"TEL_CELL_IDENTIFIER";
static NSString *MARKET_CONTACT_HEADER_VIEW_IDENTIFIER = @"MARKET_CONTACT_HEADER_VIEW_IDENTIFIER";
static NSString *MARKET_NAME_CELL_IDENTIFIER = @"MARKET_NAME_CELL_IDENTIFIER";
static NSString *MARKET_CATEGORY_CELL_IDENTIFIER = @"MARKET_CATEGORY_CELL_IDENTIFIER";


@interface SWMarketViewController () <UITableViewDelegate, UITableViewDataSource, SWPickerViewDelegate, UIGestureRecognizerDelegate>
@property(nonatomic, strong) UITableView *marketInfoTableView;
@property(nonatomic, strong) SWPickerView *pickerView;
@property(nonatomic, strong) UIView *coverView;
@property(nonatomic, assign) BOOL isEditing;
@property(nonatomic, strong) UIButton *okBtn;
@property(nonatomic, strong) UIButton *cancelBtn;

@property(nonatomic, strong) NSArray *itemUnitArray;
@end

@implementation SWMarketViewController

- (instancetype)initWithMarketItem:(SWMarketItem *)marketItem {
    if(self = [super init]){
        _marketItem = marketItem;
    }
    return self;
}

- (instancetype)init {
    NSAssert(NO, @"Use (instancetype)initWithMarketItem:(SWMarketItem *)marketItem");
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _itemUnitArray = [SWMarketCategoryStorage allMarketCategory];
    
    _marketInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _marketInfoTableView.delegate = self;
    _marketInfoTableView.dataSource = self;
    _marketInfoTableView.showsVerticalScrollIndicator = NO;
    _marketInfoTableView.showsHorizontalScrollIndicator = NO;
    [_marketInfoTableView registerClass:[SWNewMarketTelNumCell class] forCellReuseIdentifier:TEL_CELL_IDENTIFIER];
    [_marketInfoTableView registerClass:[UITableViewCell class]
     forCellReuseIdentifier:MARKET_CONTACT_HEADER_VIEW_IDENTIFIER];
    [_marketInfoTableView registerClass:[SWMarketNameCell class] forCellReuseIdentifier:MARKET_NAME_CELL_IDENTIFIER];
    _marketInfoTableView.tableFooterView = [[UIView alloc] init];
    [self registerNotification];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTaped:)];
//    tap.delegate = self;
//    [self.marketInfoTableView addGestureRecognizer:tap];
    [self commonInit];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.isEditing) {
        return YES;
    }else {
       return NO;
    }
}

- (void)viewTaped:(UITapGestureRecognizer *)tap {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Common init
- (void)commonInit {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"商家信息";
    
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
    
    
    [bkView addSubview:_marketInfoTableView];
    [_marketInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(bkView);
        make.bottom.equalTo(bkView.mas_bottom).offset(-75);
    }];
    _marketInfoTableView.sectionHeaderHeight = 10;
    
    _okBtn = [[UIButton alloc] init];
    _okBtn.titleLabel.font = SW_DEFAULT_FONT_LARGE_BOLD;
    [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_okBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [_okBtn setBackgroundColor:SW_RMC_GREEN];
    _okBtn.layer.cornerRadius = SW_DEFAULT_CORNER_RADIOUS;
    _okBtn.clipsToBounds = YES;
    [_okBtn addTarget:self action:@selector(okBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bkView addSubview:_okBtn];
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(bkView.mas_left).offset(SW_CELL_LEFT_MARGIN);
        make.topMargin.equalTo(self.marketInfoTableView.mas_bottom).offset(SW_MARGIN);
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
    [bkView addSubview:_cancelBtn];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.okBtn.mas_right).offset(SW_MARGIN);
        make.topMargin.equalTo(self.marketInfoTableView.mas_bottom).offset(SW_MARGIN);
        make.bottomMargin.equalTo(bkView.mas_bottom).offset(-SW_MARGIN);
        make.rightMargin.equalTo(bkView.mas_right).offset(-SW_CELL_LEFT_MARGIN);
    }];
    [_cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - SETTER/GETTER
- (void)setMarketItem:(SWMarketItem *)marketItem {
    _marketItem = marketItem;
}

- (NSArray *)itemUnitArray {
    if (_itemUnitArray == nil) {
        _itemUnitArray = [[NSArray alloc] init];
    }
    return _itemUnitArray;
}


#pragma mark - Notification
- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notificaiton {
    NSDictionary *info = notificaiton.userInfo;
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.marketInfoTableView.contentInset = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
    self.isEditing = YES;
    
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    self.marketInfoTableView.contentInset = UIEdgeInsetsZero;
    self.isEditing = NO;
}

#pragma mark - SWPickerViewDelegate
- (NSInteger)SWPickerView:(SWPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.itemUnitArray.count;
}
- (NSString *)SWPickerView:(SWPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.itemUnitArray[row];
}

- (NSInteger)numberOfComponentsInSWPickerView:(SWPickerView *)pickerView {
    return 1;
}

- (void)SWPickerView:(SWPickerView *)pickerView didClickOKForRow:(NSInteger)row forComponent:(NSInteger)component {
    SWMarketCategory *itemUnit = self.itemUnitArray[row];
    UITableViewCell *cell = [self.marketInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    cell.detailTextLabel.text = itemUnit.categoryName;
    self.marketItem.marketCategory = itemUnit;
}

- (void)cancelSelectInSWPickerView:(SWPickerView *)pickerView {
    
}

- (nullable NSAttributedString *)SWPickerView:(SWPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    SWMarketCategory * category = self.itemUnitArray[row];
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc]initWithString:category.categoryName];
    [AttributedString addAttributes:@{NSFontAttributeName:SW_DEFAULT_SUPER_MIN_FONT, NSForegroundColorAttributeName:SW_TAOBAO_BLACK} range:NSMakeRange(0, [AttributedString  length])];
    return AttributedString;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) { // 联系电话的title
        return SW_CELL_DEFAULT_HEIGHT_MIN;
    }else {
        return SW_CELL_DEFAULT_HEIGHT;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1 && indexPath.row == 0) { // 添加联系人
        NSInteger numOfRows = [self.marketInfoTableView numberOfRowsInSection:indexPath.section];
        NSIndexPath *addIndex = [NSIndexPath indexPathForRow:numOfRows inSection:indexPath.section];
        [self.marketInfoTableView beginUpdates];
        [self.marketInfoTableView insertRowsAtIndexPaths:@[addIndex] withRowAnimation:UITableViewRowAnimationBottom];
        // Add a new contact in testArray
        SWMarketContact *newContact = [[SWMarketContact alloc] init];
        [self.marketItem.telNums addObject:newContact];

        [self.marketInfoTableView endUpdates];
        if (self.isEditing) {
            UIEdgeInsets edge = self.marketInfoTableView.contentInset;
            self.marketInfoTableView.contentInset = UIEdgeInsetsMake(edge.top, edge.left, edge.bottom + 40, edge.right);
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return self.marketItem.telNums.count + 1;
            break;
        case 2:
            return 1;
            break;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    [cell setEditing:NO];
    switch (indexPath.section) {
        case 0: 
        {
            cell = [tableView dequeueReusableCellWithIdentifier:MARKET_NAME_CELL_IDENTIFIER];
            ((SWMarketNameCell *)cell).titleLab.text = @"商家";
            ((SWMarketNameCell *)cell).marketNameTextField.text = self.marketItem.marketName;
            WeakObj(self);
            ((SWMarketNameCell *)cell).finishBlock = ^(NSString *inputName) {
                if (inputName) {
                    StrongObj(self);
                    self.marketItem.marketName = inputName;
                }
            };
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:MARKET_CONTACT_HEADER_VIEW_IDENTIFIER];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MARKET_CONTACT_HEADER_VIEW_IDENTIFIER];
                }
                cell.textLabel.text = @"联系电话";
                cell.textLabel.textColor = SW_TAOBAO_BLACK;
                cell.textLabel.font = SW_DEFAULT_FONT_BOLD;
                cell.detailTextLabel.text = self.marketItem.marketCategory.categoryName;
                cell.detailTextLabel.font = SW_DEFAULT_MIN_FONT;
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BigAdd"]];
            }else{
                cell = [tableView dequeueReusableCellWithIdentifier:TEL_CELL_IDENTIFIER];
                SWMarketContact *contact = self.marketItem.telNums[indexPath.row - 1];
                ((SWNewMarketTelNumCell *)cell).marketContact = contact;
                WeakObj(self);
                ((SWNewMarketTelNumCell *)cell).defaultContactSetBlock = ^(SWMarketContact *contact) {
                    for (SWMarketContact *contact in self.marketItem.telNums) {
                        contact.defaultContact = NO;
                    }
                    ((SWMarketContact *)self.marketItem.telNums[indexPath.row -1]).defaultContact = YES;
                    StrongObj(self);
                    [self.marketInfoTableView reloadData];
                };
                
                ((SWNewMarketTelNumCell *)cell).contactTelNumChangedBlock = ^(NSString *contactTelNum) {
                    StrongObj(self);
                    ((SWMarketContact *)self.marketItem.telNums[indexPath.row -1]).telNum = contactTelNum;
                };
                
                ((SWNewMarketTelNumCell *)cell).contactNameChangedBlock = ^(NSString *contactName) {
                    StrongObj(self);
                    ((SWMarketContact *)self.marketItem.telNums[indexPath.row -1]).name = contactName;
                };
                
                ((SWNewMarketTelNumCell *)cell).contactDelBlock = ^{
                    StrongObj(self);
                    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除联系人?" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.marketItem.telNums removeObjectAtIndex:indexPath.row - 1];
                        [self.marketInfoTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                    }];
                    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"容我三思" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alertView addAction:cancleAction];
                    [alertView addAction:okAction];
                    [self presentViewController:alertView animated:YES completion:^{
                        
                    }];
                };
                
                [cell setEditing:YES];
            }
        }
            break;
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:MARKET_CATEGORY_CELL_IDENTIFIER];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MARKET_CATEGORY_CELL_IDENTIFIER];
            }
            cell.textLabel.text = @"分类";
            cell.textLabel.textColor = SW_TAOBAO_BLACK;
            cell.textLabel.font = SW_DEFAULT_FONT_BOLD;
            cell.detailTextLabel.text = self.marketItem.marketCategory.categoryName;
            cell.detailTextLabel.font = SW_DEFAULT_FONT;
            cell.detailTextLabel.textColor = SW_TAOBAO_BLACK;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

#pragma mark - UI Response
- (void)okBtnClicked:(UIButton *)button {
    [self.view endEditing:YES];
    // 先检查商家基本信息是否完整
    
    // 检查商家名称是否为空
    if (self.marketItem.marketName == nil || [self.marketItem.marketName isEqualToString:@""]) {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"请填写商家名称" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertView addAction:okAction];
        [self presentViewController:alertView animated:YES completion:^{
            
        }];
        return;
    }
    
    // 检查联系人是否为空
    if (self.marketItem.telNums.count == 0) {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"请至少添加一个联系人" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertView addAction:okAction];
        [self presentViewController:alertView animated:YES completion:^{
            
        }];
        return;
    }
    
    // 检查联系人信息是否完整
    BOOL haveDefContact = NO;
    for (SWMarketContact *contact in self.marketItem.telNums) {
        if (contact.name == nil || [contact.name isEqualToString:@""]) {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"联系人姓名不能为空" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertView addAction:okAction];
            [self presentViewController:alertView animated:YES completion:^{
                
            }];
            return;
        }
        if (contact.telNum == nil || [contact.telNum isEqualToString:@""]) {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"联系电话不能为空" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertView addAction:okAction];
            [self presentViewController:alertView animated:YES completion:^{
                
            }];
            return;
        }
        if (contact.isDefaultContact) {
            haveDefContact = YES;
        }
    }
    
    if (!haveDefContact) {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"请至少设置一个默认联系人" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertView addAction:okAction];
        [self presentViewController:alertView animated:YES completion:^{
            
        }];
        return;
    }
    
    [SWMarketStorage insertMarket:self.marketItem];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelBtnClicked:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
