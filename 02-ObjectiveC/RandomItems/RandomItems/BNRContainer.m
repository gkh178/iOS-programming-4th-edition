//
//  BNRContainer.m
//  RandomItems
//
//  Created by gankaihua on 15/12/8.
//  Copyright © 2015年 gankaihua. All rights reserved.
//

#import "BNRContainer.h"

@implementation BNRContainer

- (int) allValueInDollars {
    int subitemsValueInDollars = 0;
    for (id item in self.subitems) {
        subitemsValueInDollars += [item valueInDollars];
    }
    return self.containerValueInDollars + subitemsValueInDollars;
}

+ (instancetype) randomContainer {
    int indexOfItems = arc4random() % 10;
    NSMutableArray *subitemsArray = [[NSMutableArray alloc]initWithCapacity:(indexOfItems + 1)];
    for (int i = 0; i <= indexOfItems; ++i) {
        BNRItem *it = [BNRItem randomItem];
        subitemsArray[i] = it;
    }
    
    NSArray *nameArray = [NSArray arrayWithObjects:@"First", @"Second", @"Third", @"Fourth", @"Fifth",
                         @"Sixth", @"Seventh", @"Eighth", @"Ninth", nil];
    int nameIndex = arc4random() % [nameArray count];
    
    int value = arc4random() % 100;

    BNRContainer *container = [[BNRContainer alloc] initWithSubitems:subitemsArray containerName:nameArray[nameIndex] containerValueInDollars:value];
    return container;
}

- (instancetype) initWithSubitems:(NSMutableArray *)subitems containerName:(NSString *)name containerValueInDollars:(int)value {
    if (self = [super init]) {
        self.subitems = subitems;
        self.containerName = [name copy];
        self.containerValueInDollars = value;
    }
    return self;
}

- (instancetype) initWithSubitems:(NSMutableArray *)subitems containerName:(NSString *)name {
    return [self initWithSubitems:subitems containerName:name containerValueInDollars:0];
}

- (instancetype) initWithSubitems:(NSMutableArray *)subitems {
    return [self initWithSubitems:subitems containerName:@""];
}

- (instancetype) init {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    return [self initWithSubitems:array];
}

- (NSString *) description {
    NSString *descriptionString = [NSString stringWithFormat:@"BNRContainer对象的名字为：%@，价值为：%d，总价值为：%d，包含的BNRItem对象有：%@",
                                   self.containerName, self.containerValueInDollars , self.allValueInDollars, self.subitems];
    return descriptionString;
}
@end
