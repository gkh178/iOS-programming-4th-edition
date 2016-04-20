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
#import "BNRItemStore.h"
#import "UIPopoverBackgroundCustomView.h"

//遵守这两个协议作为UIImagePickerController选择照片控制器的委托，才能选择照片，第一个是第二个父类所以也加进来
@interface BNRDetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *camaraButton;
@property (strong, nonatomic) UIPopoverController *imagePickerPopover;//用来装载UIImagePickerController

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

//为添加项目创建指定化初始化方法
-(instancetype)initForNewItem:(BOOL)isNew {
    self = [super initWithNibName:nil bundle:nil];//先调用父类的初始化
    
    if (self) {
        //为新建一个不存在的BNRItem时
        if (isNew) {
            //为导航栏右边添加一个done UIBarButtonItem，点击时触发save:方法
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                     target:self action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            
            //为导航栏左边添加一个cancel UIBarButtonItem，点击时触发cancel:方法
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                       target:self action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
        
        //不论是新建BNRItem还是选中已有BNRItem时，也即初始化使BNRDetialViewController时使它
        //作为观察者接收来自任何对象的UIContentSizeCategoryDidChangeNotification通知时，用户改变首选字体大小时候，会发送该通知然后调用updateFonts更新字体
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self selector:@selector(updateFonts) name:UIContentSizeCategoryDidChangeNotification object:nil];
    }
    
    return self;
}

- (void)dealloc {
    NSNotificationCenter *defaultCenter  = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];//移除观察者
}

//覆盖父类的指定初始化方法，禁止使用它，当使用时抛出异常
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"Use initForNewItem:" userInfo:nil];
    return nil;
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
    
    [self updateFonts];//更新字体
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

//保存item
- (void)save:(id)sender {
    //向self.presentViewController也即UINavigationController 请求dismiss当前的视图控制器也即BNRDetailViewController
    //然后执行self.dismissBlock指向的block块更新BNRItemsTableViewController的显示数据
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
    
}

//取消item
- (void)cancel:(id)sender {
    //取消的时候，需要先释放已经在BNRItemStore中创建的新item
    [[BNRItemStore sharedStore] removeItem:self.item];
    //然后执行self.dismissBlock指向的block块更新BNRItemsTableViewController的显示数据
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
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
    
    //如果是设备是iPad用UIPopoverController对象来拍照
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        //如果UIPopoverController对象是可见的说明已经按了拍照键并显示了一张图到imageView中
        if ([self.imagePickerPopover isPopoverVisible]) {
            //需要关闭这个UIPopoverController对象
            [imagePickerController dismissViewControllerAnimated:YES completion:nil];
            self.imagePickerPopover = nil;
            return ;
        }
        //创建UIPopoverController对象
        self.imagePickerPopover = [[UIPopoverController alloc]initWithContentViewController:imagePickerController];
        
        //使用UIPopoverBackgroundView的子类  自己定义的UIPopoverBackgroundCustomView来自定义popover的popoverBakgroundViewClass
        //UIPopoverBackgroundCustomView *popoverBackgroundCustomView = [[UIPopoverBackgroundCustomView alloc]init];
        //popoverBackgroundCustomView.arrowDirection = UIPopoverArrowDirectionUp;//popover方向向上
        //popoverBackgroundCustomView.arrowOffset = 200.0;//popover的在view的垂直中心线右边200处。如果popover为左或右，就在view的水平中心线的下边200处
        self.imagePickerPopover.popoverBackgroundViewClass = [UIPopoverBackgroundCustomView class];
        
        //设置UIImagePickerPopover的委托为自己
        self.imagePickerPopover.delegate = self;
        
        //显示对应的button上弹出的UIPopoverController对象
        [self.imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    //设备不是iPad用UIImagePickerController模态对象来显示
    else {
        //以全屏模态形式显示UIImagePickerController对象
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

//告诉UIImagePickerController对象的delegate，已经完成选中了图片或视频
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //将info字典中索引为UIImagePickerControllerOriginalImage的原始未被修改的被选中的图像的指针赋给image
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self.item setThumbnailFromImage:image];//将选中的图片的缩略图设置为item的thumbnail属性
    //将选中的图片放入对应的itemKey-image中
    [[BNRImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    
    //将照片放入UIImageView对象用来显示
    self.imageView.image = image;
    
    //如果使用的是UIPopoverController来显示照
    if (self.imagePickerPopover) {
        //关闭UIPopoverController
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        //关闭后要将UIPopoverController设为nil
        self.imagePickerPopover = nil;
    }
    //如果使用的是模态下的UIImagePickerController来显示照片
    else {
    //关闭UIImagePickerController对象
    [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//重写这个方法，表示在即将激活新的用户界面方向前
- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self prepareViewForOrientation:toInterfaceOrientation];
    
}
//为某个界面方向准备view
- (void) prepareViewForOrientation:(UIInterfaceOrientation)orientation {
    //如果设备为iPad，则不执行任何操作
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    //如果是iPhone，
    else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        //判断当前界面方向是否是横排
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            self.imageView.hidden = YES;//隐藏图片
            self.camaraButton.enabled = NO;//拍照按钮不可用
        }
        //不处于横排时 照片能显示，拍照可用
        else {
            self.imageView.hidden = NO;
            self.camaraButton.enabled = YES;
        }
    }
}

//触摸屏幕其它区域关闭UIPopoverController对象
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    NSLog(@"User dismissed popover");
    self.imagePickerPopover = nil;
}

//改变字体的文本样式
- (void)updateFonts {
    //创建一个body文本样式字体，用preferred方法创建的字体可以根据用户在系统设置首选字体大小动态改变该文本样式字体的大小
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.nameField.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    self.dataLabel.font = font;
    self.nameField.font = font;
    self.serialNumberField.font = font;
    self.valueField.font = font;
}


@end
