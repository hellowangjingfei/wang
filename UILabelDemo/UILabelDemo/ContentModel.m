//
//  ContentModel.m
//  UILabelDemo
//
//  Created by wangjingfei on 2017/1/3.
//  Copyright © 2017年 wangXiao. All rights reserved.
//

#import "ContentModel.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation ContentModel

- (CGFloat)contentHeight:(NSString *)contentTitle withContentWidth:(CGFloat)contentWidth withIsOpen:(BOOL)isOpen
{
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.text = contentTitle;
    CGRect rect;
    if (isOpen == YES) {
        rect = [label textRectForBounds:CGRectMake(0, 0, contentWidth, 1000) limitedToNumberOfLines:0];
    }else{
        rect = [label textRectForBounds:CGRectMake(0, 0, kScreenWidth, 1000) limitedToNumberOfLines:3];
    }
    return rect.size.height;
}
@end
