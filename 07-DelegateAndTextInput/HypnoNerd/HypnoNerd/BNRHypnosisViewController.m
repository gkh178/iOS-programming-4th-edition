//
//  BNRHypnosisViewController.m
//  HypnoNerd
//
//  Created by gankaihua on 15/12/24.
//  Copyright © 2015年 gankaihua. All rights reserved.
//

#import "BNRHypnosisViewController.h"
#import "BNRHypnosisView.h"

@interface BNRHypnosisViewController () <UITextFieldDelegate>

@end

@implementation BNRHypnosisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"BNRHypnosisViewController loaded its view!!!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//重写继承自UIViewController的loadView方法
- (void) loadView {
    //创建一个BNRHypnosisView对象
    BNRHypnosisView *backgroundView = [[BNRHypnosisView alloc]init];
    
    //创建一个UITextField对象的的视图并设置为view的subview
    CGRect textFieldRect = CGRectMake(80, 100, 250, 50);
    UITextField *textField = [[UITextField alloc]initWithFrame:textFieldRect];
    //设置UITextField对象的边款样式以及默认文字以及回车键改名为Done
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"Hypnotize me";
    textField.returnKeyType = UIReturnKeyDone;
    [backgroundView addSubview:textField];
    
    //设置UITextField对象的委托为本视图控制器用来处理textField的各种事件
    textField.delegate = self;
    
    //将该BNRHypnosisView对象添加为试图控制器的view属性
    self.view = backgroundView;
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //设置标签项的标题
        self.tabBarItem.title = @"Hypnotize";
        //从图形文件创建一个UIImage对象
        UIImage *image = [UIImage imageNamed:@"Hypno.png"];
        //设置标签项的背景图
        self.tabBarItem.image = image;
        
        //加载一个UISegmentedControl对象到视图
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Red", @"Green", @"Blue", nil]];
        segmentedControl.frame = CGRectMake(80, 35, 250, 50);//分段控件的坐标及尺寸
        segmentedControl.selectedSegmentIndex = 0;//被选中的分段索引号
        [segmentedControl addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventValueChanged];//当控件的值改变时调用changeColor方法
        [self.view addSubview:segmentedControl];//将控件添加为view的子视图
    }
    return self;
}

- (void) changeColor:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;//将sender对象赋值给控件对象
    if (segmentedControl.selectedSegmentIndex == 0) {
        [self.view setValue:[UIColor redColor] forKey:@"circleColor"];
    }
    if (segmentedControl.selectedSegmentIndex == 1) {
        [self.view setValue:[UIColor greenColor] forKey:@"circleColor"];
    }
    if (segmentedControl.selectedSegmentIndex == 2) {
        [self.view setValue:[UIColor blueColor] forKey:@"circleColor"];
    }
}

//用本视图控制器委托处理textField的事件，这里对应输入文字完成按下done的处理
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [self drawHypnoticMessage:textField.text];//调用drawHypnoticMessage:消息传递textField的文字内容
    
    textField.text = @"";//textField.text清零
    [textField resignFirstResponder];//关闭键盘
    return YES;
}

//绘制20个睡眠UILabel，其内容为message指向的字符串
- (void) drawHypnoticMessage:(NSString *)message {
    for (int i = 0; i < 20; ++i) {
        UILabel *messageLabel = [[UILabel alloc]init];
        
        //设置UILabel对象的背景颜色、字体颜色、文字内容
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.text = message;
        
        //根据文字调整UILabel的size，用UILabel适应文字
        [messageLabel sizeToFit];
        
        //获取随机的x坐标
        //UILabel对象的宽度不超过BNRHypnosisViewController的view宽度
        int width = (int)(self.view.bounds.size.width - messageLabel.bounds.size.width);
        int x = arc4random() % width;
        //获取随机的y坐标
        //UILabel对象的高度不超过BNRHypnosisViewController的view高度
        int height = (int)(self.view.bounds.size.height - messageLabel.bounds.size.height);
        int y = arc4random() % height;
        
        //设置UILabel对象的frame
        CGRect frame = messageLabel.frame;
        frame.origin = CGPointMake(x, y);
        messageLabel.frame = frame;
        
        //将UILabel对象添加到子view
        [self.view addSubview:messageLabel];
        
        //使用UIInterpolatingMotionEffect对象设置视图的视差效果，包括方向、键属，视差范围大小
        //水平方向视差效果
        UIInterpolatingMotionEffect *motionEffect;
        motionEffect = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        motionEffect.minimumRelativeValue = @(-25);
        motionEffect.maximumRelativeValue = @(25);
        [messageLabel addMotionEffect:motionEffect];//对messageLabel添加水平方向视差效果
        //垂直方向视差效果
        motionEffect = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        motionEffect.minimumRelativeValue = @(-25);
        motionEffect.maximumRelativeValue = @(25);
        [messageLabel addMotionEffect:motionEffect];//对messageLabel添加垂直方向视差效果
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
