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
@import CoreData;

@interface BNRItemStore ()
@property (nonatomic) NSMutableArray *privateItems;//私有可变指针，用来添加删除BNRItem对象
@property (nonatomic, strong) NSManagedObjectContext *context;//定义对象管理的上下文
@property (nonatomic, strong) NSManagedObjectModel *model;//定义指向的数据模型
@property (nonatomic, strong) NSMutableArray *allAssetTypes;//定义指向的所有的AssetTypes
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
        /*
        NSString *path = [self itemArchivePath];//得到BNRItemStore的归档路径
        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];//将归档文件解档恢复到_privateItems
        
        //如果没有归档BNRItemStore过，则创建一个新的BNRItemStore
        if (!_privateItems) {
            _privateItems = [[NSMutableArray alloc] init];
        }
         */
        
        //读取Homepwner.xcdatamodeld数据模型用来初始化BNRItemStore指向的对象模型
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];//从本程序Bundel中获取对象模型
        
        //用对象模型初始化NSPersistentStoreCoordinator对象
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:_model];
        
        //为NSPersistentStoreCoordinator对象添加持久化存储的数据库类型以及路径
        NSString *path = [self itemArchivePath];//获取对象模型需要存的SQLite路径
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        NSError *error = nil;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure" reason:[error localizedDescription] userInfo:nil];
        }
        
        //创建NSManagedObjectContext对象，并将其persistentStoreCoordinator属性指向psc
        _context = [[NSManagedObjectContext alloc]init];
        _context.persistentStoreCoordinator = psc;
        
        [self loadAllItems];//加载SQLite中所有BNRItem实体对象到BNRItemStore对象指向的内存中
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

//创建一个BNRItem对象并将其保存到SQLite中也加载到数组内存中，
- (BNRItem *) createItem {
    double order;
    //如果BNRItemStore中没有BNRItem，那么新创建的item的序号为1.0
    if ([self.allItems count] == 0) {
        order = 1.0;
    } else {
        //如果有的话，新创建的item序号为最后一个BNRItem对象的序号+1.0
        order = [[self.privateItems lastObject] orderingValue] + 1.0;
    }
    NSLog(@"Adding after %d items, order = %.2f", [self.privateItems count], order);
    
    //创建一个BNRItem并在contex内将其插入实体名为BNRItem
    BNRItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"BNRItem" inManagedObjectContext:_context];
    item.orderingValue = order;
    
    [self.privateItems addObject:item];
    return item;
}

//删除数组中某个item,同时删除其在SQLite数据
- (void)removeItem:(BNRItem *)item {
    NSString *key = item.itemKey;
    
    [[BNRImageStore sharedStore] deleteImageForKey:key];//删除对应的保存的图片
    
    [self.context deleteObject:item];
    [self.privateItems removeObjectIdenticalTo:item];
}

/*
//删除数组中指定index的item
- (void)removeItemAtIndex:(NSUInteger)index {
    if (index >= [[[BNRItemStore sharedStore]allItems]count]) {
        return;
    }
    [self.privateItems removeObjectAtIndex:index];
}
 */

//移动item的位置，同时更新其在SQLite中的orderingValue属性
- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if (fromIndex == toIndex) {
        return;
    }
    
    BNRItem *item = [self.privateItems objectAtIndex:fromIndex];
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:item atIndex:toIndex];
    
    //为移动的BNRItem对象计算新的orderingValue
    double lowerBound = 0.0;
    
    //在数组中该对象之前是否有其它对象？
    if (toIndex > 0) {
        //有的话，lowerBound设置为toIndex的上一个对象的orderingValue值
        lowerBound = [self.privateItems[toIndex - 1] orderingValue];
    } else {
        //没有的话，也即为第一个对象，设置为其后一个对象的orderingValue值-2.0
        lowerBound = [self.privateItems[1] orderingValue] - 2.0;
    }
    
    double upperBound = 0.0;
    
    //在数组中该对象之后是否有对象
    if (toIndex < [self.privateItems count] - 1) {
        //有的话，upperBound设置为toIndex的后一个对象的orderingValue值
        upperBound = [self.privateItems[toIndex + 1] orderingValue];
    } else {
        //没有的话，也即是最后一个对象，设置为其前一个对象的orderingValue值 + 2.0
        upperBound = [self.privateItems[toIndex - 1]orderingValue] + 2.0;
    }
    
    double newOrderingVaule = (lowerBound + upperBound) / 2.0;
    
    NSLog(@"moving to order %f, ", newOrderingVaule);
    item.orderingValue = newOrderingVaule;
}

//得到存取BNRItem对象的SQLite的数据库路径
- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

//将修改的BNRItem对象保存到SQLite中
- (BOOL)saveChanges
{
    /*
    NSString *path = [self itemArchivePath];
    return [NSKeyedArchiver archiveRootObject:self.privateItems
                                       toFile:path];
     */
    
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

//从SQLite中加载所有的Items到_privateItems中，到内存中
- (void)loadAllItems {
    if (!self.privateItems) {
        //创建一个NSFetchRequest对象用来加载SQLite中的BNRItem
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        
        //获取加载的实体
        NSEntityDescription *e = [NSEntityDescription entityForName:@"BNRItem" inManagedObjectContext:self.context];
        request.entity = e;
        
        //获取加载的实体用指定的属性来排序
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        request.sortDescriptors = @[sd];
        
        //用context执行NSFetchRequest对象
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!request) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        //用result初始化_privateItems，获得指定实体名为BNRItem，按照orderingValue升序排序的BNRItems对象
        self.privateItems = [[NSMutableArray alloc]initWithArray:result];
        
    }
}

- (NSArray *)allAssetTypes {
    //如果allAssetTypes为nil时，也即没有初始化，先执行初始化从SQLite中取实体名为BNRAssetType的实体
    if (!_allAssetTypes) {
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"BNRAssetType" inManagedObjectContext:_context];
        request.entity = e;
        
        NSError *error ;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        _allAssetTypes = [result mutableCopy];
    }
    
    //如果是第一次运行时，默认创建三种类型
    if ([_allAssetTypes count] == 0) {

    }
}

@end
