//
//  BNRDrawView.m
//  TouchTracker
//
//  Created by gankaihua on 16/2/29.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import "BNRDrawView.h"
#import "BNRLine.h"
#import "BNRCircle.h"
@import UIKit;


@interface BNRDrawView ()
@property (nonatomic, strong) NSMutableArray *finishedLines;//用一个数组保存已经画完的线
@property (nonatomic, strong) NSMutableDictionary *linesInProgress;//用一个字典保存正在画的线,key-value为手指对应的UITouch的地址和正在画的线
@property (nonatomic, strong) NSMutableArray *finishedCircles;//用一个数组保存已经画完的圆
@property (nonatomic, strong) BNRCircle *circleInProgress; //追踪正在画的圆
//@property (nonatomic, strong) BNRLine *diagonalOfCircleInProgress;//跟踪正在画的圆的外接矩阵的对角线
@end


@implementation BNRDrawView

//初始化视图
- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.finishedLines = [[NSMutableArray alloc]init];//初始化finishedLines属性
        self.linesInProgress = [[NSMutableDictionary alloc]init];//初始化linesInProgress属性
        self.finishedCircles = [[NSMutableArray alloc]init];//初始化finishedCircles属性
        self.circleInProgress = [[BNRCircle alloc]init]; //初始化正在画的圆的属性
        //self.diagonalOfCircleInProgress = [[BNRLine alloc]init];
        self.backgroundColor = [UIColor grayColor];//初始化视图的背景颜色
        self.multipleTouchEnabled = YES; //允许对视图进行多点触屏
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [[UIColor blackColor] setStroke];//用黑色绘制已经画完的线和圆
    for (BNRLine *line in self.finishedLines) {
        [self strokeLine:line];
    }
    for (BNRCircle *circle in self.finishedCircles) {
        [self strokeCircle:circle];
    }
    
    [[UIColor redColor] setStroke];//用红色绘制正在画的线和图
    for (NSValue *key in self.linesInProgress) {
        [self strokeLine:self.linesInProgress[key]];
    }
    [self strokeCircle:self.circleInProgress];
}

//定义一个方法，用来画一个圆
- (void) strokeCircle:(BNRCircle *)circle {
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 5;
    [path addArcWithCenter:circle.circleCenter radius:circle.circleRadius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [path stroke];
}

//定义一个方法，用来画某条线
- (void) strokeLine:(BNRLine *)line {
    UIBezierPath *path = [[UIBezierPath alloc]init];
    
    path.lineWidth = 5;
    path.lineCapStyle = kCGLineCapRound;//线的结尾点部位带圆形
    [path moveToPoint:line.begin];
    [path addLineToPoint:line.end];
    [path stroke];//画线
}

//继承自UIResponder的方法，用来处理触摸开始 touches表示一个集合，集合的每个元素为指向UITouch对象的指针，每个UITouch对象为一个手指
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //向控制台输出日志，查看触摸事件的发生顺序
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    int touchesIndex = 0;
    //多点触摸开始 循环处理
    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];//得到当前触摸点在本视图中的坐标位置
        
        BNRLine *line = [[BNRLine alloc]init];
        line.begin = location;
        line.end = location;
        
        //两个手指触摸时为画圆
        if ([touches count] == 2) {
            if (touchesIndex == 0) {
                self.circleInProgress.point1 = location;
                //self.diagonalOfCircleInProgress.begin = location;
            }
            else if (touchesIndex == 1) {
                //self.diagonalOfCircleInProgress.end = location;
                self.circleInProgress.point2 = location;
            }
            ++ touchesIndex;
        }
        //非两个手指触摸时为画线
        else {
            NSValue *key = [NSValue valueWithNonretainedObject:t];//求非retained对象得唯一指针值，也即对象的指针地址，这里得到当前触摸的UITouch对象的地址
            self.linesInProgress[key] = line;
        }
        [self setNeedsDisplay];//非两个手指触摸时重绘视图
    }
}

//继承自UIResponder的方法，用来处理触摸移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //向控制台输出日志，查看触摸事件的发生顺序
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    int touchesIndex = 0;
    //每个UITouch的地址是不变的 ，因为手指都是不可重复的
    for (UITouch *t in touches) {
        //两个手指触摸时为画圆
        if ([touches count] == 2) {
            if (touchesIndex == 0) {
                //self.diagonalOfCircleInProgress.begin = [t locationInView:self];
                self.circleInProgress.point1 = [t locationInView:self];
            }
            else if (touchesIndex == 1) {
                //self.diagonalOfCircleInProgress.end = [t locationInView:self];
                self.circleInProgress.point2 = [t locationInView:self];
            }
            ++ touchesIndex;
        }
        else {
            NSValue *key = [NSValue valueWithNonretainedObject:t];
            BNRLine *line = self.linesInProgress[key];//取出当前手指正在画的线
            line.end = [t locationInView:self];//更新当前手指正在画的线的结束点为当前触摸点
        }
        [self setNeedsDisplay];//重绘视图
    }
}

//继承自UIResponder的方法，用来处理触摸结束
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //向控制台输出日志，查看触摸事件的发生顺序
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    int touchesIndex = 0;
    for (UITouch *t in touches) {
        //两个手指触摸时为画圆
        if ([touches count] == 2) {
            if (touchesIndex == 0) {
                //self.diagonalOfCircleInProgress.begin = [t locationInView:self];
                self.circleInProgress.point1 = [t locationInView:self];
            }
            else if (touchesIndex == 1) {
                //self.diagonalOfCircleInProgress.end = [t locationInView:self];
                self.circleInProgress.point2 = [t locationInView:self];
                BNRCircle *circleAdded = [_circleInProgress mutableCopy];
                [self.finishedCircles addObject:circleAdded];//将当前画的圆加入finishedCircles数组
                self.circleInProgress.point1 = CGPointZero;
                self.circleInProgress.point2 = CGPointZero;//移除当前画的圆的对角线的坐标值
            }
            ++ touchesIndex;
        }
        else {
            NSValue *key = [NSValue valueWithNonretainedObject:t];
            [self.finishedLines addObject:(self.linesInProgress[key])];//将当前手指画的线加入finishedLines数组
            [self.linesInProgress removeObjectForKey:key];//移除在touches中的当前手指对应的项
        }
        [self setNeedsDisplay];
    }
}

//继承自UIResponder的方法，用来处理触摸取消，比如正触摸移动中来了个电话，需要取消触摸
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //向控制台输出日志，查看触摸事件的发生顺序
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    int touchesIndex = 0;
    for (UITouch *t in touches) {
        //两个手指触摸时为画圆
        if ([touches count] == 2) {
            if (touchesIndex == 0) {
                self.circleInProgress.point1 = CGPointZero;
            }
            else if (touchesIndex == 1) {
                self.circleInProgress.point2 = CGPointZero;
            }
            ++ touchesIndex;
        }
        else {
            NSValue *key = [NSValue valueWithNonretainedObject:t];
            [self.linesInProgress removeObjectForKey:key];//删除当前手指正在画的线
        }
    }
    [self setNeedsDisplay];
}
@end
