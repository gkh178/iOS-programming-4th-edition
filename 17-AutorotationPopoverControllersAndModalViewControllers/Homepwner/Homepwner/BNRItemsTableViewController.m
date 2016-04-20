//
//  BNRItemsTableViewController.m
//  Homepwner
//
//  Created by gankaihua on 16/2/27.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import "BNRItemsTableViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRDetailViewController.h"

@interface BNRItemsTableViewController ()
//@property (nonatomic, strong) IBOutlet UIView *headerView;//表示在tableView中的headerView对象
@end

@implementation BNRItemsTableViewController


//添加item时，用YES的方式初始化一个BNRDetailViewController对象
- (IBAction)addNewItem:(id)sender {
    BNRItem *newItem = [[BNRItemStore sharedStore]createItem];//创建一个item并加入BNRItemStore
    /*
    NSInteger lastRow = [[[BNRItemStore sharedStore]allItems] indexOfObject:newItem];//得到newItem的行数也就是BNRItemStore的items的最后一行
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];//得到最后一行的indexPath
    
    //将新行插入UITableView中
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
     */
    
    //创建一个模态显示的BNRDetailViewController对象
    BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc]initForNewItem:YES];
    detailViewController.item = newItem;//对象的item指向新创建的newItem
    
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];//更新tableView的section row的数据
    };
    //创建一个新的UINavigationController并将detailViewController入栈作为根视图控制器
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:detailViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;//以表单形式显示navController的模态样式
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;//模态样式显示的时候的动画效果为：以3D效果翻转，默认是从底部滑入
    //显示detailViewController
    [self presentViewController:navController animated:YES completion:nil];
}

/*
//切换EditingMode
- (IBAction)toggleEditingMode:(id)sender {
    //如果当前视图控制对象处于编辑模式
    if (self.isEditing) {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];//修改按钮标题
        [self setEditing:NO animated:YES];//关闭编辑模式
    }
    else {
        [sender setTitle:@"Done" forState:UIControlStateNormal];//修改按钮标题
        [self setEditing:YES animated:YES];//开启编辑模式
    }
}
 */

/*
//获取headerView对象
- (UIView *) headerView {
    if (!_headerView) {
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];//使用main的NSBunble指针指定加载HeaderView.nib到本视图控制器中
    }
    return _headerView;
}
 */

//BNRItemsTableViewController对象的默认初始化
- (instancetype) init {
    //调用父类UITableViewController对象的初始化
    self = [super initWithStyle:UITableViewStylePlain];//使用plain风格
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homepwner";//设置导航栏的标题
        
        //设置导航栏的rightBarButtonItem为+号，按下时触发addNewItem:
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        navItem.rightBarButtonItem = bbi;
        
        //设置导航栏的leftBarButtonItem为Edit按钮，按下时能编辑tableView的行
        navItem.leftBarButtonItem = self.editButtonItem;
    }
    return  self;
}

////BNRItemsTableViewController对象的指定初始化
- (instancetype) initWithStyle:(UITableViewStyle)style {
    return [self init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    /*
    UIView *header = self.headerView;//header指向headerView视图
    [self.tableView setTableHeaderView:header];//tableView使用header作为HeaderView
     */
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//继承自UITableViewDataSource协议的必须方法，表示UITableView对象向数据源请求在某个section下包含多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[BNRItemStore sharedStore]allItems]count];//包含多少个BNRItems就有多少行
}

//继承自UITableViewDataSource协议的必须方法，表示UITableView对象向数据源请求在某个section下的某行创建UITableViewCell对象
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //创建UITableView对象，风格使用默认的UITableViewCellStyleDefault
    //UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    //创建或重用UITableViewCell对象。当对象池中没有UITabelViewCell对象时候应该初始化UITableViewCell对象，并将其加到可重用的对象池中；如果有的话直接从对象池中取出
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    //获取allItems的第n个BNRItem对象
    //然后将其描述信息赋给UITableCell对象的textLabel.text
    NSArray *items = [[BNRItemStore sharedStore]allItems];
    BNRItem *item = items[indexPath.row];
    cell.textLabel.text = [item description];
    
    return cell;
}


//继承自UITableViewDataSource协议的方法，表示UITableView对象向数据源请求插入或者删除某行
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    //如果UITableView对象请求的是删除操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[BNRItemStore sharedStore]allItems];
        BNRItem *item = items[indexPath.row];
        [[BNRItemStore sharedStore] removeItem:item];//在BNRItemStore中删除该item
        
        //在TableView的对应行删除该行
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

//继承自UITableViewDataSource协议的方法，表示UITableView对象向数据源请求移动某行到另一行
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath {
    [[BNRItemStore sharedStore] moveItemAtIndex:fromIndexPath.row toIndex:toIndexPath.row];
    
}


//继承自UITableViewDelegate协议的方法，表示选中UITableView对象的某行之后
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //创建选中某行后需要入栈的视图控制器
    //BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc]init];
    //选中一行后，使用NO的方式创建一个detailViewController调用的是BNRDetailViewController的父类默认初始化方法
    BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc]initForNewItem:NO];
    
    NSArray *items = [[BNRItemStore sharedStore]allItems];
    BNRItem *selectedItem = items[indexPath.row];//被选中的item
    //将被选中的item赋给detailViewController的item属性，这样在入栈的视图控制器的视图显示之前能获取到选中的item的值
    detailViewController.item = selectedItem;
    
    //将detailViewController对象压入UINavigationController对象的栈，也即navigationController的viewControllers数组中
    [self.navigationController pushViewController:detailViewController animated:YES];
}

//重写viewWillApper:方法
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];//在tableView视图重新出现之前，重新加载tableView的section和rows
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
