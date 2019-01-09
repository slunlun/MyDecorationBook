//
//  SKSettingPageViewController.m
//  SKIncomeTaxCalculator
//
//  Created by Stepanoval (Xinxin) Huang on 2018/12/29.
//  Copyright © 2018 skyline. All rights reserved.
//

#import "SKSettingPageViewController.h"
#import "Masonry.h"

@interface SKSettingPageViewController ()

@property (nonatomic,strong) UIImageView *back;

@end

@implementation SKSettingPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imgBack = [[UIImageView alloc] init];
    imgBack.contentMode = UIViewContentModeScaleAspectFit;
    [imgBack setImage:[UIImage imageNamed:@"tax"]];
    self.back = imgBack;
    [self.view addSubview:imgBack];
    
    [imgBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // Do any additional setup after loading the view.
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
