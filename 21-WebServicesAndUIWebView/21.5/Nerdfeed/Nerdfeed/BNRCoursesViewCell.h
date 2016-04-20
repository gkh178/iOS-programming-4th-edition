//
//  BNRCoursesViewCell.h
//  Nerdfeed
//
//  Created by gankaihua on 16/3/7.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNRCoursesViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *courseName;
@property (weak, nonatomic) IBOutlet UILabel *courseStartDate;
@property (weak, nonatomic) IBOutlet UILabel *courseEndDate;
@property (weak, nonatomic) IBOutlet UILabel *courseLocation;
@property (weak, nonatomic) IBOutlet UILabel *courseInstructors;
@end
