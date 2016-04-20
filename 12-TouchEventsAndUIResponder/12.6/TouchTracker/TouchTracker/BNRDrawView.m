//
//  BNRDrawView.m
//  TouchTracker
//
//  Created by gankaihua on 16/2/29.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import "BNRDrawView.h"
#import "BNRLine.h"
@import UIKit;


@interface BNRDrawView ()
@property (nonatomic, strong) NSMutableArray *finishedLines;//用一个数组保存已经画完的线
@property (nonatomic, strong) NSMutableDictionary *linesInProgress;//用一个字典保存正在画的线,key-value为手指对应的UITouch的地址和正在画的线
@end


@implementation BNRDrawView

//初始化视图
- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.finishedLines = [[NSMutableArray alloc]init];//初始化finishedLines属性
        self.linesInProgress = [[NSMutableDictionary alloc]init];//初始化linesInProgress属性
        self.backgroundColor = [UIColor grayColor];//初始化视图的背景颜色
        self.multipleTouchEnabled = YES; //允许对视图进行多点触屏
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //[[UIColor blackColor] setStroke];//用黑色绘制已经画完的线
    for (BNRLine *line in self.finishedLines) {
        [[self colorOfLineBasedOnAngle:line] setStroke];
        [self strokeLine:line];
    }
    
    [[UIColor redColor] setStroke];//用红色绘制正在画的线
    for (NSValue *key in self.linesInProgress) {
        [self strokeLine:self.linesInProgress[key]];
    }
}

//定义一个方法，用来画某条线
- (void) strokeLine:(BNRLine *)line {
    UIBezierPath *path = [[UIBezierPath alloc]init];
    
    path.lineWidth = 8;
    path.lineCapStyle = kCGLineCapRound;//线的结尾点部位带圆形
    [path moveToPoint:line.begin];
    [path addLineToPoint:line.end];
    [path stroke];//画线
}

//继承自UIResponder的方法，用来处理触摸开始 touches表示一个集合，集合的每个元素为指向UITouch对象的指针，每个UITouch对象为一个手指
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //向控制台输出日志，查看触摸事件的发生顺序
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    //多点触摸开始 循环处理
    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];//得到当前触摸点在本视图中的坐标位置
        
        BNRLine *line = [[BNRLine alloc]init];
        line.begin = location;
        line.end = location;
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];//求非retained对象得唯一指针值，也即对象的指针地址，这里得到当前触摸的UITouch对象的地址
        self.linesInProgress[key] = line;
    }
    
    [self setNeedsDisplay];//重绘视图
}

//继承自UIResponder的方法，用来处理触摸移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //向控制台输出日志，查看触摸事件的发生顺序
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    //每个UITouch的地址是不变的 ，因为手指都是不可重复的
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BNRLine *line = self.linesInProgress[key];//取出当前手指正在画的线
        line.end = [t locationInView:self];//更新当前手指正在画的线的结束点为当前触摸点
    }
    
    [self setNeedsDisplay];//重绘视图
}

//继承自UIResponder的方法，用来处理触摸结束
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //向控制台输出日志，查看触摸事件的发生顺序
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.finishedLines addObject:(self.linesInProgress[key])];//将当前手指画的线加入finishedLines数组
        [self.linesInProgress removeObjectForKey:key];//移除在touches中的当前手指对应的项
    }
    
    [self setNeedsDisplay];
}

//继承自UIResponder的方法，用来处理触摸取消，比如正触摸移动中来了个电话，需要取消触摸
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //向控制台输出日志，查看触摸事件的发生顺序
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];//删除当前手指正在画的线
    }
    
    [self setNeedsDisplay];
}

//根据已经画出的线的角度定义其重绘颜色
- (UIColor *) colorOfLineBasedOnAngle:(BNRLine *)line {
    //得到线的长度
    float z = sqrtf((line.end.x - line.begin.x) * (line.end.x - line.begin.x) + (line.end.y - line.begin.y) * (line.end.y - line.begin.y));
    float cos = (line.end.x - line.begin.x) / z;
    float sin = (line.end.y - line.begin.y) / z;
    
    //cos的值为0时，也即垂直方向时，为黑色
    if (cos == 0){
        return [UIColor blackColor];
    }
    //cos的值为-1 或 1时，也即水平方向时，为蓝色
    if (fabsf(cos) == 1){
        return [UIColor blueColor];
    }
    
    //cos>0且sin>0为第4象限方向(0,90°)，绿色
    if (cos > 0 && sin > 0){
        return [UIColor greenColor];
    }
    //cos>0且sin<0为第1象限方向(90°,180°)，黄色
    if (cos > 0 && sin < 0){
        return [UIColor yellowColor];
    }
    
    //cos<0且sin<0为第2象限方向(180°,270°)，白色
    if (cos < 0 && sin < 0){
        return [UIColor whiteColor];
    }
    
    //cos<0且sin>0为第3象限方向(270°,360°)，橙色
    if (cos < 0 && sin > 0){
        return [UIColor orangeColor];
    }
    return nil;
}


@end
