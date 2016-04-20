//
//  BNRReminderViewController.m
//  HypnoNerd
//
//  Created by gankaihua on 15/12/24.
//  Copyright © 2015年 gankaihua. All rights reserved.
//

#import "BNRReminderViewController.h"

@interface BNRReminderViewController ()
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;//创建一个IBOutlet指向UIDatePicker对象

@end

@implementation BNRReminderViewController

//视图第一次加载后调用该方法，只调用一次
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"BNRReminderViewController loaded its view!!!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//视图显示的时候调用该方法，每次显示前都调用
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:60];//设置datePicker能用的最小日期
}

- (IBAction)addReminder:(id)sender {
    NSDate *date = self.datePicker.date;
    //self.datePicker.date为本地时间，但是赋值给date后变成GMT时间，这里需要显示出来需要用NSDateFormatter来转换显示为本地时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSLog(@"Setting a reminder for %@ ", [dateFormatter stringFromDate:date]);
    
    //创建一个UILocalNotification对象用来设置通知内容和提醒时间
    UILocalNotification *note = [[UILocalNotification alloc] init];
    
    note.alertBody = @"Hypnotize me!!!";//设置通知的内容
    note.fireDate = date;//设置发送通知的时间
    
    //申请一个单例的UIApplication对象并调用其sheduleLoacalNotification:方法将该通知注册
    UIApplication *application = [UIApplication sharedApplication];
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil];//通知类型
    [application registerUserNotificationSettings:settings];//注册通知类型
    [application scheduleLocalNotification:note];//注册通知

}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //设置标题
        self.tabBarItem.title = @"Reminder";
        //设置背景图
        self.tabBarItem.image = [UIImage imageNamed:@"Time.png"];
    }
    return self;
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
