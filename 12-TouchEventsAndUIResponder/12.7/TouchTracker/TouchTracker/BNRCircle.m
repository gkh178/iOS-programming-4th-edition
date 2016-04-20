//
//  BNRCircle.m
//  TouchTracker
//
//  Created by gankaihua on 16/3/1.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import "BNRCircle.h"

@implementation BNRCircle

- (CGPoint)circleCenter {
    return (CGPointMake((_point1.x + _point2.x) / 2.0, (_point1.y + _point2.y) / 2.0));//得到圆心坐标
}
- (CGFloat)circleRadius {
    CGFloat width = (_point1.x - _point2.x ? _point1.x - _point2.x : _point2.x - _point1.x);
    CGFloat height = (_point1.y - _point2.y ? _point1.y - _point2.y : _point2.y - _point1.y);
    return (width > height ? height/2.0 : width/2.0);
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    BNRCircle *circle = [[[self class] allocWithZone:zone]init];
    circle.point1 = self.point1;
    circle.point2 = self.point2;
    circle.circleCenter = self.circleCenter;
    circle.circleRadius = self.circleRadius;
    return circle;
}

@end
