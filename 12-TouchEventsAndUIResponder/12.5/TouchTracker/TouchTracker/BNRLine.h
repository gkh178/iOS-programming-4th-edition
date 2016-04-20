//
//  BNRLine.h
//  TouchTracker
//
//  Created by gankaihua on 16/2/29.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface BNRLine : NSObject <NSCoding>
@property (nonatomic) CGPoint begin;//点的开始坐标
@property (nonatomic) CGPoint end;//点的结束坐标

@end
