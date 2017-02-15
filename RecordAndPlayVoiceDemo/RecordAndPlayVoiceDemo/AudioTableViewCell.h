//
//  AudioTableViewCell.h
//  RecordAndPlayVoiceDemo
//
//  Created by wangjingfei on 2016/12/23.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundMessageModel.h"

typedef NS_ENUM(NSUInteger ,VoicePlayerState) {
    VoicePlayerStateNormal = 0, //未播放状态
    VoicePlayerStateDownLoading,//正在下载中
    VoicePlayerStatePlaying,//正在播放
    VoicePlayerStateCancel,//播放被取消
};
@class AudioTableViewCell;
@protocol SoundMessageDelegate <NSObject>

- (void)tapGestureClickCell:(AudioTableViewCell *)cell;

@end
@interface AudioTableViewCell : UITableViewCell

//代理
@property (nonatomic,weak)id<SoundMessageDelegate> delegate;

@property (nonatomic,assign) VoicePlayerState voicePlayState;

@property (nonatomic,strong) SoundMessageModel *dataModel;

//头像
@property (nonatomic,strong) UIImageView *imgPicView;

//语音时间
@property (nonatomic,strong) UILabel *timeLabel;

//语音的背景图片
@property (nonatomic,strong) UIImageView *bgImgView;

//语音的播放动画
@property (nonatomic,strong) UIImageView *animationImgView;

@end
