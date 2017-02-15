//
//  AudioPlayer.m
//  RecordAndPlayVoiceDemo
//
//  Created by wangjingfei on 2016/12/22.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import "AudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#include "amrFileCodec.h"
#import <objc/runtime.h>


NSString *const kXMNAudioDataKey;
@interface AudioPlayer ()<AVAudioPlayerDelegate>

//播放器
@property (nonatomic,strong) AVAudioPlayer *avAudioPlayer;

//线程
@property (nonatomic,strong) NSOperationQueue *audioOperationQueue;

//语音的播放状态
@property (nonatomic,assign) AudioPlayerState audioPlayerState;

@end
@implementation AudioPlayer
static AudioPlayer *audioPlayer = nil;
+ (instancetype)sharePlayer
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioPlayer = [[AudioPlayer alloc] init];
    });
    return audioPlayer;
}
+ (void)initialize
{
    //配置播放器配置
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _audioOperationQueue = [[NSOperationQueue alloc] init];
        _indexVoice = NSUIntegerMax;
    }
    return self;
}
- (void)playAudioWithURLStr:(NSString *)urlStr withAtIndex:(NSUInteger)indexVoice
{
    if (!urlStr) {
        return;
    }
    //如果来自同一个URLStr并且indexVoice相同，则直接取消播放
    if ([self.fileURLPath isEqualToString:urlStr] && self.indexVoice == indexVoice) {
        //停止播放
        [self stopAudioPlayer];
        //改变播放状态
        [self setAudioPlayerState:AudioPlayerStateCancel];
        return;
    }
    self.fileURLPath = urlStr;
    self.indexVoice = indexVoice;
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSData *audioData = [self audioDataFromURLStr:urlStr withAtIndex:indexVoice];
        if (!audioData) {
            //改变播放状态
            [self setAudioPlayerState:AudioPlayerStateCancel];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //播放
            [self playAudioWithData:audioData];
        });
    }];
//    if (!_audioOperationQueue) {
//        _audioOperationQueue = [[NSOperationQueue alloc] init];
//    }
    //将线程放入队列中
    [_audioOperationQueue addOperation:blockOperation];
}
//停止语音的播放
- (void)stopAudioPlayer
{
    if (_avAudioPlayer) {
        _avAudioPlayer.playing ? [_avAudioPlayer stop] : nil;
        _avAudioPlayer.delegate = nil;
        _avAudioPlayer = nil;
        [[AudioPlayer sharePlayer] setAudioPlayerState:AudioPlayerStateCancel];
    }
}
//转换语音的格式
- (NSData *)audioDataFromURLStr:(NSString *)URLStr withAtIndex:(NSUInteger)indexVoice
{
    NSData *audioData;
    if ([URLStr hasSuffix:@".caf"]) {//播放本机录制文件
        audioData = [NSData dataWithContentsOfFile:URLStr];
    }else if ([URLStr hasSuffix:@".amr"]){//播放来自安卓的AMR文件
        audioData = DecodeAMRToWAVE([NSData dataWithContentsOfFile:URLStr]);
    }else{
        NSLog(@"soundFile not support!");
    }
    if (audioData) {
        objc_setAssociatedObject(audioData, &kXMNAudioDataKey, [NSString stringWithFormat:@"%@_%ld",URLStr,indexVoice], OBJC_ASSOCIATION_COPY);
    }
    return audioData;
}
//播放语音
- (void)playAudioWithData:(NSData *)audioData
{
    NSString *audioURLStr = objc_getAssociatedObject(audioData, &kXMNAudioDataKey);
    if (![[NSString stringWithFormat:@"%@_%ld",self.fileURLPath,self.indexVoice] isEqualToString:audioURLStr]) {
        return;
    }
    NSError *error;
    _avAudioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
    if (!_avAudioPlayer || !audioData) {
        [self setAudioPlayerState:AudioPlayerStateCancel];
        return;
    }
     //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
    //声音
    _avAudioPlayer.volume = 1.0f;
    _avAudioPlayer.delegate = self;
    //准备播放
    [_avAudioPlayer prepareToPlay];
    [self setAudioPlayerState:AudioPlayerStatePlaying];
    //开始播放
    [_avAudioPlayer play];
}
//监听通知
- (void)proximityStateChange:(NSNotification *)noti
{
    if ([[UIDevice currentDevice] proximityState] == YES) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }else{
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}
#pragma mark -AVAudioPlayerDelegate
//播放失败
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error
{
    NSLog(@"error-----------%@",error);
}
//播放完成
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"播放完成");
    
    [self setAudioPlayerState:AudioPlayerStateNormal];
    
    //删除近距离时间监听
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
    
    //延迟1秒将audioPlayer释放
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .2f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //停止播放
        [self stopAudioPlayer];
    });
}
//播放的URL
- (void)setFileURLPath:(NSString *)fileURLPath
{
    if (_fileURLPath) {
        //说明当前有正在播放的语音，或者正在加载的语音，取消operation(如果没有正在执行的任务)，停止播放
        [self cancelOperation];
        [self stopAudioPlayer];
        //改变播放状态
        [self setAudioPlayerState:AudioPlayerStateCancel];
    }
    _fileURLPath = [fileURLPath copy];
}
//取消播放的线程
- (void)cancelOperation
{
    for (NSOperation *operation in _audioOperationQueue.operations) {
        [operation cancel];
        break;
    }
}
//设置状态
- (void)setAudioPlayerState:(AudioPlayerState)audioPlayerState
{
    _audioPlayerState = audioPlayerState;
    if (_delegate && [_delegate respondsToSelector:@selector(audioPalyerStateDidChanged:withForIndex:)]) {
        [_delegate audioPalyerStateDidChanged:_audioPlayerState withForIndex:self.indexVoice];
    }
    if (_audioPlayerState == AudioPlayerStateCancel || _audioPlayerState == AudioPlayerStateNormal) {
        _fileURLPath = nil;
        _indexVoice = NSUIntegerMax;
    }
}
@end
