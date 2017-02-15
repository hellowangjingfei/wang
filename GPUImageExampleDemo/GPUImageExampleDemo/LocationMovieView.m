//
//  LocationMovieView.m
//  GPUImageExampleDemo
//
//  Created by wangXiao on 16/11/18.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import "LocationMovieView.h"
#import "GPUImage.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define kScreemWidth  [UIScreen mainScreen].bounds.size.width
#define kScreemHeight  [UIScreen mainScreen].bounds.size.height
@implementation LocationMovieView
{

    
    GPUImageGrayscaleFilter *grayFilter;
    GPUImageMovieWriter *vedioWriter;
    GPUImageView *vedioImgView;
    //GPUImageVignetteFilter                  //晕影，形成黑色圆形边缘，突出中间图像的效果
    GPUImageVignetteFilter *vignetterFilter;
    //GPUImagePolarPixellateFilter  同心圆像素化
    GPUImagePolarPixellateFilter *polarPixellateFilter;
    //GPUImageSwirlFilter  旋涡
    GPUImageSwirlFilter *swirlFilter;
    
    GPUImageUIElement *imgUIElement;
    //透明
    GPUImageAlphaBlendFilter *alphaBlendFilter;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self localVideoProcessing];
        [self createSliderView];
    }
    return self;
}
- (void)localVideoProcessing
{
    NSURL *vedioURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"手机QQ视频_20161118091205" ofType:@"mp4"]];
    
    //创建滤镜处理视频的载体
    _imgMovie = [[GPUImageMovie alloc] initWithURL:vedioURL];
    
    //runBenchMark-----------控制台打印current frame，就是视频处理到那一秒，只是控制台输出，YES是输出，NO是不输出
    _imgMovie.runBenchmark = NO;
    //控制GPUImageView预览视频时的速度是否要保持真是的速度。如果设为NO，则会将视频的所有帧无间隔渲染，速度导致非常快。设置为YES，则会根据视频本身时长计算出每帧的时间间隔，然后每泫然一帧，就sleep一个时间间隔，从而达到正常的播放速度
    _imgMovie.playAtActualSpeed = YES;
    
    //控制视频是否循环播放
    /*
     当你不想预览，而是想将处理过的结果输出到文件时，步骤类似，只是不再需要创建GPUImageView,而是需要一个GPUImageMovieWriter
     */
    _imgMovie.shouldRepeat = NO;
    
  
//    //创建视频处理过滤器------灰度处理
//    grayFilter = [[GPUImageGrayscaleFilter alloc] init];
//    
//    //放入视频处理器的载体中，等待处理
//    [_imgMovie addTarget:grayFilter];
//    vedioImgView = [[GPUImageView alloc] initWithFrame:CGRectMake(10, 70, kScreemWidth - 20, 300)];
//    [self addSubview:vedioImgView];
//    
//    [grayFilter addTarget:vedioImgView];
//    
    //滤镜组
    _filterGroup = [[GPUImageFilterGroup alloc] init];
    
    
    _imgMovie.delegate = self;
    
    //晕影
    vignetterFilter = [[GPUImageVignetteFilter alloc] init];
   
    [self addGPUImageFilter:vignetterFilter];
    
    //同心圆像素化
    polarPixellateFilter = [[GPUImagePolarPixellateFilter alloc] init];
    [self addGPUImageFilter:polarPixellateFilter];
   
    
    //旋涡
    swirlFilter = [[GPUImageSwirlFilter alloc] init];
    [self addGPUImageFilter:swirlFilter];
//
    
    vedioImgView = [[GPUImageView alloc] initWithFrame:CGRectMake(10, 70, kScreemWidth - 20, 300)];
    [self addSubview:vedioImgView];
    
    [_imgMovie addTarget:_filterGroup];
    
    [_filterGroup addTarget:vedioImgView];
    
    [_imgMovie addTarget:vedioImgView];
    
    
