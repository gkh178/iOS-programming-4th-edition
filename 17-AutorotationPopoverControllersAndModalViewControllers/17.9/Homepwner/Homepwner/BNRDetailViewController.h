//
//  BNRDetailViewController.h
//  Homepwner
//
//  Created by gankaihua on 16/2/27.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BNRItem;

@interface BNRDetailViewController : UIViewController
@property (nonatomic, strong) BNRItem *item;//用来保存在BNRItemsTableViewController对象中所选中的item的数据，指向BNRItemStore对象的数组中的某个item
@property (nonatomic, copy) void(^dismissBlock)(void);//创建一个dismissBlock属性，为指向void(^)(void)类型的函数的指针
- (instancetype)initForNewItem:(BOOL)isNew;//根据是否是新建新的BNRItem来选择BNRDetailViewController对象的初始化
@end
