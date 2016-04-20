//
//  BNRItemCell.h
//  Homepwner
//
//  Created by gankaihua on 16/3/5.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNRItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;//缩略图
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//名称
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;//序列号
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;//价值
@property (nonatomic, copy) void(^actionBlock)(void);//声明一个名为actionBlock的属性，为一个函数指针

@end
