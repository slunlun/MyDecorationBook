//
//  SWRedViewController.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/25/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import "SWShoppingItemHomePageVC.h"
#import "Masonry.h"
#import "SWProductTableViewCell.h"

@interface SWShoppingItemHomePageVC () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UIView *dragMoveView;
@property(nonatomic, assign) CGPoint preTranslation;


@property(nonatomic, strong) UITableView *shoppingItemListTableView;
@end

@implementation SWShoppingItemHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self commitInit];
}

- (void)commitInit{
    _shoppingItemListTableView = [[UITableView alloc] init];
    _shoppingItemListTableView.dataSource = self;
    _shoppingItemListTableView.delegate = self;
    [_shoppingItemListTableView registerClass:[SWProductTableViewCell class] forCellReuseIdentifier:@"PRODUCT_CELL"];
    [self.view addSubview:_shoppingItemListTableView];

    [_shoppingItemListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.mas_topLayoutGuideBottom);
        }
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
        }
    }];
    
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SWProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PRODUCT_CELL"];
    SWProductItem *productItem = [[SWProductItem alloc] init];
    productItem.productName = @"AE-12";
    productItem.price = indexPath.row;
    productItem.productPictures = [NSArray new];
    cell.productItem = productItem;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Press tableview %@", indexPath);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)longPressed:(UILongPressGestureRecognizer *)longPressGesture
{
    CGRect showFrame = [longPressGesture.view convertRect:longPressGesture.view.frame toView:[UIApplication sharedApplication].delegate.window];
    
    
    [UIView animateWithDuration:1.0f animations:^{
        longPressGesture.view.frame = CGRectMake(showFrame.origin.x -  5, showFrame.origin.y - 5, showFrame.size.width + 10, showFrame.size.height + 10);
    }];
}

- (void)panMoved:(UIPanGestureRecognizer *)panGesture{
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.preTranslation = [panGesture translationInView:self.view];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            //  panGesture f
            CGPoint translation = [panGesture translationInView:self.view];
            NSLog(@"X: %lf   Y:%lf", translation.x, translation.y);
            CGPoint newLocationPoint = CGPointMake(translation.x - self.preTranslation.x, translation.y - self.preTranslation.y);
            panGesture.view.frame = CGRectMake(panGesture.view.frame.origin.x, panGesture.view.frame.origin.y + newLocationPoint.y, panGesture.view.frame.size.width, panGesture.view.frame.size.height);
            self.preTranslation = translation;
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            NSLog(@"Finishedddddd");
        }
            break;
        default:
            break;
    }
}


- (void)dragViewPan:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.preTranslation = [panGesture translationInView:self.view];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
          //  panGesture f
            CGPoint translation = [panGesture translationInView:self.view];
            NSLog(@"X: %lf   Y:%lf", translation.x, translation.y);
            CGPoint newLocationPoint = CGPointMake(translation.x - self.preTranslation.x, translation.y - self.preTranslation.y);
            _dragMoveView.frame = CGRectMake(_dragMoveView.frame.origin.x + newLocationPoint.x, _dragMoveView.frame.origin.y + newLocationPoint.y, _dragMoveView.frame.size.width, _dragMoveView.frame.size.height);
            self.preTranslation = translation;
            
         //   _dragMoveView convertRect:<#(CGRect)#> toView:<#(nullable UIView *)#>
        }
        break;
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
        {
            NSLog(@"Finishedddddd");
        }
            break;
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
