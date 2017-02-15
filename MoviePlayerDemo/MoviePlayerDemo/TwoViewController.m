//
//  TwoViewController.m
//  MoviePlayerDemo
//
//  Created by wangjingfei on 2016/12/26.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import "TwoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface TwoViewController ()

@property (nonatomic,strong) AVCaptureSession *captureSession;//负责输入和传输设置之间的数据传输

@property (nonatomic,strong) AVCaptureDeviceInput *captureDeviceInput; //负责从AVCaptureDevice获得输入数据

@property (nonatomic,strong) AVCaptureMovieFileOutput *captureMoviceOutPut;//视频输出流

@property (nonatomic,strong) AVCaptureVideoPreviewLayer *caputureVedioPreviewLayer;//相机拍摄预览图层




@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
}
//初始化
- (void)initEquipment
{
    //初始化会话
    _captureSession = [[AVCaptureSession alloc] init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {//设置分倍率
        _captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    
    //获取输入设备
    AVCaptureDevice *capturDevice = [self specifyTheLocationOfTheCamera:AVCaptureDevicePositionBack];//取得后置摄像头
    if (!capturDevice) {
        NSLog(@"取得后置摄像头时出现问题");
        return;
    }
    
    //添加一个音频输入设备
    AVCaptureDevice *audioCaptureDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    
    NSError *error = nil;
    
}
//获取指定位置的摄像头
- (AVCaptureDevice *)specifyTheLocationOfTheCamera:(AVCaptureDevicePosition)positionDevice
{
    NSArray *cameraArray = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
    for (AVCaptureDevice *camera in cameraArray) {
        if ([camera position] == positionDevice) {
            return camera;
        }
    }
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
