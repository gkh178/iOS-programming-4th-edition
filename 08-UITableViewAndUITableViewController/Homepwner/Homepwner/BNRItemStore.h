//
//  BNRItemStore.h
//  Homepwner
//
//  Created by gankaihua on 16/2/27.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRItem;

@interface BNRItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;//定义一个取属性，获取BNRItemStore对象指向的所有的不可变Items
+ (instancetype) sharedStore;//定义一个类方法获取单例实例对象
- (BNRItem *) createItem;//在BNRItemStore对象指向的Array中创建一个BNRItem对象

@end
