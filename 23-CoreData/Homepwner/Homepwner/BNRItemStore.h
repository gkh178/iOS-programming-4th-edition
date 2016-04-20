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
- (void) moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;//移动某个索引的item到指定的index后
- (void) removeItem:(BNRItem *)item;//删除某个指定的item
//- (void)removeItemAtIndex:(NSUInteger)index;//删除某个指定的index的item
- (BOOL)saveChanges;//保存对BNRItem的修改，到归档路径中
- (NSArray *)allAssetTypes;//获取所有的assetTypes
@end
