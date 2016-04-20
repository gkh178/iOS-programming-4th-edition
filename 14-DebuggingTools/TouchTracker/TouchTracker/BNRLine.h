//
//  BNRLine.h
//  TouchTracker
//
//  Created by gankaihua on 16/2/29.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface BNRLine : NSObject
@property (nonatomic) CGPoint begin;//点的开始坐标
@property (nonatomic) CGPoint end;//点的结束坐标
@property (nonatomic) float width;//线的宽带

@property (nonatomic, strong) NSMutableArray *containingArray;//用来测试跟finishedLines数组相互强引用导致的内存泄露
@end
