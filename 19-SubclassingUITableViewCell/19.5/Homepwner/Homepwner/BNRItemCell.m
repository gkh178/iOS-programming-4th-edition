//
//  BNRItemCell.m
//  Homepwner
//
//  Created by gankaihua on 16/3/5.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import "BNRItemCell.h"

@implementation BNRItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//点击缩略图用popover显示当前的大图
- (IBAction)showImage:(id)sender {
    //调用Block对象前要检查对象是否存在
    if (self.actionBlock) {
        self.actionBlock();
    }
}
@end
