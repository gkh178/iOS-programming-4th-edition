//
//  BNRCoursesViewController.m
//  Nerdfeed
//
//  Created by gankaihua on 16/3/7.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import "BNRCoursesViewController.h"

@interface BNRCoursesViewController () <NSURLSessionDataDelegate>
@property (nonatomic, copy) NSArray *courses;//指向Model中的课程数组
@property (nonatomic) NSURLSession *session;//用来创立会话的属性

@end

@implementation BNRCoursesViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        //设置导航栏标题
        self.navigationItem.title = @"BNR Courses";
        
        //用默认Session配置初始化一个session，该session的委托为self
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    [self fetchFeed];
    
    return self;
}
//对指定的URL建立SessionDataTask并启动
- (void)fetchFeed {
    //创建NSURL
    //NSString *requestString = @"http://bookapi.bignerdranch.com/courses.json";
    NSString *requestString = @"https://bookapi.bignerdranch.com/private/courses.json";
    NSURL *url = [NSURL URLWithString:requestString];
    //用NSURL创建NSURLRequest
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    //对self.session创建NSURLSessionTask,这里为DataTask
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req
                                                     completionHandler:
                                      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                          //NSString *json = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                          //将Web Service响应的JSON数据转换为Objective-C对象
                                          NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                          //将json数据对象中的@"courses“键对应的值取出，为一个NSArray，用来初始化self.courses
                                          self.courses = jsonObject[@"courses"];
                                          NSLog(@"%@", self.courses);
                                          //修改用户界面的代码必须在主线程中执行
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [self.tableView reloadData];
                                          });
                                      }];
    //继续dataTask，刚创建时是挂起状态的
    [dataTask resume];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //对UITableView注册使用的Cell类型
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}
 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    //根据coureses包含的数组个数返回tableView行数
    return [self.courses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *course = self.courses[indexPath.row];
    cell.textLabel.text = course[@"title"];
    
    return cell;
}

//选中某行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *course = self.courses[indexPath.row];//选中的行对应的course字典
    NSURL *URL = [NSURL URLWithString:course[@"url"]];//选中的行对应的course字典中的url键的值表示代表的course的URL
    
    self.webViewController.title = course[@"title"];//选中的行对应的course字典的标题,赋给self指向的webViewController的标题
    self.webViewController.URL = URL;//用新URL赋值给self.webViewController触发其对应的setURL:方法，方法里用loadRequest加载新页面
    
    [self.navigationController pushViewController:self.webViewController animated:YES];//将webViewController入栈
}

#pragma - <NSURLSessionDataDelegate> Methods
//告诉delegate，当session执行task时收到远程服务要求session进行认证，执行completionHandler部分
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    //用用户名、密码、认证信息的有限期（这里为session存活期）创建一个NSURLCredential对象
    NSURLCredential *cred = [NSURLCredential credentialWithUser:@"BigNerdRanch" password:@"AchieveNerdvana"
                                                    persistence:NSURLCredentialPersistenceForSession];
    //NSURLSessionAuthChallengeDisposition为NSURLSessionAuthChallengeDisposition时，用cred回调completionHandler块
    completionHandler(NSURLSessionAuthChallengeUseCredential, cred);
}



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
