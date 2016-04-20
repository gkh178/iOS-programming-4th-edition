//
//  BNRItem.h
//  Homepwner
//
//  Created by gankaihua on 16/3/8.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNRItem : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

- (void)setThumbnailFromImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END

#import "BNRItem+CoreDataProperties.h"
