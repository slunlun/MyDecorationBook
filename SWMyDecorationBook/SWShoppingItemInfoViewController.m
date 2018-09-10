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
#import "SWDef.h"
#import "SWShoppingItem+CoreDataClass.h"
#import "SWProductPhoto.h"
#import "SWProductItemStorage.h"
#import "TZImagePickerController.h"
#import "SWPriceUnitStorage.h"
#import "SWPickerView.h"
#import "UIImage+SWImageExt.h"
#import "SWCommonUtils.h"

static NSString *PHOTO_CELL_IDENTIFY = @"PHOTO_CELL_IDENTIFY";
static NSString *PRICE_CELL_IDENTIFY = @"PRICE_CELL_IDENTIFY";
static NSString *REMARK_CELL_IDENTIFY = @"REMARK_CELL_IDENTIFY";
static NSString *NAME_CELL_IDENTIFY = @"NAME_CELL_IDENTIFY";

@interface SWShoppingItemInfoViewController ()<UITableViewDelegate, UITableViewDataSource, SWPickerViewDelegate>
@property(nonatomic, strong) UITableView *shoppingItemTableView;
@property(nonatomic, strong) UIButton *okBtn;
@property(nonatomic, strong) UIButton *cancelBtn;
@property(nonatomic, strong) NSArray *itemUnits;
@property(nonatomic, strong) NSMutableArray *photosArray;
@property(nonatomic, strong) SWItemUnit *curItemUnit;
@end

@implementation SWShoppingItemInfoViewController

- (instancetype)initWithProductItem:(SWProductItem *)productItem inMarket:(SWMarketItem *)market {
    if (self = [super init]) {
        _shoppingItem = productItem;
        _marketItem = market;
        _itemUnits = [SWPriceUnitStorage allPriceUnit];
        _curItemUnit = [_itemUnits firstObject];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self registerNotification];
    _shoppingItemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [_shoppingItemTableView registerClass:[SWShoppingItemPhotoCell class] forCellReuseIdentifier:PHOTO_CELL_IDENTIFY];
    [_shoppingItemTableView registerClass:[SWShoppingItemPriceCell class] forCellReuseIdentifier:PRICE_CELL_IDENTIFY];
    [_shoppingItemTableView registerClass:[SWShoppingItemRemarkCell class] forCellReuseIdentifier:REMARK_CELL_IDENTIFY];
    [_shoppingItemTableView registerClass:[SWMarketNameCell class] forCellReuseIdentifier:NAME_CELL_IDENTIFY];
    _shoppingItemTableView.tableFooterView = [[UIView alloc] init];
    _shoppingItemTableView.showsVerticalScrollIndicator = NO;
    _shoppingItemTableView.showsHorizontalScrollIndicator = NO;
    _shoppingItemTableView.dataSource = self;
    _shoppingItemTableView.delegate = self;
    
    // 默认初始化当前的shoppingItem
    if (_shoppingItem == nil) {
        _shoppingItem = [[SWProductItem alloc] init];
        _shoppingItem.itemUnit = self.curItemUnit;
    }else {
        self.curItemUnit = _shoppingItem.itemUnit;
    }
    
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Notification
- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notificaiton {
    NSDictionary *info = notificaiton.userInfo;
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.shoppingItemTableView.contentInset = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
    });
    
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    self.shoppingItemTableView.contentInset = UIEdgeInsetsZero;
}

#pragma mark - Set/Get
- (void)setShoppingItem:(SWProductItem *)shoppingItem {
    _shoppingItem = shoppingItem;
    [self.photosArray addObjectsFromArray:_shoppingItem.productPhotos];
    [self.shoppingItemTableView reloadData];
}

- (NSMutableArray *)photosArray {
    if (_photosArray == nil) {
        _photosArray = [[NSMutableArray alloc] init];
    }
    return _photosArray;
}

