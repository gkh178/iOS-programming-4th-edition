//
//  BNRItem.m
//  Homepwner
//
//  Created by gankaihua on 16/3/8.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem

// Insert code here to add functionality to your managed object subclass

//当BNRItem对象插入数据库时，会收到如下消息
-(void)awakeFromInsert {
    //先执行父类对象NSManagedObject的方法
    [super awakeFromInsert];
    
    //在插入对象时，初始化其dateCreated属性和itemKey属性
    self.dateCreated = [NSDate date];
    
    //创建NSUUID对象
    NSUUID *uuid = [[NSUUID alloc]init];
    NSString *key = [uuid UUIDString];
    self.itemKey = key;
}

- (void)setThumbnailFromImage:(UIImage *)image {
    if (image) {
        CGSize origImageSize = image.size;//获取原始图的长度 宽度
        
        //缩略图的大小和位置
        CGRect newRect = CGRectMake(0, 0, 40, 40);
        
        //确定缩放倍数并保持宽高比不变,这里选择长宽中被缩放少的那个比例
        float ratio =MAX(newRect.size.width / origImageSize.width, newRect.size.height / origImageSize.height);
        
        //根据当前设备的屏幕的scaling factor(0.0)创建一个透明的位图上下文，大小为newRect的大小
        UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
        
        //在newRect位置创建一个表示圆角矩形的UIBezierPath对象，圆角矩形的4个边角的半径为5.0
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
        //根据UIBezierPath对象，裁剪为当前的图形上下文
        [path addClip];
        
        //让图片在缩略图绘制范围内居中
        CGRect projectRect;
        projectRect.size.width = ratio * origImageSize.width;
        projectRect.size.height = ratio * origImageSize.height;
        projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
        projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
        
        //在上下文中绘制图片
        [image drawInRect:projectRect];
        
        //通过图形上下文得到UIImage对象，并将其赋给thumbnail属性
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        self.thumbnail = smallImage;
        
        //清理当前图形上下文
        UIGraphicsEndImageContext();
    }
}


@end
