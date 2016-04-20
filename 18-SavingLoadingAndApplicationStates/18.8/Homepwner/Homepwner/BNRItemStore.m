//
//  BNRItemStore.m
//  Homepwner
//
//  Created by gankaihua on 16/2/27.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@interface BNRItemStore ()
@property (nonatomic) NSMutableArray *privateItems;//私有可变指针，用来添加删除BNRItem对象
@end

@implementation BNRItemStore
+ (instancetype)sharedStore {
    static BNRItemStore *sharedStore = nil;
    
    //使用dispatch_once初始化线程安全的单例变量
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        sharedStore = [[BNRItemStore alloc]initPrivate];
    });
    return sharedStore;
}

//私有初始化方法
- (instancetype) initPrivate {
    self = [super init];
    
    if (self) {
        NSString *path = [self itemArchivePath];//得到BNRItemStore的归档路径
        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];//将归档文件解档恢复到_privateItems
        
        //如果没有归档BNRItemStore过，则创建一个新的BNRItemStore
        if (!_privateItems) {
            _privateItems = [[NSMutableArray alloc] init];
        }
    }
    return  self;
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
    //BNRItem *item = [BNRItem randomItem];
    BNRItem *item = [[BNRItem alloc]init];
    
    [self.privateItems addObject:item];
    return item;
}

//删除数组中某个item，删除item时同时删除其在BNRItemStore中对应的itemKey-image键值
- (void)removeItem:(BNRItem *)item {
    NSString *key = item.itemKey;
    
    [[BNRImageStore sharedStore] deleteImageForKey:key];//删除对应的保存的图片
    
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

//得到BNRItem对象的归档路径
- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

//将BNRItem对象归档到路径文件中
- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    return [NSKeyedArchiver archiveRootObject:self.privateItems
                                       toFile:path];
    
}
@end