#pragma mark - Common init
- (void)commonInit {
    self.navigationItem.title = @"商品信息";
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    [bkView addSubview:_shoppingItemTableView];
    [_shoppingItemTableView mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.topMargin.equalTo(self.shoppingItemTableView.mas_bottom).offset(SW_MARGIN);
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
        make.topMargin.equalTo(self.shoppingItemTableView.mas_bottom).offset(SW_MARGIN);
        make.bottomMargin.equalTo(bkView.mas_bottom).offset(-SW_MARGIN);
        make.rightMargin.equalTo(bkView.mas_right).offset(-SW_CELL_LEFT_MARGIN);
    }];
    
   
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    WeakObj(self);
    switch (indexPath.row) {
        case 0:{
            cell = [tableView dequeueReusableCellWithIdentifier:NAME_CELL_IDENTIFY];
            ((SWMarketNameCell *)cell).titleLab.text = @"商品";
            if (self.shoppingItem.productName) {
                ((SWMarketNameCell *)cell).marketNameTextField.text = self.shoppingItem.productName;
            }
            ((SWMarketNameCell *)cell).finishBlock = ^(NSString *inputName) {
                StrongObj(self);
                self.shoppingItem.productName = inputName;
            };
        }
            break;
        case 1:{ // 商品单价
            cell = [tableView dequeueReusableCellWithIdentifier:PRICE_CELL_IDENTIFY];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            ((SWShoppingItemPriceCell *)cell).productItem = self.shoppingItem;
            ((SWShoppingItemPriceCell *)cell).priceChangeBlock = ^(NSString *price) {
                StrongObj(self);
                self.shoppingItem.price = price.floatValue;
            };
        }
            break;
        case 2: { // 商品备注
            cell = [tableView dequeueReusableCellWithIdentifier:REMARK_CELL_IDENTIFY];
            ((SWShoppingItemRemarkCell *)cell).productItem = self.shoppingItem;
            ((SWShoppingItemRemarkCell *)cell).shoppingItemRemarkChange = ^(NSString *remark) {
                StrongObj(self);
                self.shoppingItem.productRemark = remark;
            };
        }
            break;
        case 3: { // 商品照片
            cell = [tableView dequeueReusableCellWithIdentifier:PHOTO_CELL_IDENTIFY];
            if (self.shoppingItem.productPhotos) {
                NSMutableArray *photos = [[NSMutableArray alloc] init];
                for (SWProductPhoto *productPhtot in self.shoppingItem.productPhotos) {
                    [photos addObject:productPhtot];
                }
                ((SWShoppingItemPhotoCell *)cell).photos = photos;
            }
            ((SWShoppingItemPhotoCell *)cell).takeNewPhoto = ^{
                StrongObj(self);
                if (self) {
                    [self scanNewPhoto];
                }
            };
            
            ((SWShoppingItemPhotoCell *)cell).photoCellClicked = ^(NSInteger index) {
                StrongObj(self);
                if (self) {
                    [self glaceShopItemPhoto:index];
                }
            };
            
            ((SWShoppingItemPhotoCell *)cell).delPhoto = ^(NSInteger index) {
                StrongObj(self);
                [self.shoppingItem.productPhotos removeObjectAtIndex:index];
                [self.shoppingItemTableView reloadData];
            };
            
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
    if (indexPath.row == 2) { // 商品备注
        return 180;
    }
    
    if (indexPath.row == 3)  { // 商品图片
        return 120;
    }
    return SW_CELL_DEFAULT_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) { // 商品单位
        [self.view endEditing:YES];
        SWPickerView *pickerView = [[SWPickerView alloc] initWithTitle:@"商品单位"];
        pickerView.delegate = self;
        UIView *mainWindow = [UIApplication sharedApplication].delegate.window;
        [pickerView attachSWPickerViewInView:mainWindow];
        [pickerView showPickerView];
    }
}

#pragma mark - SWPickerViewDelegate
- (NSInteger)SWPickerView:(SWPickerView *_Nonnull)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.itemUnits.count;
}
- (NSString *_Nonnull)SWPickerView:(SWPickerView *_Nonnull)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    SWItemUnit *itemUnit = self.itemUnits[row];
    return itemUnit.unitTitle;
}

- (void)SWPickerView:(SWPickerView *_Nonnull)pickerView didClickOKForRow:(NSInteger)row forComponent:(NSInteger)component {
    self.curItemUnit = self.itemUnits[row];
    self.shoppingItem.itemUnit = self.curItemUnit;
    [self.shoppingItemTableView reloadData];
}

#pragma mark - UI Response
- (void)okBtnClicked:(UIButton *)btn {
    // 检查商品名称否完整
    if ([self.shoppingItem.productName isEqualToString:@""] || self.shoppingItem.productName == nil) {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"请填写商品名称" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertView addAction:okAction];
        [self presentViewController:alertView animated:YES completion:^{
            
        }];
        return;
    }
    
    // 检查商品价格是否完整
    if (self.shoppingItem.price <=0.0f) {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"请输入正确的价格" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertView addAction:okAction];
        [self presentViewController:alertView animated:YES completion:^{
            
        }];
        return;
    }
    
    self.shoppingItem.itemUnit = self.curItemUnit;
    [SWProductItemStorage insertProductItem:self.shoppingItem toMarket:self.marketItem];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelBtnClicked:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scanNewPhoto {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    WeakObj(self);
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        StrongObj(self);
        for (UIImage *photo in photos) {
            UIImage *compressImg = [photo scaleImagetoSize:CGSizeMake(140, 140)];
            SWProductPhoto *productPhoto = [[SWProductPhoto alloc] initWithImage:compressImg];
            [self.shoppingItem.productPhotos addObject:productPhoto];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                // 将原始图片存储在本地
                NSData *imageData = UIImagePNGRepresentation(photo);
                [SWCommonUtils saveFile:imageData toDocumentFolder:productPhoto.itemID];
            });
        }
        
        [self.shoppingItemTableView reloadData];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)glaceShopItemPhoto:(NSInteger)beginIndex {
    
}

@end
