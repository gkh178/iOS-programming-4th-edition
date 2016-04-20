//
//  BNRItem.m
//  RandomItems
//
//  Created by gankaihua on 15/12/8.
//  Copyright © 2015年 gankaihua. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem
@synthesize itemName = _itemName;
@synthesize serialNumber = _serialNumber;
@synthesize dateCreated = _dateCreated;
@synthesize valueInDollars = _valueInDollars;

+ (instancetype) randomItem {
    NSArray *randomAdjectiveList = [NSArray arrayWithObjects:@"Fluffy", @"Rusty", @"Shiny", nil];
    NSArray *randomNounList = [NSArray arrayWithObjects:@"Bear", @"Spork", @"Mac", nil];
    NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
    NSInteger nounIndex = arc4random() % [randomNounList count];
    NSString *randomItemName = [NSString stringWithFormat:@"%@ %@",
                            randomAdjectiveList[adjectiveIndex], randomNounList[nounIndex]];
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + arc4random() % 10,
                                    'A' + arc4random() % 26,
                                    '0' + arc4random() % 10,
                                    'A' + arc4random() % 26,
                                    '0' + arc4random() % 10];
    int randomValueInDollars = arc4random() % 100;
    
    BNRItem *newItem = [[self alloc] initWithItemName:randomItemName
                                          serialNumber:randomSerialNumber valueInDollars:randomValueInDollars];
    return newItem;
}

- (instancetype) initWithItemName:(NSString *)itemName
                     serialNumber:(NSString *)serialNumber valueInDollars:(int)valueInDollars {
    if (self = [super init]) {
        self.itemName = itemName;
        self.serialNumber = serialNumber;
        self.valueInDollars = valueInDollars;
        self->_dateCreated = [[NSDate alloc ]init];
        
        //创建一个NSUUID对象，将其NSString类型的值赋给_itemKey作为唯一标示符
        NSUUID *uuid = [[NSUUID alloc]init];
        NSString *key = [uuid UUIDString];
        _itemKey = key;
    }
    return self;
}

- (instancetype) initWithItemName:(NSString *)itemName serialNumber:(NSString *)serialNumber {
    return [self initWithItemName:itemName serialNumber:serialNumber valueInDollars:0];
}

- (instancetype) initWithItemName:(NSString *)itemName {
    return [self initWithItemName:itemName serialNumber:@""];
}

- (instancetype) init {
    return [self initWithItemName:@"Item"];
}

- (NSString *) description {
    NSString *descriptionString = [NSString stringWithFormat:@"%@(%@): Worth $%d, recorded on %@",
                                   self.itemName, self.serialNumber, self.valueInDollars, self.dateCreated];
    return descriptionString;
}

//重写继承自<NSCoding>下的encodeWithCoder:方法实现BNRItem的归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.itemName forKey:@"itemName"];
    [aCoder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.itemKey forKey:@"itemKey"];
    [aCoder encodeInt:self.valueInDollars forKey:@"valueInDollars"];
    [aCoder encodeObject:self.thumbnail forKey:@"thumbnail"];
}

//重写继承自<NSCoding>下的initWithCoder:方法实现BNRItem的归档
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _itemName = [aDecoder decodeObjectForKey:@"itemName"];
        _serialNumber = [aDecoder decodeObjectForKey:@"serialNumber"];
        _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        _itemKey = [aDecoder decodeObjectForKey:@"itemKey"];
        _valueInDollars = [aDecoder decodeIntForKey:@"valueInDollars"];
        _thumbnail = [aDecoder decodeObjectForKey:@"thumbnail"];
    }
    
    return self;
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
