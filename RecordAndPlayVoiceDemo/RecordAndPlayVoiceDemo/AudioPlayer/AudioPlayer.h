//
//  AudioPlayer.h
//  RecordAndPlayVoiceDemo
//
//  Created by wangjingfei on 2016/12/22.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger ,AudioPlayerState){
    AudioPlayerStateNormal = 0,//未播放状态
    AudioPlayerStatePlaying = 2, //正在播放
    AudioPlayerStateCancel = 3, //播放被取消
};

@protocol AudioPalyerDelegate <NSObject>

- (void)audioPalyerStateDidChanged:(AudioPlayerState)audioPlayerState withForIndex:(NSUInteger)index;

@end
@interface AudioPlayer : NSObject

//播放语音的路径
@property (nonatomic,copy) NSString *fileURLPath;

//播放的位置
@property (nonatomic,assign) NSUInteger indexVoice;

@property (nonatomic,weak)id<AudioPalyerDelegate> delegate;

+ (instancetype)sharePlayer;

//将要播放的语音
- (void)playAudioWithURLStr:(NSString *)urlStr withAtIndex:(NSUInteger)indexVoice;
//停止播放语音
- (void)stopAudioPlayer;

@end
