//
//  BNRItem.h
//  RandomItems
//
//  Created by gankaihua on 15/12/8.
//  Copyright © 2015年 gankaihua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject {
    NSString *_itemName;
    NSString *_serialNumber;
    NSDate *_dateCreated;
    int _valueInDollars;
}

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic, readonly) NSDate *dateCreated;
@property (nonatomic, assign) int valueInDollars;

+ (instancetype) randomItem;

- (instancetype) initWithItemName:(NSString *)itemName
                     serialNumber:(NSString *)serialNumber valueInDollars:(int)valueInDollars;
- (instancetype) initWithItemName:(NSString *)itemName serialNumber:(NSString *)serialNumber;
- (instancetype) initWithItemName:(NSString *)itemName;
@end
