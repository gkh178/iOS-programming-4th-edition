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
@end
