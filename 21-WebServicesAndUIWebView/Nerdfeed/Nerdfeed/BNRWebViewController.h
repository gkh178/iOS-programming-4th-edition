//
//  BNRWebViewController.h
//  Nerdfeed
//
//  Created by gankaihua on 16/3/7.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNRWebViewController : UIViewController
@property (nonatomic) NSURL *URL;//被self用来loadRequest:的URL，加载对应的URL的URLRequest的页面

@end
