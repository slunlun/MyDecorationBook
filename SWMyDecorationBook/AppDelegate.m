//
//  AppDelegate.m
//  SWMyDecorationBook
//
//  Created by Eren (Teng) Shi on 9/20/17.
//  Copyright © 2017 Eren. All rights reserved.
//

#import "AppDelegate.h"
#import "SWDragMoveTableViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    SWDragMoveTableViewCell *yellowCell = [[SWDragMoveTableViewCell alloc] init];
    yellowCell.title = @"yellow";
    yellowCell.backgroundColor = [UIColor yellowColor];

    SWDragMoveTableViewCell *redCell = [[SWDragMoveTableViewCell alloc] init];
    redCell.title = @"red";
    redCell.backgroundColor = [UIColor redColor];

    SWDragMoveTableViewCell *brownCell = [[SWDragMoveTableViewCell alloc] init];
    brownCell.title = @"brown";
    brownCell.backgroundColor = [UIColor brownColor];

    SWDragMoveTableViewCell *blackCell = [[SWDragMoveTableViewCell alloc] init];
    blackCell.title = @"black";
    blackCell.backgroundColor = [UIColor blackColor];

    SWDragMoveTableViewCell *orangeCell = [[SWDragMoveTableViewCell alloc] init];
    orangeCell.title = @"orange";
    orangeCell.backgroundColor = [UIColor orangeColor];
    
    SWDragMoveTableViewCell *yellowCell1 = [[SWDragMoveTableViewCell alloc] init];
    yellowCell1.title = @"yellow";
    yellowCell1.backgroundColor = [UIColor yellowColor];
    
    SWDragMoveTableViewCell *redCell1 = [[SWDragMoveTableViewCell alloc] init];
    redCell1.title = @"red";
    redCell1.backgroundColor = [UIColor redColor];
    
    SWDragMoveTableViewCell *brownCell1 = [[SWDragMoveTableViewCell alloc] init];
    brownCell1.title = @"brown";
    brownCell1.backgroundColor = [UIColor brownColor];
    
    SWDragMoveTableViewCell *blackCell1 = [[SWDragMoveTableViewCell alloc] init];
    blackCell1.title = @"black";
    blackCell1.backgroundColor = [UIColor blackColor];
    
    SWDragMoveTableViewCell *orangeCell1 = [[SWDragMoveTableViewCell alloc] init];
    orangeCell1.title = @"orange";
    orangeCell1.backgroundColor = [UIColor orangeColor];
    
    SWDragMoveTableViewCell *yellowCell2 = [[SWDragMoveTableViewCell alloc] init];
    yellowCell2.title = @"yellow";
    yellowCell2.backgroundColor = [UIColor yellowColor];
    
    SWDragMoveTableViewCell *redCell2 = [[SWDragMoveTableViewCell alloc] init];
    redCell2.title = @"red";
    redCell2.backgroundColor = [UIColor redColor];
    
    SWDragMoveTableViewCell *brownCell2 = [[SWDragMoveTableViewCell alloc] init];
    brownCell2.title = @"brown";
    brownCell2.backgroundColor = [UIColor brownColor];
    
    SWDragMoveTableViewCell *blackCell2 = [[SWDragMoveTableViewCell alloc] init];
    blackCell.title = @"black";
    blackCell.backgroundColor = [UIColor blackColor];
    
    SWDragMoveTableViewCell *orangeCell2 = [[SWDragMoveTableViewCell alloc] init];
    orangeCell.title = @"orange";
    orangeCell.backgroundColor = [UIColor orangeColor];
//
//
    SWYellowViewController *yellowVC = [[SWYellowViewController alloc] init];
    SWRedViewController *redVC = [[SWRedViewController alloc] init];
//
//
    UIViewController *v1 = [[UIViewController alloc] init];
    v1.view.backgroundColor = [UIColor yellowColor];
    
    UIViewController *v2 = [[UIViewController alloc] init];
    v2.view.backgroundColor = [UIColor redColor];
    NSArray *cellArray = @[yellowCell, redCell, brownCell, blackCell, orangeCell, yellowCell1, redCell1, brownCell1, blackCell1, orangeCell1, yellowCell2, redCell2, brownCell2, blackCell2, orangeCell2,];
//
     SWDragMoveTableViewController *dgMV = [[SWDragMoveTableViewController alloc] initWithTableViewCells:cellArray];
//
//
//    UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:redVC];
//    UINavigationController *leftNav = [[UINavigationController alloc] initWithRootViewController:yellowVC];
      UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:redVC];
    _drawerVC = [[SWDrawerViewController alloc] initWithCenterViewController:centerNav leftDrawerViewController:dgMV];
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
