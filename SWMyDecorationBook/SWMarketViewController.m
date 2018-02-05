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

@interface SWMarketViewController () <UITableViewDelegate, UITableViewDataSource, SWPickerViewDelegate>
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
    [_marketInfoTableView registerClass:[SWMarketContactSectionHeaderView class]
     forHeaderFooterViewReuseIdentifier:MARKET_CONTACT_HEADER_VIEW_IDENTIFIER];
    [_marketInfoTableView registerClass:[SWMarketNameCell class] forCellReuseIdentifier:MARKET_NAME_CELL_IDENTIFIER];
    [self.view addSubview:_marketInfoTableView];
    
    [self registerNotification];
    [self commonInit];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Common init
- (void)commonInit {
    self.view.backgroundColor = SW_TAOBAO_BLACK;
    [_marketInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    [self.view addSubview:_okBtn];
    
    _cancelBtn = [[UIButton alloc] init];
    _cancelBtn.titleLabel.font = SW_DEFAULT_FONT;
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setBackgroundColor:SW_WARN_RED];
    _cancelBtn.layer.cornerRadius = SW_DEFAULT_CORNER_RADIOUS;
    _cancelBtn.clipsToBounds = YES;
    [self.view addSubview:_cancelBtn];
    
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo(self.view.mas_left).offset(SW_MARGIN);
        make.topMargin.equalTo(_marketInfoTableView.mas_bottom).offset(SW_MARGIN);
        make.bottomMargin.equalTo(self.view.mas_bottom).offset(-SW_MARGIN * 2);
        make.rightMargin.equalTo(self.view.mas_centerX).offset(-SW_MARGIN);
    }];
    
    [_okBtn addTarget:self action:@selector(okBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.rightMargin.equalTo(self.view.mas_right).offset(-SW_MARGIN);
        make.topMargin.equalTo(_marketInfoTableView.mas_bottom).offset(SW_MARGIN);
        make.bottomMargin.equalTo(self.view.mas_bottom).offset(-SW_MARGIN * 2);
        make.leftMargin.equalTo(self.view.mas_centerX).offset(SW_MARGIN);
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (indexPath.section == 2) { // select type
        SWPickerView *pickerView = [[SWPickerView alloc] init];
        [pickerView attachSWPickerViewInView:self.view];
        pickerView.delegate = self;
        [pickerView showPickerView];
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
            return self.marketItem.telNums.count;
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
            cell = [tableView dequeueReusableCellWithIdentifier:TEL_CELL_IDENTIFIER];
            SWMarketContact *contact = self.marketItem.telNums[indexPath.row];
            ((SWNewMarketTelNumCell *)cell).marketContact = contact;
            WeakObj(self);
            ((SWNewMarketTelNumCell *)cell).defaultContactSetBlock = ^(SWMarketContact *contact) {
                for (SWMarketContact *contact in self.marketItem.telNums) {
                    contact.defaultContact = NO;
                }
                ((SWMarketContact *)self.marketItem.telNums[indexPath.row]).defaultContact = YES;
                StrongObj(self);
                [self.marketInfoTableView reloadData];
            };
            
            ((SWNewMarketTelNumCell *)cell).contactTelNumChangedBlock = ^(NSString *contactTelNum) {
                StrongObj(self);
                ((SWMarketContact *)self.marketItem.telNums[indexPath.row]).telNum = contactTelNum;
                [self.marketInfoTableView reloadData];
            };
            
            ((SWNewMarketTelNumCell *)cell).contactNameChangedBlock = ^(NSString *contactName) {
                StrongObj(self);
                ((SWMarketContact *)self.marketItem.telNums[indexPath.row]).name = contactName;
                [self.marketInfoTableView reloadData];
            };
            [cell setEditing:YES];
        }
            break;
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:MARKET_CATEGORY_CELL_IDENTIFIER];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MARKET_CATEGORY_CELL_IDENTIFIER];
                cell.textLabel.text = @"分类";
                cell.textLabel.font = SW_DEFAULT_FONT;
                cell.detailTextLabel.text = self.marketItem.marketCategory.categoryName;
                cell.detailTextLabel.font = SW_DEFAULT_MIN_FONT;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
               
            }
        }
            break;
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView :(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete && indexPath.section == 1) {
        [self.marketItem.telNums removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        WeakObj(self);
        SWMarketContactSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MARKET_CONTACT_HEADER_VIEW_IDENTIFIER];
        headerView.addContactAction = ^{
            StrongObj(self);
            if (self) {
                NSInteger numOfRows = [self.marketInfoTableView numberOfRowsInSection:section];
                NSIndexPath *addIndex = [NSIndexPath indexPathForRow:numOfRows inSection:section];
                [self.marketInfoTableView beginUpdates];
                [self.marketInfoTableView insertRowsAtIndexPaths:@[addIndex] withRowAnimation:UITableViewRowAnimationBottom];
                // Add a new contact in testArray
                SWMarketContact *newContact = [[SWMarketContact alloc] init];
                [self.marketItem.telNums addObject:newContact];
                
                [self.marketInfoTableView endUpdates];
                if (self.isEditing) {
                    [self.view endEditing:YES];
                    UIEdgeInsets edge = self.marketInfoTableView.contentInset;
                    self.marketInfoTableView.contentInset = UIEdgeInsetsMake(edge.top, edge.left, edge.bottom + 40, edge.right);
                }
               
            }
        };
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return 0;
    }
    return 40;
}

-  (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return YES;
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

#pragma mark - UI Response
- (void)okBtnClicked:(UIButton *)button {
    [self.view endEditing:YES];
    [SWMarketStorage insertMarket:self.marketItem];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelBtnClicked:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
