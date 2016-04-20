//
//  BNRWebViewController.m
//  Nerdfeed
//
//  Created by gankaihua on 16/3/7.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import "BNRWebViewController.h"

@interface BNRWebViewController () <UIWebViewDelegate>
//@property (nonatomic, strong) UIToolbar* toolBar;
@property (nonatomic, strong) UIBarButtonItem *goBackButton;
@property (nonatomic, strong) UIBarButtonItem *goForwardButton;

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
    
    webView.delegate = self;//webView的委托为本控制器
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    if (self) {
        [super viewWillAppear:YES];
        
        //按下goBackButton触发goBack方法，goBack方法是UIWebView自带的方法
        self.goBackButton = [[UIBarButtonItem alloc]initWithTitle:@"Go Back" style:UIBarButtonItemStylePlain
                                                        target:self.view action:@selector(goBack)];
        //按下goForwardButton触发goForward方法，goFoward方法是UIWebView自带的方法
        self.goForwardButton = [[UIBarButtonItem alloc]initWithTitle:@"Go Forward" style:UIBarButtonItemStylePlain
                                                           target:self.view action:@selector(goForward)];
        //设置导航栏的右边的UIBarButtonItems
        self.navigationItem.rightBarButtonItems = @[self.goBackButton, self.goForwardButton];
        
        //更新显示goBackButton和goForwardButton的状态
        [self updateWebViewButtons];
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

//更新显示self.view上面的Buttons的状态
- (void)updateWebViewButtons {
    UIWebView *webView = (UIWebView *)self.view;
    self.goBackButton.enabled = webView.canGoBack;//goBackButton能否可用跟canGoBack值一样
    self.goForwardButton.enabled = webView.canGoForward;
}

#pragma  - <UIWebViewDelegate> methods
//加载webView完成后
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self updateWebViewButtons];
}

//加载webView失败时
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self updateWebViewButtons];
}

@end
