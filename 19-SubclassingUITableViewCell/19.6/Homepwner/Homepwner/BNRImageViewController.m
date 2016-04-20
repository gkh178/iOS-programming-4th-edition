//
//  BNRImageViewController.m
//  Homepwner
//
//  Created by gankaihua on 16/3/5.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import "BNRImageViewController.h"

@interface BNRImageViewController () <UIScrollViewDelegate>
//@property(nonatomic, strong)UIImageView *imageView;
@end

@implementation BNRImageViewController


//重写自<UIScrollViewDelegate>的方法表示获得在scrollView中用来缩放的contentView
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView) {
        return (UIView *)[self.view.subviews firstObject];
    }
    return nil;
}

//加载需要显示的item的图
- (void)loadView {
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    self.view = scrollView;
    
    UIImageView *imageView = [[UIImageView alloc]init];
    [self.view addSubview:imageView];
    
    imageView.contentMode = UIViewContentModeCenter;//居中显示图片
    [imageView setCenter:CGPointMake(600/2, 600/2)];//imageView的中心点为popover的中心点
    
    scrollView.contentSize = imageView.frame.size;//scrollView的取景范围为imageView的frame
    scrollView.maximumZoomScale = 2.0;//scrollView的取景范围的最大缩放倍数为2.0
    scrollView.minimumZoomScale = 0.2;//scrollView的取景范围的最小缩放倍数为0.2
    
    scrollView.delegate = self;//代理为自己，才能对scrollView做缩放操作
    scrollView.scrollEnabled = NO;//设为NO，不出现滚动条
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //必须将view转换为UIImageView对象，以便向其发送setImage:消息
    //UIImageView *imageView = (UIImageView *)self.view;
    //imageView.image = self.image;//将需要显示的图片作为imageView的image
    UIImageView *imageView = (UIImageView *)[self.view.subviews firstObject];
    imageView.image = self.image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end


