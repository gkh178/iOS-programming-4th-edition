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
    if (!sharedStore) {
        sharedStore = [[self alloc]initPrivate];
    }
    return sharedStore;
}
//私有初始化方法
- (instancetype) initPrivate {
    self.dictionary = [[NSMutableDictionary alloc]init];
    return self;
}
//不允许直接调用init
- (instancetype) init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use + [BNRImageStore sharedStore]" userInfo:nil];
}



- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    self.dictionary[key] = image;
}

- (UIImage *)imageForKey:(NSString *)key {
    return _dictionary[key];
}

- (void)deleteImageForKey:(NSString *)key {
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
}

@end
