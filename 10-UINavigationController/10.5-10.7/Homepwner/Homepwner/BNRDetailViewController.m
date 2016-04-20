//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by gankaihua on 16/2/27.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRItem.h"
#import "BNRDatePickerViewController.h"

@interface BNRDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@end

@implementation BNRDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//视图即将出现之前，几个需要显示的地方获取被选中的item的值
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = self.item.itemName;//设置选中的item的名字到显示为导航栏标题
    
    BNRItem *item = self.item;
    
    self.nameField.text = item.itemName;
    self.serialNumberField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    //创建NSDateFormatter对象，用来将NSDate对象转化为字符串
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    self.dataLabel.text = [dateFormatter stringFromDate:item.dateCreated];
}

//视图即将消失之前，将视图修改的地方返回给item指向的在BNRItemStore中的项
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //取消当前的第一响应对象，也即当前视图或其子视图，关闭虚拟键盘
    [self.view endEditing:YES];
    
    //将修改保存到item指向的BNRItem对象
    BNRItem *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialNumberField.text;
    item.valueInDollars = [self.valueField.text intValue];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];//对于的textField键盘按下时取消第一响应状态并关闭键盘
    return  YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];//触摸view的非控件地方取消第一响应对象 并关闭虚拟键盘
}

//点击Change Date触发事件
- (IBAction)changeDate:(id)sender {
    BNRDatePickerViewController *datePickerViewController = [[BNRDatePickerViewController alloc]init];
    
    [self.navigationController pushViewController:datePickerViewController animated:YES];//将BNRDatePickerViewController压入栈顶
    datePickerViewController.item = self.item;//入栈之前将选中的item指针赋值给即将出现的datePickerView下的item指针
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
