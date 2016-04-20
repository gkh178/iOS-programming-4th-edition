//
//  AppDelegate.m
//  HypnoNerd
//
//  Created by gankaihua on 15/12/24.
//  Copyright © 2015年 gankaihua. All rights reserved.
//

#import "AppDelegate.h"
#import "BNRHypnosisViewController.h"
#import "BNRReminderViewController.h"
#import "BNRViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //创建一个视图控制器hvc，其view属性刚开始为nil
    BNRHypnosisViewController *hvc = [[BNRHypnosisViewController alloc]init];
    
    //获取指向NSBundle对象的指针，该指针指向本应用的主程序包
    NSBundle *appBundle = [NSBundle mainBundle];
    //在主程序包中搜索指定文件名的nib文件用来初始化BNRReminderViewController对象
    BNRReminderViewController *rvc = [[BNRReminderViewController alloc]initWithNibName:@"BNRReminderViewController" bundle:appBundle];
    
    //在主程序包中搜索用直BNRViewController.nib初始化的BNRViewController对象
    BNRViewController *vc = [[BNRViewController alloc]initWithNibName:@"BNRViewController" bundle:appBundle];
    
    //创建一个UITabBarController对象用来保存hvc和rvc
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    tabBarController.viewControllers = @[hvc, rvc, vc];
    
    self.window.rootViewController = tabBarController;
    
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
