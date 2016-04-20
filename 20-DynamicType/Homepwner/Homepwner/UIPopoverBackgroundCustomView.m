//
//  UIPopoverBackgroundCustomView.m
//  Homepwner
//
//  Created by gankaihua on 16/3/4.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import "UIPopoverBackgroundCustomView.h"

@implementation UIPopoverBackgroundCustomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//一定要显式声明 arrowDirection和arrowOffset属性，继承自UIPopoverBackgroundView
@synthesize arrowDirection = _arrowDirection;
@synthesize arrowOffset = _arrowOffset;


//继承自<UIPopoverBackgroundViewMethods>协议的3个方法
+(CGFloat)arrowBase {
    return -5;
}
//popover的arrow的高度为10
+(CGFloat)arrowHeight {
    return 70;
}

//整个popover的background范围最大，需要显示的图在contentView部分，arrow是排除4部分（contentView与background边缘之间的部分）后剩下的background部分
//popover的contentView距离popover的background边缘宽度从上、左、下、右的距离分别为10 20 30 40
+ (UIEdgeInsets)contentViewInsets
{
    return UIEdgeInsetsMake(10, 20, 30, 40);
}

//初始化视图
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}

@end
