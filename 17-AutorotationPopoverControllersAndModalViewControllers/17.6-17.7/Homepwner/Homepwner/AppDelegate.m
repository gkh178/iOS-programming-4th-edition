//
//  AppDelegate.m
//  Homepwner
//
//  Created by gankaihua on 16/2/27.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import "AppDelegate.h"
#import "BNRItemsTableViewController.h"
#import "BNRItemStore.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //创建BNRItemsTableViewController对象
    BNRItemsTableViewController *itemsTableViewController = [[BNRItemsTableViewController alloc]init];
    
    //创建UINavigationController对象，它的rootViewController为itemsTableViewController，也即栈的最底层为itemsTableViewController
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:itemsTableViewController];
    
    self.window.rootViewController = navigationController;//self.window的根视图控制器为navigationController
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //按下home键或者有来电时应用进入后台状态,然后保存BNRItems到归档路径中
    BOOL success = [[BNRItemStore sharedStore]saveChanges];
    if (success) {
        NSLog(@"Saved all of the BNRItems");
    }
    else {
        NSLog(@"Could not save any of the BNRItem");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
