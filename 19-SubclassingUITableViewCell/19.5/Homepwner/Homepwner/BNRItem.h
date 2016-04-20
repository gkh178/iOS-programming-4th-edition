//
//  BNRItem.h
//  RandomItems
//
//  Created by gankaihua on 15/12/8.
//  Copyright © 2015年 gankaihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BNRItem : NSObject <NSCoding>
{
    NSString *_itemName;
    NSString *_serialNumber;
    NSDate *_dateCreated;
    int _valueInDollars;
}

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic, readonly) NSDate *dateCreated;
@property (nonatomic, assign) int valueInDollars;
@property (nonatomic, copy) NSString *itemKey;//BNRItem对象的唯一key
@property (nonatomic, strong) UIImage *thumbnail;//BNRItem对应的缩略缓存图

//设置BNRItem的缓存缩略图
- (void)setThumbnailFromImage:(UIImage *)image;

+ (instancetype) randomItem;

- (instancetype) initWithItemName:(NSString *)itemName
                     serialNumber:(NSString *)serialNumber valueInDollars:(int)valueInDollars;
- (instancetype) initWithItemName:(NSString *)itemName serialNumber:(NSString *)serialNumber;
- (instancetype) initWithItemName:(NSString *)itemName;
@end
