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


@interface BNRDrawView () <UIGestureRecognizerDelegate>//添加委托，主要是为了同时识别多个手势
@property (nonatomic, strong) UIPanGestureRecognizer *moveRecognizer;//添加一个拖动手势识别器
@property (nonatomic, strong) NSMutableArray *finishedLines;//用一个数组保存已经画完的线
@property (nonatomic, strong) NSMutableDictionary *linesInProgress;//用一个字典保存正在画的线,key-value为手指对应的UITouch的地址和正在画的线
@property (nonatomic, weak) BNRLine *selectedLine;//选中的线，在fiishedLines，借用所以用weak
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
        
        //双击屏幕时触发doubleTap:方法，清除所有屏幕上的线
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;//双击手势要求两次击
        doubleTapRecognizer.delaysTouchesBegan = YES;//推迟触摸开始的event计算 ，防止在识别单击手势时候先触发touchesBegan:withEvent方法
        [self addGestureRecognizer:doubleTapRecognizer];//将该手势添加到本视图中
        
        //单击屏幕时触发tap:方法，选中距离触摸点距离20以内的最近的线
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        tapRecognizer.numberOfTapsRequired = 1;//单击手势要求一次点击
        tapRecognizer.delaysTouchesBegan = YES;//延迟触摸事件的touchesBegan结算
        //创建单击和双击之间的依赖关系，如果没有这个，双击时会先识别单击，再识别双击，也就是双击包含单击。
        //这里添加条件，识别单击成功的必须条件是双击识别不成功，这样才是真的单击
        [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
        [self addGestureRecognizer:tapRecognizer];//将该手势添加到本视图中
        
        //添加长按手势对象，触发longPress:方法，选中某条线
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPressRecognizer];
        
        //拖动时触发moveLine:方法，拖动某条选中的线
        self.moveRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveLine:)];
        self.moveRecognizer.cancelsTouchesInView = NO;//设置为NO时，该手势不会吃掉别的触摸事件，是同时识别两个手势的必须条件
        self.moveRecognizer.delegate = self;//moveRecognizer的委托为本视图，因为声明了<UIGestureRecognizerDelegate>协议
        [self addGestureRecognizer:self.moveRecognizer];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [[UIColor blackColor] setStroke];//用黑色绘制已经画完的线
    for (BNRLine *line in self.finishedLines) {
        [self strokeLine:line];
    }
    [[UIColor greenColor]setStroke];//用绿色画被选中的线
    [self strokeLine:self.selectedLine];
    
    [[UIColor redColor] setStroke];//用红色绘制正在画的线
    for (NSValue *key in self.linesInProgress) {
        [self strokeLine:self.linesInProgress[key]];
    }
}

//重写继承自UIGestureRecognizerDelegate委托的方法，gestureRecognizer手势能同时识别otherGestureRecognizer手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //如果请求跟别的手势共同作用的手势为 moveRecognizer时，允许同时共存
    if (gestureRecognizer == self.moveRecognizer) {
        return YES;
    }
    
    return NO;
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

//得到距离point最近的线
- (BNRLine *) nearestLineToPoint:(CGPoint)point {
    for (BNRLine *line in self.finishedLines) {
        for (float t = 0.0; t <= 1.0; t += 0.05) {
            CGPoint p = CGPointMake(line.begin.x + (line.end.x - line.begin.x) * t, line.begin.y + (line.end.y - line.begin.y) * t);
            CGFloat distance = hypot(p.x - point.x, p.y - point.y);
            if (distance < 20.0) {
                return line;
            }
        }
    }
    return nil;//没找距离在20以内的线就不选择任何线条
}

- (void) longPress:(UIGestureRecognizer *)gr {
    //长按手势状态为开始时
    if (gr.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gr locationInView:self];//得到手势触摸点坐标
        self.selectedLine = [self nearestLineToPoint:point];//根据点得到选中的线
        //选中的线存在时，清除所有的正在画的线
        if (self.selectedLine) {
            [self.linesInProgress removeAllObjects];//
        }
    }
    //长按手势状态为结束时，也即离开屏幕时
    else if (gr.state == UIGestureRecognizerStateEnded) {
        self.selectedLine = nil;//取消选中的线
    }
    [self setNeedsDisplay];
}

- (void) doubleTap:(UIGestureRecognizer *)gr {
    NSLog(@"Recognized Double Tap");
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    [self.linesInProgress removeAllObjects];//清楚linesInProgress中所有正在画的线
    [self.finishedLines removeAllObjects];//清楚finishedLines中所有已经画的线
    [self setNeedsDisplay];//清除线后需要重绘视图并显示出来
}


- (void) tap:(UIGestureRecognizer *)gr {
    NSLog(@"Recognizerd Single Tap");
    
    CGPoint tappedPoint = [gr locationInView:self];//得到单击时候的触摸点的坐标
    self.selectedLine = [self nearestLineToPoint:tappedPoint];//得到被选中的线

    //如果存在被选中的线
    if (self.selectedLine) {
        //使视图成为UIMenuItem对象的第一响应者，这样才能处理UIMenuItem的对应消息
        [self becomeFirstResponder];
        
        UIMenuController *menu = [UIMenuController sharedMenuController];//一个应用只有一个UIMenuController对象
        //创建一个在UIMenuItem对象，点击它触发deleteLine:方法删掉选择的线
        UIMenuItem *deleteItem = [[UIMenuItem alloc]initWithTitle:@"Delete" action:@selector(deleteLine:)];
        menu.menuItems = @[deleteItem];
        
        //UIMenuController的显示区域大小
        [menu setTargetRect:CGRectMake(tappedPoint.x, tappedPoint.y, 2, 2) inView:self];
        //UIMenuController此时可见
        [menu setMenuVisible:YES animated:YES];
    }
    //如果不存在被选中的线
    else {
        //此时UIMenuController不可见
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
    [self setNeedsDisplay];//重绘视图
}

- (void) moveLine:(UIPanGestureRecognizer *)gr {
    //如果没有选中的线就返回
    if (!self.selectedLine) {
        return;
    }
    
    //当UIPanGestureRecognizer处于“变化后”的状态时，也即开始拖动了
    if (gr.state == UIGestureRecognizerStateChanged) {
        //获取当前手指的拖移距离，状态为begin时 拖移距离为(0,0)，状态为changed时，拖移距离为begin时候的触摸点相对坐标
        CGPoint translation = [gr translationInView:self];
        
        //选中的线的坐标 加上拖移的距离等于新的线的坐标
        CGPoint begin = self.selectedLine.begin;
        CGPoint end = self.selectedLine.end;
        begin.x += translation.x;
        begin.y += translation.y;
        end.x += translation.x;
        end.y += translation.y;
        self.selectedLine.begin = begin;
        self.selectedLine.end = end;
        
        [self setNeedsDisplay];
        [gr setTranslation:CGPointZero inView:self];//在下一次changed前，相对拖移距离置为0，下一次changed时的触摸点是相对上一次结束点的坐标的
    }
}

//自定义UIView需要重写canBecomeFirstResponder方法才能用becomeFirstResponder方法
- (BOOL) canBecomeFirstResponder {
    return YES;
}

//删除选中的线
- (void) deleteLine:(id)sender {
    [self.finishedLines removeObject:self.selectedLine];
    [self setNeedsDisplay];
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
@end
