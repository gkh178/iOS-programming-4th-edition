//
//  BNRWebViewController.m
//  Nerdfeed
//
//  Created by gankaihua on 16/3/7.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import "BNRWebViewController.h"

@interface BNRWebViewController () 
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


@end
