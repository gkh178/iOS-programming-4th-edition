//
//  BNRImageStore.m
//  Homepwner
//
//  Created by gankaihua on 16/2/28.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import "BNRImageStore.h"

@interface BNRImageStore ()
@property (nonatomic, strong) NSMutableDictionary *dictionary;//用来保存key-image的可变字典

@end

@implementation BNRImageStore

//单例对象初始化
+ (instancetype)sharedStore {
    static BNRImageStore *sharedStore = nil;
    /*
    if (!sharedStore) {
        sharedStore = [[self alloc]initPrivate];
    }
     */
    
    static dispatch_once_t onceToken;//创建一个NSPredicate谓词对象oneToken
    //确保多线程应用下只创建一次sharedStore，这里执行一次block
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc]initPrivate];
    });
    
    return sharedStore;
}
//私有初始化方法
- (instancetype) initPrivate {
    self = [super init];
    if (self) {
        self.dictionary = [[NSMutableDictionary alloc]init];
        
        //新建一个NSNotificationCenter对象，也称 通知中心
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        //将BNRItemImageStore对象添加为观察者，当该对象收到任何来源对象的UIApplicationDidReceiveMemoryWarningNotification通知时，执行clearCache:
        [nc addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    
    return self;
}
//不允许直接调用init
- (instancetype) init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use + [BNRImageStore sharedStore]" userInfo:nil];
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    self.dictionary[key] = image;
    
    //获取保存key对应的图片的保存路径
    NSString *imagePath = [self imagePathForKey:key];
    //从图片提取JPEG格式的数据写入NSData,压缩比为0.5
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    //将JPEG格式的数据写入归档文件路径
    [data writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)key {
    //先尝试在内存缓冲区中通过字典对象获取key对应的图片
    UIImage *result = _dictionary[key];
    
    //没有找到对应的图片就从文件中解档
    if (!result) {
        NSString *imagePath = [self imagePathForKey:key];
        
        //通过文件创建UIImage对象
        result = [UIImage imageWithContentsOfFile:imagePath];
        
        if (result) {
            self.dictionary[key] = result;
        }
        else {
            NSLog(@"Error: Unable to find %@", [self imagePathForKey:key]);
        }
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)key {
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
    //接着归档路径中key对应的图片
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
}

//创建每个BNRItem对应的图片的归档文件路径，每个图片一个路径
- (NSString *)imagePathForKey:(NSString *)key {
    NSArray *documentDirctories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirctories firstObject];
    return [documentDirectory stringByAppendingPathComponent:key];
}

//内存不足时，清除所有的BNRItems对应的图片释放内存,需要时从归档文件中解档使用
- (void)clearCache:(NSNotification *)note {
    NSLog(@"flushing %d images out of the cache", [self.dictionary count]);
    [self.dictionary removeAllObjects];
}

@end
