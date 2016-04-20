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
        
    }
    return self;
}

@end
