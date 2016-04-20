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
#import "BNROverlayView.h"

//遵守这两个协议作为UIImagePickerController选择照片控制器的委托，才能选择照片，第一个是第二个父类所以也加进来
@interface BNRDetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIButton *removeImageButton;

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
    
    if (!imageToDisplay) {
        [self.removeImageButton setHidden:YES];//当对应的item的在BNRImageStore中没有对应的图片时
    }
    else {
        [self.removeImageButton setHidden:NO];//当对应的item的在BNRImageStore中有对应的图片时，Remove Image可见
    }
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
    imagePickerController.allowsEditing = YES;//使得选中的照片可以编辑，这里的编辑表示放大后或者缩小在屏幕之间的显示的那部分照片，然后选择Choose
    
    
    //设置UIImagePickerController对象的sourceType属性来说明  设备支持拍照就使用拍照，不支持就使用照片库
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        //使用UIImagePickerController对象的view的bounds减去上下部分防止遮挡下部分菜单 作为初始化BNROverlayView对象的的frame
        CGRect suitableBounds = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + 60,
                                         self.view.bounds.size.width, self.view.bounds.size.height - 120);
        BNROverlayView *overlayView = [[BNROverlayView alloc]initWithFrame:suitableBounds];
        imagePickerController.cameraOverlayView = overlayView;//必须sourceType为拍照才可一起用
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
    
    //info字典中索引为UIImagePickerControllerOriginalImage表示原始图，UIImagePickerControllerEditedImage
    UIImage *image;
    //如果照片允许编辑切编辑过就使用编辑过的，未编辑过的就使用原始图；如果不允许编辑就使用原始图
    if (info[UIImagePickerControllerEditedImage]) {
        image = info[UIImagePickerControllerEditedImage];
    } else {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    //将选中的图片放入对应的itemKey-image中
    [[BNRImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    
    //将照片放入UIImageView对象用来显示
    self.imageView.image = image;
    
    //关闭UIImagePickerController对象
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)removeImage:(id)sender {
    self.imageView.image = nil;//当前显示的照片不显示
    [[BNRImageStore sharedStore]deleteImageForKey:self.item.itemKey];//在BNRImageStore中删除指定BNRItem对象的图片
    [self.removeImageButton setHidden:YES];//删除图片后 Remove Image按钮不可见
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
