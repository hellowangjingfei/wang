//
//  ContentModel.h
//  UILabelDemo
//
//  Created by wangjingfei on 2017/1/3.
//  Copyright © 2017年 wangXiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ContentModel : NSObject

@property (nonatomic,copy) NSString *content;

@property (nonatomic,assign) BOOL isOpen;

- (CGFloat)contentHeight:(NSString *)contentTitle withContentWidth:(CGFloat)contentWidth withIsOpen:(BOOL)isOpen;

@end
