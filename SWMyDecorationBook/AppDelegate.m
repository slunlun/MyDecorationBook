//
//  AppDelegate.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/20/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import "AppDelegate.h"
#import "SWLeftSlideCollectionViewController.h"
#import "SWUIDef.h"
#import "SWPriceUnitStorage.h"
#import "SWMarketCategoryStorage.h"
#import "MagicalRecord.h"
#import "SWMarketCategoryViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 设置UINavigationBar的背景图片
   // [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"Pi"] forBarMetrics:UIBarMetricsDefault];
    
    // 设置UINavigationBar的背景色 #F9ECE5 #E6E6E6
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#1E8BE8"]];
    // 设置UINavigationBar的字体颜色
    [UINavigationBar appearance].titleTextAttributes = @{NSFontAttributeName:SW_DEFAULT_FONT_SUPER_LARGE, NSForegroundColorAttributeName:[UIColor whiteColor]};
    // 设置UINavigationBar item颜色
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    
    // common tintColor
    [UILabel appearance].tintColor = SW_TAOBAO_BLACK;
    
    // setup MagicRecord
    NSURL* storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DB"];
    storeURL = [storeURL URLByAppendingPathComponent:@"myDecorationBook.sqlite"];
    NSLog(@"storeURL is %@", storeURL);
    //[MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelOff];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreAtURL:storeURL];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        // 添加初始数据 商品的单位
        SWItemUnit *gUnit = [[SWItemUnit alloc] initWithUnit:@"个"];
        SWItemUnit *kUnit = [[SWItemUnit alloc] initWithUnit:@"块"];
        SWItemUnit *pUnit = [[SWItemUnit alloc] initWithUnit:@"平"];
        SWItemUnit *mUnit = [[SWItemUnit alloc] initWithUnit:@"米"];
        SWItemUnit *zUnit = [[SWItemUnit alloc] initWithUnit:@"张"];
        SWItemUnit *bUnit = [[SWItemUnit alloc] initWithUnit:@"把"];
        
        [SWPriceUnitStorage insertPriceUnit:gUnit];
        [SWPriceUnitStorage insertPriceUnit:kUnit];
        [SWPriceUnitStorage insertPriceUnit:pUnit];
        [SWPriceUnitStorage insertPriceUnit:mUnit];
        [SWPriceUnitStorage insertPriceUnit:zUnit];
        [SWPriceUnitStorage insertPriceUnit:bUnit];
    
        // 添加初始数据 MarketCategory
        SWMarketCategory *cat1 = [[SWMarketCategory alloc] initWithCategoryName:@"瓷砖"];
        SWMarketCategory *cat2 = [[SWMarketCategory alloc] initWithCategoryName:@"橱柜"];
        SWMarketCategory *cat3 = [[SWMarketCategory alloc] initWithCategoryName:@"家具"];
        SWMarketCategory *cat4 = [[SWMarketCategory alloc] initWithCategoryName:@"石材"];
        SWMarketCategory *cat5 = [[SWMarketCategory alloc] initWithCategoryName:@"五金"];
        [SWMarketCategoryStorage insertMarketCategory:cat1];
        [SWMarketCategoryStorage insertMarketCategory:cat2];
        [SWMarketCategoryStorage insertMarketCategory:cat3];
        [SWMarketCategoryStorage insertMarketCategory:cat4];
        [SWMarketCategoryStorage insertMarketCategory:cat5];
        
    }else {
        NSLog(@"second launch");
        
    }
    
    // 设置初始的抽屉界面
    // root view
    SWShoppingItemHomePageVC *shoppingItemHomePageVC = [[SWShoppingItemHomePageVC alloc] init];
      UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:shoppingItemHomePageVC];
    SWMarketCategoryViewController *leftSlideVC = [[SWMarketCategoryViewController alloc] init];
//    SWLeftSlideCollectionViewController *leftSlideVC = [[SWLeftSlideCollectionViewController alloc] init];
    _drawerVC = [[SWDrawerViewController alloc] initWithCenterViewController:centerNav leftDrawerViewController:leftSlideVC];
    CGFloat leftSideWidth = self.window.frame.size.width * 0.8;
    _drawerVC.maximumLeftDrawerWidth = leftSideWidth; // 左侧栏的width
    leftSlideVC.delegate = _drawerVC;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setRootViewController:_drawerVC];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [MagicalRecord cleanUp];
}

- (NSURL*) applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
