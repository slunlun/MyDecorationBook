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

static NSString *TEL_CELL_IDENTIFIER = @"TEL_CELL_IDENTIFIER";
static NSString *MARKET_CONTACT_HEADER_VIEW_IDENTIFIER = @"MARKET_CONTACT_HEADER_VIEW_IDENTIFIER";
static NSString *MARKET_NAME_CELL_IDENTIFIER = @"MARKET_NAME_CELL_IDENTIFIER";
static NSString *MARKET_CATEGORY_CELL_IDENTIFIER = @"MARKET_CATEGORY_CELL_IDENTIFIER";

@interface SWMarketViewController () <UITableViewDelegate, UITableViewDataSource, SWPickerViewDelegate>
@property(nonatomic, strong) UITableView *marketInfoTableView;
@property(nonatomic, assign) NSInteger numOfTels;
@property(nonatomic, strong) SWPickerView *pickerView;
@property(nonatomic, strong) UIView *coverView;
@end

@implementation SWMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    _marketInfoTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _numOfTels = 4;
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Notification
- (void)registerNotification {
    
}

- (void)keyboardWillShow:(NSNotification *)notificaiton {
    NSIndexPath *selIndex = [self.marketInfoTableView indexPathForSelectedRow];
    NSLog(@"%@", selIndex);
    NSDictionary *info = notificaiton.userInfo;
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.marketInfoTableView.contentInset = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
    
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    self.marketInfoTableView.contentInset = UIEdgeInsetsZero;
}

#pragma mark - SWPickerViewDelegate
- (NSInteger)SWPickerView:(SWPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}
- (NSString *)SWPickerView:(SWPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return @[@"瓷砖", @"油漆", @"五金"][row];
}

- (NSInteger)numberOfComponentsInSWPickerView:(SWPickerView *)pickerView {
    return 1;
}

- (void)SWPickerView:(SWPickerView *)pickerView didClickOKForRow:(NSInteger)row forComponent:(NSInteger)component {
    
}
- (void)cancelSelectInSWPickerView:(SWPickerView *)pickerView {
    
}

- (nullable NSAttributedString *)SWPickerView:(SWPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = @[@"瓷砖", @"油漆", @"五金"][row];
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc]initWithString:title];
    [AttributedString addAttributes:@{NSFontAttributeName:SW_DEFAULT_SUPER_MIN_FONT, NSForegroundColorAttributeName:SW_TAOBAO_BLACK} range:NSMakeRange(0, [AttributedString  length])];
    return AttributedString;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
            return _numOfTels;
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
    switch (indexPath.section) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:MARKET_NAME_CELL_IDENTIFIER];
        }
            break;
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:TEL_CELL_IDENTIFIER];
            if (indexPath.row == 0) {
                SWMarketContact *contact = [[SWMarketContact alloc] init];
                contact.name = @"纪勇";
                contact.telNum = @"13748503749";
                ((SWNewMarketTelNumCell *)cell).marketContact = contact;
//                ((SWNewMarketTelNumCell *)cell).contactNameTextField.delegate = self;
//                ((SWNewMarketTelNumCell *)cell).telNumTextField.delegate = self;
            }else if(indexPath.row == 2) {
                SWMarketContact *contact = [[SWMarketContact alloc] init];
                contact.name = @"毅力张冰";
                contact.telNum = @"13345456349";
                contact.defaultContact = YES;
                ((SWNewMarketTelNumCell *)cell).marketContact = contact;
            }
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
                cell.detailTextLabel.text = @"请选择";
                cell.detailTextLabel.font = SW_DEFAULT_MIN_FONT;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
               
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
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
                ++_numOfTels;
                [self.marketInfoTableView endUpdates];
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


@end
