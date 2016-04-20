//
//  BNRLine.m
//  TouchTracker
//
//  Created by gankaihua on 16/2/29.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import "BNRLine.h"

@implementation BNRLine

//对于自定义的类，要实现归档功能必须实现继承自<NSCoding>的如下方法，将本对象的各个成员变量归档保存
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeCGPoint:_begin forKey:@"beginPoint"];
    [aCoder encodeCGPoint:_end forKey:@"endPoint"];
}

//对于自定义的类，要实现解档功能必须实现继承自<NSCoding>的如下方法，将档案中的各个成员变量恢复到本对象的成员变量
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        self.begin = [aDecoder decodeCGPointForKey:@"beginPoint"];
        self.end = [aDecoder decodeCGPointForKey:@"endPoint"];
    }
    return self;
}

@end


