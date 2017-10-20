//
//  SWRedViewController.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/25/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import "SWRedViewController.h"
#import "Masonry.h"
#import "SWProductTableViewCell.h"

@interface SWRedViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UIView *dragMoveView;
@property(nonatomic, assign) CGPoint preTranslation;

@property(nonatomic, strong) UIView *brownView;
@property(nonatomic, strong) UIView *whiteView;
@property(nonatomic, strong) UIView *yellowView;
@property(nonatomic, strong) UIView *purpleView;
@property(nonatomic, strong) UIView *blackView;
@property(nonatomic, strong) UITableView *testTableView;
@end

@implementation SWRedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
//    _dragMoveView = [[UIView alloc] initWithFrame:CGRectMake(40, 140, 80, 80)];
//    [self.view addSubview:_dragMoveView];
//    
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragViewPan:)];
//    [_dragMoveView addGestureRecognizer:panGesture];
//    _dragMoveView.backgroundColor = [UIColor brownColor];
//    
//    [[UIApplication sharedApplication].delegate.window addSubview:_dragMoveView];
    
    [self commitInit];
}

- (void)commitInit{
    _brownView = [[UIView alloc] init];
//    _brownView.backgroundColor = [UIColor brownColor];
//    [self.view addSubview:_brownView];
//    
//    _whiteView = [[UIView alloc] init];
//    _whiteView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:_whiteView];
//    
//    _yellowView = [[UIView alloc] init];
//    _yellowView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:_yellowView];
//    
//    _purpleView = [[UIView alloc] init];
//    _purpleView.backgroundColor = [UIColor purpleColor];
//    [self.view addSubview:_purpleView];
//    
//    _blackView = [[UIView alloc] init];
//    _blackView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:_blackView];
//    
//    [_brownView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@80);
//        make.top.equalTo(self.view).offset(80);
//        make.left.equalTo(self.view).offset(40);
//    }];
//    
//    [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@80);
//        make.top.equalTo(_brownView.mas_bottom);
//        make.left.equalTo(_brownView);
//    }];
//    
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
//    [_whiteView addGestureRecognizer:longPress];
//    
//    [_yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@80);
//        make.top.equalTo(_whiteView.mas_bottom);
//        make.left.equalTo(_whiteView);
//    }];
//    
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMoved:)];
//    [_yellowView addGestureRecognizer:panGesture];
//    
//    [_purpleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@80);
//        make.top.equalTo(_yellowView.mas_bottom);
//        make.left.equalTo(_yellowView);
//    }];
//    
//    [_blackView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@80);
//        make.top.equalTo(_purpleView.mas_bottom);
//        make.left.equalTo(_purpleView);
//    }];
    
    _testTableView = [[UITableView alloc] init];
    _testTableView.dataSource = self;
    _testTableView.delegate = self;
    [_testTableView registerClass:[SWProductTableViewCell class] forCellReuseIdentifier:@"PRODUCT_CELL"];
    [self.view addSubview:_testTableView];
    [_testTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_topMargin);
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
