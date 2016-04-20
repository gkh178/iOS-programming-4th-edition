//
//  BNRImageTransformer.m
//  Homepwner
//
//  Created by gankaihua on 16/3/8.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import "BNRImageTransformer.h"
#import <UIKit/UIKit.h>

@implementation BNRImageTransformer

//返回关系数据库中的可变类型属性和OC对象之间的转换后的类型
+ (Class)transformedValueClass {
    return [NSData class];
}

//获取转换后的值，UIImage value->NSDate value  到数据库。
//coreData在存储transformable类型的实体属性时，会调用transformadValue:将其转为为NSData可以存储的类型
- (id)transformedValue:(id)value {
    if (!value) {
        return nil;
    }
    
    //如果值的类型为NSData直接返回
    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }
    
    //如果值的类型不是NSData返回对UIImage类型的值转换为NSData后的值
    return UIImagePNGRepresentation(value);
}

//获取反转换后的值  NSDate value-> UIImage value ->OC对象
//coreData在恢复thumbnail的值时会调用reverseTransformedValue:方法从数据库中由NSData转换为UIImage类型
-(id)reverseTransformedValue:(id)value {
    return  [UIImage imageWithData:value];
}

@end
