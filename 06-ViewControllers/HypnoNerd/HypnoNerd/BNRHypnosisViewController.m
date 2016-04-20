//
//  BNRHypnosisViewController.m
//  HypnoNerd
//
//  Created by gankaihua on 15/12/24.
//  Copyright © 2015年 gankaihua. All rights reserved.
//

#import "BNRHypnosisViewController.h"
#import "BNRHypnosisView.h"

@interface BNRHypnosisViewController ()

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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
