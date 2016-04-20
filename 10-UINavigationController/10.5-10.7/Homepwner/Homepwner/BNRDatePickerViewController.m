//
//  BNRDatePickerViewController.m
//  Homepwner
//
//  Created by gankaihua on 16/2/28.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import "BNRDatePickerViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "BNRItemsTableViewController.h"
#import "BNRDetailViewController.h"

@interface BNRDatePickerViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation BNRDatePickerViewController

//视图控制器初始化时并添加标题
- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Select a Date";//设置导航栏标题
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.datePicker.date = self.item.dateCreated;//datePicker出现之前将其date设置为被选中的item的当前dateCreated
    
}

- (void) viewWillDisappear:(BOOL)animated {
    _item.dateCreated = _datePicker.date;////datePicker消失之前将其修改后的date赋值给item的dateCreated属性
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
