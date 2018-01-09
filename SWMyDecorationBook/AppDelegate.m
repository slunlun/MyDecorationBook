//
//  AppDelegate.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/20/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import "AppDelegate.h"
#import "SWDragMoveTableViewController.h"
#import "SWLeftSlideCollectionViewController.h"
#import "SWUIDef.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UINavigationBar appearance].tintColor = SW_MAIN_BLUE_COLOR;
    [UILabel appearance].tintColor = SW_TAOBAO_BLACK;
    
    UIViewController *v1 = [[UIViewController alloc] init];
    v1.view.backgroundColor = [UIColor yellowColor];
    
    UIViewController *v2 = [[UIViewController alloc] init];
    v2.view.backgroundColor = [UIColor redColor];
 
//
//
//    UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:redVC];
//    UINavigationController *leftNav = [[UINavigationController alloc] initWithRootViewController:yellowVC];
    SWShoppingItemHomePageVC *shoppingItemHomePageVC = [[SWShoppingItemHomePageVC alloc] init];
      UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:shoppingItemHomePageVC];
    SWLeftSlideCollectionViewController *leftSlideVC = [[SWLeftSlideCollectionViewController alloc] init];
    _drawerVC = [[SWDrawerViewController alloc] initWithCenterViewController:centerNav leftDrawerViewController:leftSlideVC];
    _drawerVC.maximumLeftDrawerWidth = 90.0f;
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
