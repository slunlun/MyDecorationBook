//
//  SKHomeNavigationViewController.m
//  SKIncomeTaxCalculator
//
//  Created by Stepanoval (Xinxin) Huang on 2018/12/25.
//  Copyright © 2018 skyline. All rights reserved.
//

#import "SKHomeNavigationViewController.h"

@interface SKHomeNavigationViewController ()<UINavigationControllerDelegate>

@end

@implementation SKHomeNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.tintColor = [UIColor blackColor];
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:16],
                                               NSForegroundColorAttributeName : [UIColor darkGrayColor]};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    //    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc {
    NSLog(@"NXHomeNavigationViewController:dealloc");
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
