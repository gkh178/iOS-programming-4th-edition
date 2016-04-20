//
//  AppDelegate.m
//  Hypnosister
//
//  Created by gankaihua on 15/12/17.
//  Copyright © 2015年 gankaihua. All rights reserved.
//

#import "AppDelegate.h"
#import "BNRHypnosisView.h"

@interface AppDelegate () <UIScrollViewDelegate> //遵守UIScrollViewDelegate协议才能对UIScrollView对象进行设置委托
@property (nonatomic, strong) BNRHypnosisView *thirdBNRView;//用来保存缩放视图用

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
    [scrollView setPagingEnabled:NO];//翻页时不能自动选择其中一页显示
    [self.window addSubview:scrollView];//添加scrollView为self.window的子view
    
    /*
    //创建一个超大尺寸bigRect大小的BNRHypnosisView对象
    BNRHypnosisView *hypnosisView = [[BNRHypnosisView alloc]initWithFrame:bigRect];
    [scrollView addSubview:hypnosisView];//添加hypnosisView对象为scrollView的子view
     */
    
    //创建一个大小与屏幕相同的BNRHypnosisView对象并使其为scrollView的子view
    BNRHypnosisView *hypnosisView1 = [[BNRHypnosisView alloc]initWithFrame:screenRect];
    [scrollView addSubview:hypnosisView1];
    
    screenRect.origin.x += screenRect.size.width;
    _thirdBNRView = [[BNRHypnosisView alloc]initWithFrame:screenRect];
    [scrollView addSubview:_thirdBNRView];
    
    scrollView.minimumZoomScale = 1.0;
    scrollView.maximumZoomScale = 2.0;//最大缩放比例为4倍  2*2倍
    
    CGRect scrollRect = bigRect;
    scrollRect.size.width *= 4;
    scrollView.contentSize = scrollRect.size;//设置scrollView的镜头取景范围为scrollRect的尺寸
    
    //设置UIScrollView对象的delegate为本对象
    scrollView.delegate = self;
    
    //将self.window的根视图控制器设置一个默认的UIViewController对象
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view = scrollView;
    self.window.rootViewController = vc;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

//重写继承自UIScrollViewDelegate协议的viewForZoomingInScrollView:方法，该方法实现ScrollView对象的捏合和缩放
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _thirdBNRView;
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
