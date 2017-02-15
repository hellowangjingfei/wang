//
//  VideoCameraView.h
//  GPUImageExampleDemo
//
//  Created by wangXiao on 16/11/17.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface VideoCameraView : UIView

//录制视频
@property (nonatomic,strong) GPUImageVideoCamera *vedioCamera;

//饱和度
@property (nonatomic,strong) GPUImageOutput<GPUImageInput> *saturationfilter;
//球形倒立效果-------GPUImageSphereRefractionFilter
@property (nonatomic,strong) GPUImageOutput<GPUImageInput> *sphereRefractionFilter;
//怀旧效果------------GPUImageSepiaFilter
@property (nonatomic,strong) GPUImageOutput<GPUImageInput> *sepiaFilter;

@property (nonatomic,strong) GPUImageMovieWriter *movieWriter;

@property (nonatomic,strong) GPUImageView *filterVideoView;

//滤镜组
@property (nonatomic,strong) GPUImageFilterGroup *filterGroup;

@property (nonatomic,strong) CALayer *focusLayer;

//视频存储的路径
@property (nonatomic,copy) NSString *vedioPath;

//定时器
@property (nonatomic,strong) NSTimer *vedioTimer;

@property (nonatomic,strong) NSDate *fromdate;

//时间Label
@property (nonatomic,strong) UILabel *timeLabel;

@end
