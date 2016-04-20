//
//  BNRHypnosisView.m
//  Hypnosister
//
//  Created by gankaihua on 15/12/17.
//  Copyright © 2015年 gankaihua. All rights reserved.
//

#import "BNRHypnosisView.h"

@interface BNRHypnosisView ()
@property (nonatomic, strong) UIColor *circleColor;//声明一个circleColor熟悉表示绘制的圆的颜色
@end

@implementation BNRHypnosisView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

//重写自UIView的drwaRect:方法实现自定义绘图，在将视图添加到显示时会自动调用该方法
- (void) drawRect:(CGRect)rect {
    CGRect bounds = self.bounds;//将BNRHypnosisView对象的bounds绘图区域赋值给bounds
    
    /*
     绘制同心圆
     */
    //获取绘图区域的中心点center
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    //hypot函数是获得以两个参数为边的直角三角形的第三条边的长度，这里得到矩形区域的的对角线的半径长度
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];//初始化UIBezierPath对象path
    //从最大半径到中心点的最小半径添加路径到path中
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20) {
        [path moveToPoint:CGPointMake(center.x + currentRadius, center.y)];
        //以center为中心，currentRadius为半径，绘制圆
        [path addArcWithCenter:center radius:currentRadius startAngle:0.0 endAngle:(M_PI * 2.0) clockwise:YES];
    }
    [path closePath];//关闭path
    path.lineWidth = 10;//path的线宽
    [self.circleColor setStroke];//设置画笔的颜色为cirCleColor颜色
    [path stroke];//绘制path为图形
    
    
    
    /*
     在图形上下文中绘制加载进来的logo.png的带阴影的图形
     */
    //获取当前图形上下文对象
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //绘制阴影图形，需要用save和restore先保存图形上下文的状态再恢复
    CGContextSaveGState(currentContext);//保存图形上下文状态
    CGContextSetShadow(currentContext, CGSizeMake(12, 12), 2);//对图像上下文设置阴影，偏移位置为12 12，透明度为2%
    UIImage *logoImage = [UIImage imageNamed:@"logo.png"];//获取同文件夹下的logo.png图像，并初始化为UIImage对象
    [logoImage drawInRect:bounds];//用UIImage对象的drawInRect:方法在bounds区域绘制阴影图形
    CGContextRestoreGState(currentContext);//恢复图形上下文状态
    
    

    /*
     在图形上下文中绘制一个三角形
     */
    //设置a b c ab d几个点的位置
    float r = (MIN(bounds.size.width, bounds.size.height) / 2.0) / 2.0;
    CGPoint a = CGPointMake(center.x - r , center.y + r);
    CGPoint b = CGPointMake(center.x + r , center.y + r);
    CGPoint ab = CGPointMake(center.x, center.y + r);
    CGPoint c = CGPointMake(center.x, center.y - 2 * r);
    CGPoint d = CGPointMake(center.x, center.y + 3 * r);

    CGContextSetRGBStrokeColor(currentContext, 1, 0, 0, 1);//设置图形上下文对象的RGB绘制颜色为红色(1,0,0)
    CGMutablePathRef path1 = CGPathCreateMutable();//创建一个可变路径对象path1
    CGPathMoveToPoint(path1, NULL, a.x, a.y);//将a->b->c->路径添加到path1中
    CGPathAddLineToPoint(path1, NULL, b.x, b.y);
    CGPathAddLineToPoint(path1, NULL, c.x, c.y);
    CGPathAddLineToPoint(path1, NULL, a.x, a.y);
    CGContextAddPath(currentContext, path1);//将path1添加到currentContext上下文对象中
    
    CGContextStrokePath(currentContext);//将当前上下文对象绘制出来
    CGPathRelease(path1);//将path1的引用次数-1

    
    
    /*
     使用渐变颜色填充图形上下文
     */
    CGMutablePathRef path2 = CGPathCreateMutable();//创建一个可变路径对象path2
    CGPathMoveToPoint(path2, NULL, ab.x, ab.y);//将ab->d的路径添加到path2中
    CGPathAddLineToPoint(path2, NULL, d.x, d.y);
    CGContextAddPath(currentContext, path2);//将path2添加到currentContext上下文对象中
    
    CGContextStrokePath(currentContext);//将当前上下文对象绘制出来
    CGPathRelease(path2);//将path2的引用次数-1
    
    CGFloat locations[2] = {0.0, 1.0};
    CGFloat components[8] = {1.0, 0.0, 0.0, 1.0,//红色
        1.0, 1.0, 0.0, 1.0};//黄色
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();//colorSpace用来封装颜色components
    //用colorSpace以及颜色components初始化渐变对象
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    CGPoint startPoint = CGPointMake(ab.x, ab.y + 0.5 * r);//渐变初始化点
    CGPoint endPoint = CGPointMake(d.x, d.y - 0.5 * r);//渐变结束点
    CGContextDrawLinearGradient(currentContext, gradient, startPoint, endPoint, 0);//在图形上下文中绘制线性渐变图形，从start->end点
    CGGradientRelease(gradient);//释放gradient
    CGColorSpaceRelease(colorSpace);//释放colorSpace对象
    
    
    
    /*
     使用渐变颜色填充指定的路径范围，先使用剪切路径裁剪图形上下文
     */
    UIBezierPath *path3 = [[UIBezierPath alloc]init];//创建一个UIBezierPath对象path3用来保存剪切的路径
    [path3 moveToPoint:a];//将a->b->c->a添加到path3中
    [path3 addLineToPoint:b];
    [path3 addLineToPoint:c];
    [path3 addLineToPoint:a];
    [path3 closePath];//关闭path3
    
    CGContextRef currentContext2 = UIGraphicsGetCurrentContext();//获取一个currentContext对象
    CGFloat locations_[2] = {0.0, 1.0};
    CGFloat components_[8] = {1.0, 0.0, 0.0, 1,0, 1.0, 1.0, 0.0, 1.0};//黄
    CGColorSpaceRef colorSpace_ = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient_ = CGGradientCreateWithColorComponents(colorSpace_, components_, locations_, 2);
    
    CGContextSaveGState(currentContext2);//保存图形上下文状态
    [path3 addClip];//将path3添加为剪切的路径
    CGContextDrawLinearGradient(currentContext2, gradient_, a, c, 0);
    CGContextRestoreGState(currentContext2);//恢复图形上下文状态
    
    CGGradientRelease(gradient_);
    CGColorSpaceRelease(colorSpace_);
}

//修改circleColor属性
- (void) setCircleColor:(UIColor *)circleColor {
    _circleColor = circleColor;
    [self setNeedsDisplay];//当circleColor被修改时，视图需要重绘
}


//BNRHypnosisView被触摸时收到该消息
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%@ was touched!!", self);
    
    //获取随机颜色的r g b值
    float red = (arc4random() % 100) / 100.0;
    float green = (arc4random() % 100) / 100.0;
    float blue = (arc4random() % 100) / 100.0;
    
    UIColor *randomColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    self.circleColor = randomColor;
}


//重写继承自UIView的initWithFrame:方法，用frame初始化视图
- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];//初始化时将背景设置为透明颜色
        self.circleColor = [UIColor lightGrayColor];//初始化时讲同心圆的绘制图形设置为lightGray
    }
    return self;
}
@end
