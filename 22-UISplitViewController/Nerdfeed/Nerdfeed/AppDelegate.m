//
//  AppDelegate.m
//  Nerdfeed
//
//  Created by gankaihua on 16/3/7.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import "AppDelegate.h"
#import "BNRCoursesViewController.h"
#import "BNRWebViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    BNRCoursesViewController *lvc = [[BNRCoursesViewController alloc]init];
    
    //创建一个UINavigationController，将lvc作为它的根控制器
    UINavigationController *masterNav = [[UINavigationController alloc]initWithRootViewController:lvc];
    
    //创建一个BNRWebViewController，将其作为lvc的webViewController属性
    BNRWebViewController *wvc = [[BNRWebViewController alloc]init];
    lvc.webViewController = wvc;
    
    //如果设备是iPad
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        //创建一个UINavigationController对象，detailNav的根视图是wvc
        UINavigationController *detailNav = [[UINavigationController alloc]initWithRootViewController:wvc];
        
        //创建一个UISplitViewController，将masterNav和detailNav加入进去作为主从控制器
        UISplitViewController *splitViewController = [[UISplitViewController alloc]init];
        splitViewController.viewControllers = @[masterNav, detailNav];
        
        //一定要设置UISplitViewController对象的委托，这里设置从控制器是其委托，一般UISplitViewController的委托可是是从也可是辅。
        splitViewController.delegate = wvc;
        
        //将splitViewController作为self.window的根视图
        self.window.rootViewController = splitViewController;
    }
    //不是iPad用
    else {
        self.window.rootViewController = masterNav;
    }
    
    
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
