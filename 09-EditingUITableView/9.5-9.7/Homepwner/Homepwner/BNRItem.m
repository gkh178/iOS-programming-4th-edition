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
@end
