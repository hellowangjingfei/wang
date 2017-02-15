//
//  VideoCameraView.m
//  GPUImageExampleDemo
//
//  Created by wangXiao on 16/11/17.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import "VideoCameraView.h"

#define kScreemWidth  [UIScreen mainScreen].bounds.size.width
#define kScreemHeight  [UIScreen mainScreen].bounds.size.height
@implementation VideoCameraView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createVedioView];
        [self createSliderView];
    }
    return self;
}
//创建录制视频的视图
- (void)createVedioView
{
    
    /*
     AVCaptureDevicePosition:
     AVCaptureDevicePositionUnspecified         = 0,
     AVCaptureDevicePositionBack                = 1,
     AVCaptureDevicePositionFront               = 2
     
     */
    _vedioCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1920x1080 cameraPosition:AVCaptureDevicePositionBack];
//    _vedioCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
//    _vedioCamera.horizontallyMirrorRearFacingCamera = NO;
//    _vedioCamera.horizontallyMirrorFrontFacingCamera = NO;
    
    
    [_vedioCamera addAudioInputsAndOutputs];
    
    _filterVideoView = [[GPUImageView alloc] initWithFrame:CGRectMake(10, 70, kScreemWidth - 20, 200)];
    _filterVideoView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_filterVideoView];
    
    //初始化滤镜组
    _filterGroup = [[GPUImageFilterGroup alloc] init];
    [_vedioCamera addTarget:_filterGroup];
    

    
    //饱和度---------GPUImageSaturationFilter
    _saturationfilter = [[GPUImageSaturationFilter alloc] init];
    [self addGPUImageFilter:_saturationfilter];
    //球形倒立效果---------GPUImageSphereRefractionFilter
    _sphereRefractionFilter = [[GPUImageSphereRefractionFilter alloc] init];
    [self addGPUImageFilter:_sphereRefractionFilter];
    //怀旧效果------------GPUImageSepiaFilter
    _sepiaFilter = [[GPUImageSepiaFilter alloc] init];
    [self addGPUImageFilter:_sepiaFilter];
    
    [_filterGroup addTarget:_filterVideoView];
    
    [_vedioCamera addTarget:_filterVideoView];
    
