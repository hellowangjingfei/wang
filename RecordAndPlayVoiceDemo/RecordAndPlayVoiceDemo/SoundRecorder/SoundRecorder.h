//
//  SoundRecorder.h
//  RecordAndPlayVoiceDemo
//
//  Created by wangjingfei on 2016/12/22.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SoundRecorderDelegete <NSObject>

//录制声音失败
- (void)showSoundRecorderFailed;

//停止录音
- (void)didStopSoundRecorder;

@end
@interface SoundRecorder : NSObject

//声音文件的路径
@property (nonatomic,copy) NSString *soundFilePath;

@property (nonatomic,weak) id<SoundRecorderDelegete> delegate;

+ (SoundRecorder *)shareInstance;
/**
 *  开始录音
 *
 *  @param bgView 展现录音指示框的父视图
 *  @param path 音频文件保存路径
 */
- (void)startSoundRecorder:(UIView *)bgView withRecorderPath:(NSString *)path;

/**
 *  录音结束
 */
- (void)stopSoundRecorder:(UIView *)bgView;

/**
 *  更新录音状态，手指向上滑，提示松开取消语音
 */
- (void)soundRecorderFailed:(UIView *)bgView;

/**
 *  更新录音状态，手指重新滑动到范围内，提示向上取消语音
 */
- (void)readyCancelSound;

/**
 *  更新录音状态,手指重新滑动到范围内,提示向上取消录音
 */
- (void)resetNormalRecord;

/**
 *  录音时间过短
 */
- (void)showShotTimeign:(UIView *)bgView;

/**
 *  最后10秒，显示你还可以说X秒
 *  @parm countDwon X秒
 */
- (void)showCountDown:(int)countDown;

- (NSTimeInterval)soundRecoderTime;

@end
