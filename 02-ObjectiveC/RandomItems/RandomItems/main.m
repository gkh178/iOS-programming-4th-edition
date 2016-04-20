//
//  main.m
//  RandomItems
//
//  Created by gankaihua on 15/12/8.
//  Copyright © 2015年 gankaihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"
#import "BNRContainer.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSMutableArray *containers = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 5; ++i) {
            BNRContainer *container = [BNRContainer randomContainer];
            [containers addObject:container];
        }
        
        for (id ct in containers) {
            NSLog(@"%@", ct);
        }
    }
    return 0;
}
