//
//  BNRWebViewController.m
//  Nerdfeed
//
//  Created by gankaihua on 16/3/7.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import "BNRWebViewController.h"

@interface BNRWebViewController () <UISplitViewControllerDelegate>
@end

@implementation BNRWebViewController 

- (instancetype)init {
    self = [super init];
    
    if (self) {
    }
    
    return self;
}

- (void)loadView {
    UIWebView *webView = [[UIWebView alloc]init];
    webView.scalesPageToFit = YES;//缩放页面到适合webView
    self.view = webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    if (self) {
        [super viewWillAppear:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//给URL属性赋值，赋值成功后用新URL加载页面
- (void)setURL:(NSURL *)URL {
    _URL = URL;
    
    //设置新URL后，webView需要重新加载新URL对应的NSURLRequest
    if (_URL) {
        NSURLRequest *req =[NSURLRequest requestWithURL:_URL];
        [(UIWebView *)self.view loadRequest:req];
    }
}

#pragma mark - <UISplitViewControllerDelegate> Methods

//iPad切换到竖屏时，隐藏主视图，得到一个UIBarButtonItem对象
- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc {
    
    //设置得到的UIBarButtonItem对象的标题，标题为nil时该button不会显示
    barButtonItem.title = @"Courses";
    //将barButton添作wvc的导航栏的左侧
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

//iPad切换为横屏时，显示主视图，会传入一个UIBarButton *参数
- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    //如果传入的UIBarButtonItem是wvc的导航栏的左项，则将其取消
    if (barButtonItem == self.navigationItem.leftBarButtonItem) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}


@end