//        //输出使用视频（使用GPUImageMovieWriter）
//        NSString *pathToTempMov = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tempMovie.mov"];
//        //unlink 是c语言中的函数----------如果本地存在该路径指定的文件，就会删除重置文件的内容
//        unlink([pathToTempMov UTF8String]);
//    
//        NSURL *outputPath = [NSURL fileURLWithPath:pathToTempMov];
//    
//        vedioWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:outputPath size:vedioImgView.frame.size];
//        //判断是否存在滤镜效果 grayFilter
////        if ((NSNull *)grayFilter != [NSNull null] && grayFilter != nil) {
////            //滤镜上添加写入者（GPUImageMovie）
////            [grayFilter addTarget:vedioWriter];
////        }else{
////            //视频处理器（GPUImageMovie）上添加写入者（GPUImageMovieWriter）
////            [_imgMovie addTarget:vedioWriter];
////        }
//       [_filterGroup addTarget:vedioWriter];
//        //是否允许视频声音通过
//        vedioWriter.shouldPassthroughAudio = YES;
//    
//        //如果允许视频声音通过，设置声音源
//        _imgMovie.audioEncodingTarget = vedioWriter;
//    
//        //保存所有的视频帧和音频样本
//        [_imgMovie enableSynchronizedEncodingUsingMovieWriter:vedioWriter];
//    
//        //写入者开始录制
//        [vedioWriter startRecording];
    
    //视频载体开始处理（可以理解为开始播放，就是写入开始录制，视频载体本身开始播放，把每一帧都拍下来）
       [_imgMovie startProcessing];
    
//        [vedioWriter setCompletionBlock:^{
////            if ((NSNull *)grayFilter != [NSNull null] && grayFilter != nil) {
////                //移除写入者滤镜中
//////                [grayFilter removeTarget:vedioWriter];
////            }else{
////                //移除写入者从视频载体中（主要是为了节省资源）
////                [_imgMovie removeTarget:vedioWriter];
////            }
//            [_filterGroup removeTarget:vedioWriter];
//            //录制完毕要关闭录制动作
//            [vedioWriter finishRecordingWithCompletionHandler:^{
//                //保存视频
//                UISaveVideoAtPathToSavedPhotosAlbum(pathToTempMov, nil, nil, nil);
//            }];
//            
//            [vedioWriter setFailureBlock:^(NSError *error) {
//                NSLog(@"%@",[error description]);
//            }];
//        }];
}
- (void)didCompletePlayingMovie
{
    NSLog(@"处理完成");
}
//创建进度条
- (void)createSliderView
{
    NSArray *sliderArr = @[@[@"晕影:",@"0.0",@"0.75",@"1.0"],@[@"同心圆像素化:",@"0.0",@"0.25",@"1.0"],@[@"旋涡:",@"0.0",@"0.5",@"1.0"]];
    for (int i = 0; i < sliderArr.count; i++) {
        NSArray *newArr = [sliderArr objectAtIndex:i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 400 + 60 * i, 100, 50)];
        label.text = [newArr objectAtIndex:0];
        [self addSubview:label];
        
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(80, 400 + 60 * i, kScreemWidth - 90, 50)];
        slider.tag = 300 + i;
        slider.minimumValue = [[newArr objectAtIndex:1] floatValue];
        slider.value = [[newArr objectAtIndex:2] floatValue];
        slider.maximumValue = [[newArr objectAtIndex:3] floatValue];
        [slider addTarget:self action:@selector(sliderChangeValue:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:slider];
    }
}
//创建滤镜组
- (void)addGPUImageFilter:(GPUImageOutput<GPUImageInput> *)filter
{
    [_filterGroup addFilter:filter];
    GPUImageOutput<GPUImageInput> *newTerminalFilter = filter;
    NSInteger count = _filterGroup.filterCount;
    
    if (count == 1) {
        _filterGroup.initialFilters = @[newTerminalFilter];
        _filterGroup.terminalFilter = newTerminalFilter;
    }else{
        GPUImageOutput<GPUImageInput> *terminalFilter = _filterGroup.terminalFilter;
        NSArray *initialFilters = _filterGroup.initialFilters;
        
        [terminalFilter addTarget:newTerminalFilter];
        _filterGroup.initialFilters = @[initialFilters[0]];
        _filterGroup.terminalFilter = newTerminalFilter;
    }
}
- (void)sliderChangeValue:(UISlider *)slider
{
    if (slider.tag == 300) {
        [vignetterFilter setVignetteEnd:slider.value];
    }else if (slider.tag == 301){
        [polarPixellateFilter setPixelSize:CGSizeMake(slider.value, slider.value)];
    }else if (slider.tag == 302){
        [swirlFilter setRadius:slider.value];
    }
}
@end
