//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by gankaihua on 16/2/27.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

//遵守这两个协议作为UIImagePickerController选择照片控制器的委托，才能选择照片，第一个是第二个父类所以也加进来
@interface BNRDetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@end

@implementation BNRDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //①创建子视图
    UIImageView *iv = [[UIImageView alloc] initWithImage:nil];//创建一个imageView用来加载
    //设置UIImageView对象的内容缩放模式为等比例拉伸到适合尺寸
    iv.contentMode = UIViewContentModeScaleAspectFit;
    //告诉自动布局系统禁止自动缩放掩码 转换为约束，会跟自己写的约束冲突
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    //添加UIImageView为子view
    [self.view addSubview:iv];
    self.imageView = iv;
    
    //②创建相关约束
    //使用可视化格式创建水平约束对象，使得imageView的左边和右边与父视图的距离为0，包含两条约束添加到NSArray中
    NSDictionary *nameMap = @{ @"imageView" : self.imageView,
                               @"dateLabel" : self.dataLabel,
                               @"toolBar"   : self.toolBar  };
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:nameMap];
    //使用可视化格式创建垂直约束对象
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolBar]"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:nameMap];
    //③将创建的约束构成的NSArray添加到需要的视图中
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//视图即将出现之前，几个需要显示的地方获取被选中的item的值，以及被选中的item在对应BNRItemStore中保存的图片
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
    
    //根据当前视图中的item的key，得到保存的图片用来展示，如果没保存过图片，imageToDisplay为nil
    NSString *key = self.item.itemKey;
    UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:key];
    self.imageView.image = imageToDisplay;
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
- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];//触摸view的空白背景取消第一响应对象 并关闭虚拟键盘
}/*
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];//触摸view的非控件地方取消第一响应对象 并关闭虚拟键盘
}*/

//按下拍照UIBarButton
- (IBAction)takePicture:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];//创建一个UIImagePickerController对象用来拍照
    
    //设置UIImagePickerController对象的sourceType属性来说明  设备支持拍照就使用拍照，不支持就使用照片库
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    //设置UIImagePickerController对象的delegate属性来说明其委托是BNRDetailViewController对象
    imagePickerController.delegate = self;
    
    //以全屏模态形式显示UIImagePickerController对象
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

//告诉UIImagePickerController对象的delegate，已经完成选中了图片或视频
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //将info字典中索引为UIImagePickerControllerOriginalImage的原始未被修改的被选中的图像的指针赋给image
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    //将选中的图片放入对应的itemKey-image中
    [[BNRImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    
    //将照片放入UIImageView对象用来显示
    self.imageView.image = image;
    
    //关闭UIImagePickerController对象
    [self dismissViewControllerAnimated:YES completion:nil];
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
