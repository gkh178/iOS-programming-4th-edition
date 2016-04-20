//
//  BNRItemStore.m
//  Homepwner
//
//  Created by gankaihua on 16/2/27.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"

@interface BNRItemStore ()
@property (nonatomic) NSMutableArray *privateItems;//私有可变指针，用来添加删除BNRItem对象
@end

@implementation BNRItemStore
+ (instancetype)sharedStore {
    static BNRItemStore *sharedStore = nil;
    
    //未构造单例对象时
    if (!sharedStore) {
        sharedStore = [[BNRItemStore alloc] initPrivate];
    }
    return sharedStore;
}

//私有初始化方法
- (instancetype) initPrivate {
    self = [super init];
    if (self) {
        _privateItems = [[NSMutableArray alloc]init];//初始化可变数组
    }
    return self;
}

//如果调用[[BNRItemStore alloc]init]方法时，提示使用[BNRItemStore sharedStore]
- (instancetype) init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[BNRItemStore sharedStore]" userInfo:nil];
    return nil;
}

//返回所有BNRItems的数组的指针，不可修改
- (NSArray *) allItems {
    return [self.privateItems copy];
}

//创建一个BNRItem对象并添加到数组中
- (BNRItem *) createItem {
    BNRItem *item = [BNRItem randomItem];
    [self.privateItems addObject:item];
    return item;
}

//删除数组中某个item
- (void)removeItem:(BNRItem *)item {
    [self.privateItems removeObjectIdenticalTo:item];
}

//删除数组中指定index的item
- (void)removeItemAtIndex:(NSUInteger)index {
    if (index >= [[[BNRItemStore sharedStore]allItems]count]) {
        return;
    }
    [self.privateItems removeObjectAtIndex:index];
}

//移动item
- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if (fromIndex == toIndex) {
        return;
    }
    
    BNRItem *item = [self.privateItems objectAtIndex:fromIndex];
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:item atIndex:toIndex];
}
@end