//    [_vedioCamera addTarget:_saturationfilter];
//    [_saturationfilter addTarget:_filterVideoView];
//
//    [_vedioCamera addTarget:_sphereRefractionFilter];
//    [_sphereRefractionFilter addTarget:_filterVideoView];
//
//    [_vedioCamera addTarget:_sepiaFilter];
//    [_sepiaFilter addTarget:_filterVideoView];
    
    [_vedioCamera startCameraCapture];
    
    //时间Label
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreemWidth - 100) / 2, 10, 100, 20)];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.text = @"00:00:00";
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [_filterVideoView addSubview:_timeLabel];
    
    //添加手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraViewTapClick:)];
    //手指的个数
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.numberOfTapsRequired = 1;
    [_filterVideoView addGestureRecognizer:tapGesture];

    
    //添加按钮
    NSArray *nameArr = @[@"开始",@"停止并保存"];
    for (int i = 0; i < nameArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat widthBtn = (kScreemWidth - 30) / nameArr.count;
        btn.frame = CGRectMake(10 + (widthBtn + 10) * i,280, widthBtn, 50);
        btn.backgroundColor = [UIColor blackColor];
        [btn setTitle:[nameArr objectAtIndex:i] forState:UIControlStateNormal];
        btn.tag = 200 + i;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
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
//创建进度条
- (void)createSliderView
{
    //
    NSArray *sliderArr = @[@[@"饱和度:",@"0.0",@"1.0",@"2.0"],@[@"球形倒立效果:",@"0.0",@"0.25",@"1.0"],@[@"怀旧效果:",@"0.0",@"0.5",@"1.0"]];
    for (int i = 0; i < sliderArr.count; i++) {
        NSArray *newArr = [sliderArr objectAtIndex:i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 340 + 60 * i, 100, 50)];
        label.text = [newArr objectAtIndex:0];
        [self addSubview:label];
        
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(80, 340 + 60 * i, kScreemWidth - 90, 50)];
        slider.tag = 300 + i;
        slider.minimumValue = [[newArr objectAtIndex:1] floatValue];
        slider.value = [[newArr objectAtIndex:2] floatValue];
        slider.maximumValue = [[newArr objectAtIndex:3] floatValue];
        [slider addTarget:self action:@selector(sliderChangeValue:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:slider];
    }
}
- (void)sliderChangeValue:(UISlider *)slider
{
    if (slider.tag == 300) {
          [(GPUImageSaturationFilter *)_saturationfilter setSaturation:[slider value]];
    }else if (slider.tag == 301){
          [(GPUImageSphereRefractionFilter *)_sphereRefractionFilter setRadius:slider.value];
    }else if (slider.tag == 302){
          [(GPUImageSepiaFilter *)_sepiaFilter setIntensity:slider.value];
    }
}
//开始----------停止
- (void)buttonClick:(UIButton *)btn
{
    if (btn.tag == 200) {
        [self startRecording];
    }else if (btn.tag == 201){
        [self stopRecording];
    }
}
//开始录制
- (void)startRecording
{
    _vedioPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    //如果文件已经存在,AVAssetWriter不会让你记录新帧,所以删除旧的电影
    unlink([_vedioPath UTF8String]);
    NSURL *vedioURL = [NSURL fileURLWithPath:_vedioPath];
    _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:vedioURL size:CGSizeMake(kScreemWidth ,kScreemHeight)];
    _movieWriter.encodingLiveVideo = YES;
    _movieWriter.shouldPassthroughAudio = YES;
    [_filterGroup addTarget:_movieWriter];
    _vedioCamera.audioEncodingTarget = _movieWriter;
    //开始录制
    [_movieWriter startRecording];
    _fromdate = [NSDate date];
    _vedioTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(recordingTime:) userInfo:nil repeats:YES];
}
//停止录制并保存在本地
- (void)stopRecording
{
    _vedioCamera.audioEncodingTarget = nil;
    UISaveVideoAtPathToSavedPhotosAlbum(_vedioPath, nil, nil, nil);
    [_movieWriter finishRecording];
    [_filterGroup removeTarget:_movieWriter];
    _timeLabel.text = @"00:00:00";
    [_vedioTimer invalidate];
    _vedioTimer = nil;
//    [_movieWriter cancelRecording];
}
//定时器
- (void)recordingTime:(NSTimer *)timer
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate *currenTime = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFalgs = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unitFalgs fromDate:_fromdate toDate:currenTime options:NSCalendarWrapComponents];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate  *dateTimer = [gregorian dateFromComponents:components];
    NSString *date = [dateFormatter stringFromDate:dateTimer];
    _timeLabel.text = date;
    
}
- (void)cameraViewTapClick:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateRecognized && (_focusLayer == NO || _focusLayer.hidden)) {
        CGPoint location = [tapGesture locationInView:_filterVideoView];
        [self createFocusImage];
        [self layerAnimationWithPoint:location];
        AVCaptureDevice *device = _vedioCamera.inputCamera;
        CGPoint pointOfInterest = CGPointMake(0.5f, 0.5f);
        CGSize frameSize = [_filterVideoView frame].size;
        
        if ([_vedioCamera cameraPosition] == AVCaptureDevicePositionFront) {
            location.x = frameSize.width - location.x;
        }
        pointOfInterest = CGPointMake(location.y / frameSize.height, 1.0f - (location.x / frameSize.width));
        
        if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            NSError *error;
            if ([device lockForConfiguration:&error]) {
                [device setFocusPointOfInterest:pointOfInterest];
                [device setFocusMode:AVCaptureFocusModeAutoFocus];
                if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
                    [device setExposurePointOfInterest:pointOfInterest];
                    [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
                }
                [device unlockForConfiguration];
            }else{
                NSLog(@"Error ========= %@",error);
            }
        }
    }
}
- (void)createFocusImage
{
    UIImage *img = [UIImage imageNamed:@"96.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    imgView.image = img;
    CALayer *layer = imgView.layer;
    layer.hidden = YES;
    [_filterVideoView.layer addSublayer:layer];
    _focusLayer = layer;
}
- (void)layerAnimationWithPoint:(CGPoint)point
{
    if (_focusLayer) {
        CALayer *focusLayer = _focusLayer;
        focusLayer.hidden = NO;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [focusLayer setPosition:point];
        focusLayer.transform = CATransform3DMakeScale(2.0f, 2.0f, 1.0f);
        [CATransaction commit];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)];
        animation.delegate = self;
        animation.duration = 0.5;
        animation.repeatCount = 1;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [focusLayer addAnimation:animation forKey:@"transform"];
        
        //延迟0.5s消失
        [self performSelector:@selector(focusLayerNormal) withObject:self afterDelay:0.5f];
        
    }
}
- (void)focusLayerNormal
{
    _filterVideoView.userInteractionEnabled = YES;
    _focusLayer.hidden = YES;
}
@end
