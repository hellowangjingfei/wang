//
//  SoundRecorder.m
//  RecordAndPlayVoiceDemo
//
//  Created by wangjingfei on 2016/12/22.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import "SoundRecorder.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"

#pragma clang diagnostic ignored "-Wdeprecated"

#define GetImage(imageName)  [UIImage imageNamed:imageName]
@interface SoundRecorder ()<AVAudioRecorderDelegate>

//录制语音时的图片动画
@property (nonatomic,strong) UIImageView *imgViewAnimation;

//录制语音的存储路径
@property (nonatomic,copy) NSString *recoderPath;

//定时器
@property (nonatomic,strong) NSTimer *recoderTimer;

//录制
@property (nonatomic,strong) AVAudioRecorder *audioRecorder;

//录制时的图像
@property (nonatomic,strong) MBProgressHUD *recoderHUD;

//话筒图像
@property (nonatomic,strong) UIImageView *voiceImgView;

//录音时间多短
@property (nonatomic,strong) UIImageView *shortImgView;
//取消录制语音的图像
@property (nonatomic,strong) UIImageView *cancelImgView;

//记录录音还可以录制多久
@property (nonatomic,strong) UILabel *countDownLabel;

//录制语音时的提示语
@property (nonatomic,strong) UILabel *recorderLabel;

@end

