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

@interface BNRItemsTableViewController ()

@end

@implementation BNRItemsTableViewController

//BNRItemsTableViewController对象的默认初始化
- (instancetype) init {
    //调用父类UITableViewController对象的初始化
    self = [super initWithStyle:UITableViewStylePlain];//使用plain风格
    if (self) {
        //创建五个BNRItem对象到BNRItemStore所指向的数组中
        for (int i = 0; i < 5; ++i) {
            [[BNRItemStore sharedStore] createItem];
        }
    }
    return  self;
}

////BNRItemsTableViewController对象的指定初始化
- (instancetype) initWithStyle:(UITableViewStyle)style {
    return [self init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //tableView注册能重复使用的Cell对象，也即能添加到行内的视图对象类型包括UITableViewCell对象也包括UITableViewHeaderFooterView对象
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    
    self.tableView.rowHeight = 60;//行高60
    
    //tabelView加载背景图
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"love.jpg"]];
    self.tableView.backgroundView = backgroundImageView;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//继承自UITableViewDataSource协议的方法，表示UITableView对象向数据源请求应该有多少个section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

//继承自UITableViewDataSource协议的必须方法，表示UITableView对象向数据源请求在在各个section下总共包含多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *items = [[BNRItemStore sharedStore]allItems];
    
    int sum = 0;
    if (section == 0) {
        for (BNRItem *item in items) {
            if (item.valueInDollars > 50.0) {
                ++sum;
            }
        }
    }
    
    if (section == 1) {
        for (BNRItem *item in items) {
            if (item.valueInDollars < 50.0) {
                ++sum;
            }
        }
    }
    
    return sum;
}

//继承自UITableViewDataSource协议的必须方法，表示UITableView对象向数据源请求在某个indexPath下的创建UITableViewCell对象
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //创建或重用UITableViewCell对象。当可重用对象池中没有UITabelViewCell对象时应该初始化UITableViewCell对象，并将其加到池中；如果有的话直接从池中取出
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont systemFontOfSize:20];//设置UITableViewCell对象的字体为20
    NSArray *items = [[BNRItemStore sharedStore]allItems];

    //两个可变数组用来保存>50和<50的item
    NSMutableArray *section0 = [[NSMutableArray alloc]init];
    NSMutableArray *section1 = [[NSMutableArray alloc]init];
    
    for (BNRItem *item in items) {
        if (item.valueInDollars > 50.0) {
            [section0 addObject:item];
        }
        else {
            [section1 addObject:item];
        }
    }
    
    if (indexPath.section == 0) {
        BNRItem *item = section0[indexPath.row];
        cell.textLabel.text = [item description];
    }
    else if (indexPath.section == 1) {
        BNRItem *item = section1[indexPath.row];
        cell.textLabel.text = [item description];
    }
    
    return cell;
}

//继承自UITableViewDelegate协议的方法，表示返回指定section的footerView并添加到UITableView中的section下
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (section == 1) {
        footer.textLabel.text = @"No more items!";
    }
    return footer;
}
//继承自UITableViewDelegate协议的方法，表示返回指定section的footerView的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}

//继承自UITableViewDelegate协议的方法，表示返回指定section的headerView并添加到UITableView中的section下
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    header.contentView.backgroundColor = [UIColor lightGrayColor];
    if (section == 0) {
        header.textLabel.text = @"Items > $50";
    }
    if (section == 1) {
        header.textLabel.text = @"Items <= $50";
    }
    return header;
    
}
//继承自UITableViewDelegate协议的方法，表示返回指定section的headerView的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
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
