//
//  BNRContainer.h
//  RandomItems
//
//  Created by gankaihua on 15/12/8.
//  Copyright © 2015年 gankaihua. All rights reserved.
//

#import "BNRItem.h"

@interface BNRContainer : BNRItem
@property (nonatomic, strong) NSMutableArray *subitems;
@property (nonatomic, copy) NSString *containerName;
@property (nonatomic, assign) int containerValueInDollars;
@property (nonatomic, readonly) int allValueInDollars;

+ (instancetype) randomContainer;
- (instancetype) initWithSubitems:(NSMutableArray *)subitems containerName:(NSString *)name containerValueInDollars:(int)value;
- (instancetype) initWithSubitems:(NSMutableArray *)subitems containerName:(NSString *)name;
- (instancetype) initWithSubitems:(NSMutableArray *)subitems;

@end
