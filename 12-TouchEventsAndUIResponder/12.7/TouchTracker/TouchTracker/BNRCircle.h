//
//  BNRCircle.h
//  TouchTracker
//
//  Created by gankaihua on 16/3/1.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRLine.h"
@import UIKit;

@interface BNRCircle : NSObject <NSMutableCopying>

@property (nonatomic) CGPoint circleCenter;//圆心坐标
@property (nonatomic) CGFloat circleRadius;//圆心半径
@property (nonatomic) CGPoint point1;//外接矩阵的斜对角点第一个
@property (nonatomic) CGPoint point2;//外接矩阵的斜对角点的第二个

- (CGPoint) circleCenter;
- (CGFloat) circleRadius;
@end
