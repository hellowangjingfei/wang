//
//  WaterMarkImageView.h
//  GPUImageExampleDemo
//
//  Created by wangXiao on 16/11/16.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterMarkImageView;
@protocol WaterMarkImageViewDelegate <NSObject>

- (void)removeCurrentImageView:(WaterMarkImageView *)markImgView;

@end

@interface WaterMarkImageView : UIImageView<WaterMarkImageViewDelegate>

- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)img;

//隐藏边框和删除删除按钮
- (void)removeDeleteBtnAndBorder;

//显示边框和删除按钮
- (void)displayDeleteBtnAndBorder:(WaterMarkImageView *)imgView;

@property (nonatomic,strong) UIImage *displayImage;

@property (nonatomic,assign) CGRect  targetRect;

@property (nonatomic,assign) CGRect  currenRect;

//判断按钮是否隐藏
@property (nonatomic,assign)BOOL isHideYOrN;

@property (nonatomic,weak) id<WaterMarkImageViewDelegate> delegate;

@end
