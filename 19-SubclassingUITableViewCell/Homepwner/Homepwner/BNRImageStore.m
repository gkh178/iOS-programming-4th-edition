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
        _dictionary = [[NSMutableDictionary alloc] init];
        
        //创建一个NSNotificationCenter对象
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        //将BNRImageStore对象设置为来自任何对象的UIApplicationDidReceiveMemoryWarningNotification通知的观察者，内存不足时候执行clearCache:
        [nc addObserver:self
               selector:@selector(clearCache:)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];
        
    }

    return self;
}
//不允许直接调用init
- (instancetype) init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use + [BNRImageStore sharedStore]" userInfo:nil];
}



- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    self.dictionary[key] = image;
    
    //获取保存图片的全路径
    NSString *imagePath =[self imagePathForKey:key];
    //从图片企图JPEG格式数据到NSData中，图片的压缩比是0.5
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    //从JPEG格式数据写入到归档文件中
    [data writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)key
{
    //先尝试通过字典对象获取图片
    UIImage *result = self.dictionary[key];
    //如果字典对象中不存在对应的图片,则从归档文件中读取
    if (!result) {
        NSString *imagePath = [self imagePathForKey:key];
        result = [UIImage imageWithContentsOfFile:imagePath];
        
        //能够从文件中读取到图片就存入内存字典对象中
        if (result) {
            self.dictionary[key] = result;
        } else {
            NSLog(@"Error: unable to find %@", [self imagePathForKey:key]);
        }
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
    
    //根据key对应的图片的归档路径，删除缓存字典中的图片时候也需要同时删除归档文件中的图片
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
}

//获取BNRItem对象的图片根据key得到的归档路径，每个key一个路径
- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:key];
}

//内存不足时，清除内存中保存的所有key对应的图片
- (void)clearCache:(NSNotification *)note
{
    NSLog(@"flushing %d images out of the cache", [self.dictionary count]);
    [self.dictionary removeAllObjects];
}

@end
