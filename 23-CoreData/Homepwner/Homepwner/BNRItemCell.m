//
//  BNRItemCell.m
//  Homepwner
//
//  Created by gankaihua on 16/3/5.
//  Copyright © 2016年 gankaihua. All rights reserved.
//

#import "BNRItemCell.h"

@interface BNRItemCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;//约束变量指向缓存图的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;//约束变量指向缓存图的宽度

@end

@implementation BNRItemCell

//重写方法awakeFromNib，表示BNRItemCell解档自BNRItemCell.nib文件，在新建cell时会调用到
//相当于Controller->View时候，在Controller中的初始化方法添加通知观察，而这里BNRItemCell.m是Model，BNRItemCell.xib是View
- (void)awakeFromNib {
    [self updateInterfaceForDynamicTypeSize];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(updateInterfaceForDynamicTypeSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
    
    NSLayoutConstraint *constraint =[NSLayoutConstraint constraintWithItem:self.thumbnailView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.thumbnailView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    [self.thumbnailView addConstraint:constraint];
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

- (void)updateInterfaceForDynamicTypeSize {
    //获取针对指定的文本样式对应的首选字体
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    
    static NSDictionary *imageSizeDictionary;
    
    
    if (!imageSizeDictionary) {
        imageSizeDictionary = @{UIContentSizeCategoryExtraSmall : @40,
                                UIContentSizeCategorySmall : @40,
                                UIContentSizeCategoryMedium : @40,
                                UIContentSizeCategoryLarge : @40,
                                UIContentSizeCategoryExtraLarge : @45,
                                UIContentSizeCategoryExtraLarge : @55,
                                UIContentSizeCategoryExtraExtraLarge : @65,
                                };
    }
    
    NSString *userSize = [[UIApplication sharedApplication]preferredContentSizeCategory];//获取当前用户首选字体
    NSNumber *imageSize = imageSizeDictionary[userSize];
    self.imageViewHeightConstraint.constant = [imageSize floatValue];
    //self.imageViewWidthConstraint.constant = [imageSize floatValue];
}

- (void)dealloc {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}
@end