@implementation SoundRecorder
static SoundRecorder *soundRecorder = nil;
+ (SoundRecorder *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        soundRecorder = [[SoundRecorder alloc] init];
    });
    return soundRecorder;
}
//开始录音调用的方法
- (void)startSoundRecorder:(UIView *)bgView withRecorderPath:(NSString *)path
{
    self.recoderPath = path;
    
    //放置图标
    [self createHUDViewWithView:bgView];
    //调用开始录制声音的方法
    [self startRecoder];
}
- (void)createHUDViewWithView:(UIView *)putView
{
    if (_recoderHUD) {
        [_recoderHUD removeFromSuperview];
        _recoderHUD = nil;
    }
    if (putView == nil) {
        putView = [[[UIApplication sharedApplication] windows] lastObject];
    }
    if (_recoderHUD == nil) {
        _recoderHUD = [[MBProgressHUD alloc] initWithView:putView];
        //透明度
        _recoderHUD.opacity = 0.4;
        CGFloat left = 22;
        CGFloat top = 0;
        top = 18;
        UIView *cView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 120)];
        
        //话筒图像
        _voiceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(left, top, 37, 70)];
        _voiceImgView.image = GetImage(@"toast_microphone");
        [cView addSubview:_voiceImgView];
        
        left += CGRectGetWidth(_voiceImgView.frame) + 16;
        top += 7;
        
        //语音强度的
        _imgViewAnimation = [[UIImageView alloc] initWithFrame:CGRectMake(left, top, 29, 64)];
        [cView addSubview:_imgViewAnimation];
        
        //取消录制语音
        _cancelImgView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 24, 52, 61)];
        _cancelImgView.image =  GetImage(@"toast_cancelsend");;
        [cView addSubview:_cancelImgView];
        _cancelImgView.hidden = YES;
        
        //录音时间多短
        _shortImgView = [[UIImageView alloc] initWithFrame:CGRectMake(56, 24, 18, 60)];
        _shortImgView.image = GetImage(@"toast_timeshort");
        [cView addSubview:_shortImgView];
        _shortImgView.hidden = YES;
        
        //记录录音还可以录制多久
        _countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 14, 70, 71)];
        _countDownLabel.backgroundColor = [UIColor clearColor];
        _countDownLabel.textColor = [UIColor whiteColor];
        _countDownLabel.textAlignment = NSTextAlignmentCenter;
        _countDownLabel.font = [UIFont systemFontOfSize:60.0f];
        [cView addSubview:_countDownLabel];
        _countDownLabel.hidden = YES;
        
        left = 0;
        top += CGRectGetHeight(_imgViewAnimation.frame) + 20;
        //录制语音时的提示语
        _recorderLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, top, 130, 14)];
        _recorderLabel.backgroundColor = [UIColor clearColor];
        _recorderLabel.textColor = [UIColor whiteColor];
        _recorderLabel.textAlignment = NSTextAlignmentCenter;
        _recorderLabel.font = [UIFont systemFontOfSize:14.0];
        _recorderLabel.text = @"手指上滑，取消发送";
        [cView addSubview:_recorderLabel];
        
        _recoderHUD.customView = cView;
        _recoderHUD.mode = MBProgressHUDModeCustomView;
        
        if ([putView isKindOfClass:[UIWindow class]]) {
            [putView addSubview:_recoderHUD];
        }else{
            [putView.window addSubview:_recoderHUD];
        }
        
        [_recoderHUD show:YES];
    }
}
//开始录制
- (void)startRecoder
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error;
    
    //设置AVAudioSession
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error) {
        return;
    }
    
    //设置录音输入源
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
    error = nil;
    //设置会话活动或活动。注意,激活一个音频会话是一个同步(阻塞)操作。
    [audioSession setActive:YES error:&error];
    if (error) {
        return;
    }
    
    //设置文件保存的路径和名称
    NSString *fileName = [NSString stringWithFormat:@"/soundvoice-%5.2f.caf",[[NSDate date] timeIntervalSince1970]];
    self.recoderPath = [self.recoderPath stringByAppendingPathComponent:fileName];
    
    NSURL *recoderUrl = [NSURL fileURLWithPath:self.recoderPath];
    
    NSDictionary *dic = [self recordingSettings];
    
    //初始化AVAudioRecorder
    error = nil;
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:recoderUrl settings:dic error:&error];
    if (_audioRecorder == nil) {
        return;
    }
    
    //设置代理
    _audioRecorder.delegate = self;
    //准备开始录音
    [_audioRecorder prepareToRecord];
    //开启仪表计数功能
    _audioRecorder.meteringEnabled = YES;
    
    //开始录制
    [_audioRecorder record];
    //录制每个音频之间的时间间隔
    [_audioRecorder recordForDuration:0];
    
    if (self.recoderTimer) {
        [self.recoderTimer invalidate];
        self.recoderTimer = nil;
    }
    self.recoderTimer = [NSTimer scheduledTimerWithTimeInterval:0.0001 target:self selector:@selector(levelTimerCallBack:) userInfo:nil repeats:YES];
    
}
- (void)levelTimerCallBack:(NSTimer *)timer
{
    if (_audioRecorder && _imgViewAnimation) {
        //刷新
        [_audioRecorder updateMeters];
        double ff = [_audioRecorder averagePowerForChannel:0];
        ff = ff + 60;
        if (ff>0&&ff<=10) {
            [_imgViewAnimation setImage:GetImage(@"toast_vol_0")];
        } else if (ff>10 && ff<20) {
            [_imgViewAnimation setImage:GetImage(@"toast_vol_1")];
        } else if (ff >=20 &&ff<30) {
            [_imgViewAnimation setImage:GetImage(@"toast_vol_2")];
        } else if (ff >=30 &&ff<40) {
            [_imgViewAnimation setImage:GetImage(@"toast_vol_3")];
        } else if (ff >=40 &&ff<50) {
            [_imgViewAnimation setImage:GetImage(@"toast_vol_4")];
        } else if (ff >= 50 && ff < 60) {
            [_imgViewAnimation setImage:GetImage(@"toast_vol_5")];
        } else if (ff >= 60 && ff < 70) {
            [_imgViewAnimation setImage:GetImage(@"toast_vol_6")];
        } else {
            [_imgViewAnimation setImage:GetImage(@"toast_vol_7")];
        }
    }
}
//设置录制声音的属性
- (NSDictionary *)recordingSettings
{
    NSMutableDictionary *recorderDic = [NSMutableDictionary dictionary];
    
    [recorderDic setObject:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //采样率
    [recorderDic setObject:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
    //通道数目
    [recorderDic setObject:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //采样位数 默认 16
    [recorderDic setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    return recorderDic;
}
- (NSString *)soundFilePath {
    return self.recoderPath;
}

//停止录制-------录音结束
- (void)stopSoundRecorder:(UIView *)bgView
{
    if (self.recoderTimer) {
        [self.recoderTimer invalidate];
        self.recoderTimer = nil;
    }
    //录制的时间
    NSString *str = [NSString stringWithFormat:@"%f",_audioRecorder.currentTime];
    int finalTime = [str intValue];
    
    //停止录制
    if (_audioRecorder) {
        [_audioRecorder stop];
    }
    if (finalTime >= 1) {
        if (bgView == nil) {
            bgView = [[[UIApplication sharedApplication] windows] lastObject];
        }
        if ([bgView isKindOfClass:[UIWindow class]]) {
            [bgView addSubview:_recoderHUD];
        }else{
            [bgView.window addSubview:_recoderHUD];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(didStopSoundRecord)]) {
            [_delegate didStopSoundRecorder];
        }
    }else{
        //删除录音文件
        [self deleteRecoderVoice];
        [self.audioRecorder stop];
        
        if (_delegate && [_delegate respondsToSelector:@selector(showSoundRecorderFailed)]) {
            [_delegate showSoundRecorderFailed];
        }
    }
    //删除录音图标
    [self removeRecorderHUD];
}
- (void)deleteRecoderVoice
{
    if (self.audioRecorder) {
        //停止录音
        [self.audioRecorder stop];
        //删除录音文件
        [self.audioRecorder deleteRecording];
    }
    if (self.recoderHUD) {
        [self.recoderHUD hide:NO];
    }
}
- (void)didStopSoundRecord
{
}
//删除录音图标
- (void)removeRecorderHUD
{
    if (_recoderHUD) {
        [_recoderHUD removeFromSuperview];
        _recoderHUD = nil;
    }
}
//更新录音状态，手指向上滑，提示松开取消语音
- (void)soundRecorderFailed:(UIView *)bgView
{
    //停止录音
    [self.audioRecorder stop];
    //删除图标
    [self removeRecorderHUD];
}

//更新录音状态，手指重新滑动到范围内，提示向上取消语音
- (void)readyCancelSound
{
    _imgViewAnimation.hidden = YES;
    _voiceImgView.hidden = YES;
    _cancelImgView.hidden = NO;
    _shortImgView.hidden = YES;
    _countDownLabel.hidden = YES;
    
    _recorderLabel.frame = CGRectMake(0, CGRectGetMaxY(_imgViewAnimation.frame) + 20, 130, 25);
    _recorderLabel.text = @"手指松开，取消发送";
    _recorderLabel.backgroundColor = [UIColor clearColor];
    _recorderLabel.layer.masksToBounds = YES;
    _recorderLabel.layer.cornerRadius = 3;
    
}

//更新录音状态,手指重新滑动到范围内,提示向上取消录音
- (void)resetNormalRecord
{
    _imgViewAnimation.hidden = NO;
    _voiceImgView.hidden = NO;
    _cancelImgView.hidden = YES;
    _countDownLabel.hidden = YES;
    _recorderLabel.frame = CGRectMake(0, CGRectGetMaxY(_imgViewAnimation.frame) + 20, 130, 25);
    _recorderLabel.text = @"手指松开，取消发送";
    _recorderLabel.backgroundColor = [UIColor clearColor];
}
//录音时间过短
- (void)showShotTimeign:(UIView *)bgView
{
    _imgViewAnimation.hidden = YES;
    _voiceImgView.hidden = YES;
    _cancelImgView.hidden = YES;
    _shortImgView.hidden = NO;
    _countDownLabel.hidden = YES;
    _recorderLabel.frame = CGRectMake(0, 100, 130, 25);
    _recorderLabel.text = @"说话时间太短";
    _recorderLabel.backgroundColor = [UIColor clearColor];
    
    [self performSelector:@selector(stopSoundRecorder:) withObject:bgView afterDelay:1.5f];
}

//最后10秒，显示你还可以说X秒

- (void)showCountDown:(int)countDown
{
    _recorderLabel.text = [NSString stringWithFormat:@"还可以说%d秒",countDown];
}

- (NSTimeInterval)soundRecoderTime
{
    return _audioRecorder.currentTime;
}
#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"error----------%@",error);
}
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"录制完成");
}
@end
