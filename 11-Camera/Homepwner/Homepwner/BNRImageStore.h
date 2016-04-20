//
//  BNRImageStore.h
//  Homepwner
//
//  Created by gankaihua on 16/2/28.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BNRImageStore : NSObject
+ (instancetype) sharedStore;//初始化一个单例实例保存所有图片
- (void)setImage:(UIImage *)image forKey:(NSString *)key;//根据key设置保存的图片
- (UIImage *) imageForKey:(NSString *)key;//根据key获得保存的图片
- (void) deleteImageForKey:(NSString *)key;//根据key删除所对应的图片

@end
