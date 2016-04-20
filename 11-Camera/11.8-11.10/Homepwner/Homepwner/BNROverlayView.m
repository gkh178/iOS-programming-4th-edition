//
//  BNROverlayView.m
//  Homepwner
//
//  Created by gankaihua on 16/2/28.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import "BNROverlayView.h"

@interface BNROverlayView ()

@end

@implementation BNROverlayView

//用frame初始化BNROverlayView对象
- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;//不透明度为NO
        self.backgroundColor = [UIColor clearColor];//背景为透明
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGRect bounds = self.bounds;
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    float radius = hypot(bounds.size.width, bounds.size.height) / 10.0;
    
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path addArcWithCenter:center radius:radius startAngle:0 endAngle:(M_PI * 2) clockwise:YES];
    [path moveToPoint:CGPointMake(center.x, center.y-radius-15)];
    [path addLineToPoint:CGPointMake(center.x, center.y-radius+15)];
    [path moveToPoint:CGPointMake(center.x, center.y+radius-15)];
    [path addLineToPoint:CGPointMake(center.x, center.y+radius+15)];
    [path moveToPoint:CGPointMake(center.x-radius-15, center.y)];
    [path addLineToPoint:CGPointMake(center.x-radius+15, center.y)];
    [path moveToPoint:CGPointMake(center.x+radius-15, center.y)];
    [path addLineToPoint:CGPointMake(center.x+radius+15, center.y)];
    
    path.lineWidth = 5;//设置线宽
    [[UIColor lightGrayColor]setStroke];//设置画笔颜色
    [path stroke];//画出path
}


@end
