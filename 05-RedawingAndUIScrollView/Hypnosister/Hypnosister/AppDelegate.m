//
//  AppDelegate.m
//  Hypnosister
//
//  Created by gankaihua on 15/12/17.
//  Copyright © 2015年 gankaihua. All rights reserved.
//

#import "AppDelegate.h"
#import "BNRHypnosisView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //创建两个CGRect结构分别作为UIScrollView对象的和BNRHyponsisiView对象的初始化frame
    CGRect screenRect = self.window.bounds;
    CGRect bigRect = screenRect;
    bigRect.size.width *= 2.0;
   // bigRect.size.height *= 2.0;
    
    //创建一个UIScrollView对象将其尺寸设置为screenRect大小
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:screenRect];
    [scrollView setPagingEnabled:YES];//翻页时能自动选择其中一页显示
    [self.window addSubview:scrollView];//添加scrollView为self.window的子view
    
    /*
    //创建一个超大尺寸bigRect大小的BNRHypnosisView对象
    BNRHypnosisView *hypnosisView = [[BNRHypnosisView alloc]initWithFrame:bigRect];
    [scrollView addSubview:hypnosisView];//添加hypnosisView对象为scrollView的子view
     */
    
    //创建一个大小与屏幕相同的BNRHypnosisView对象并使其为scrollView的子view
    BNRHypnosisView *hypnosisView1 = [[BNRHypnosisView alloc]initWithFrame:screenRect];
    [scrollView addSubview:hypnosisView1];
    
    //创建另一个大小与屏幕相同的BNRHypnosisView对象并使其为scrollView的子view
    screenRect.origin.x += screenRect.size.width;
    BNRHypnosisView *hypnonsisView2 = [[BNRHypnosisView alloc]initWithFrame:screenRect];
    [scrollView addSubview:hypnonsisView2];
    
    //设置UIScrollView对象的取景范围
    scrollView.contentSize = bigRect.size;//设置取景范围为hypnosisView的尺寸
    
    //将self.window的根视图控制器设置一个默认的UIViewController对象
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view = scrollView;
    self.window.rootViewController = vc;
    
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
