//
//  ViewController.h
//  RecordAndPlayVoiceDemo
//
//  Created by wangjingfei on 2016/12/22.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIButton *recordBtn;//录制语音按钮

@property (nonatomic,strong) AVAudioRecorder *audioRecorder;

@end

