//
//  SoundMessageModel.h
//  RecordAndPlayVoiceDemo
//
//  Created by wangjingfei on 2016/12/22.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundMessageModel : NSObject

//声音路径
@property (nonatomic,copy) NSString *voiceFilePath;

//录制声音的时间
@property (nonatomic,assign) NSTimeInterval voiceSeconds;

@end
