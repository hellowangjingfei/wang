//
//  ViewController.m
//  RecordAndPlayVoiceDemo
//
//  Created by wangjingfei on 2016/12/22.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SoundRecorder.h"
#import "SoundMessageModel.h"
#import "AudioTableViewCell.h"
#import "AudioPlayer.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,SoundRecorderDelegete,AudioPalyerDelegate,SoundMessageDelegate>

@property (nonatomic,strong) NSTimer *timerRecorder;//录制声音的定时器

@property (nonatomic,strong) NSMutableArray *dataArray; //数据

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createTableView];
    [self createRecordVoiceButton];
    _dataArray = [NSMutableArray array];
    //设置播放录音的代理
    [AudioPlayer sharePlayer].delegate = self;
}
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,KScreenWidth, KScreenHeight  - 70) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] init];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"AudioTableViewCell";
    AudioTableViewCell *audioCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (audioCell == nil) {
        audioCell = [[AudioTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        audioCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    audioCell.delegate = self;
    audioCell.dataModel = [_dataArray objectAtIndex:indexPath.row];
    return audioCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}
////播放录音
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    AudioTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    [cell setVoicePlayState:VoicePlayerStatePlaying];
//    SoundMessageModel *model = [_dataArray objectAtIndex:indexPath.row];
//    [[AudioPlayer sharePlayer] playAudioWithURLStr:model.voiceFilePath withAtIndex:indexPath.row];
//}
#pragma mark - SoundMessageDelegate
- (void)tapGestureClickCell:(AudioTableViewCell *)cell
{
//    AudioTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    [cell setVoicePlayState:VoicePlayerStatePlaying];
    SoundMessageModel *model = [_dataArray objectAtIndex:indexPath.row];
    [[AudioPlayer sharePlayer] playAudioWithURLStr:model.voiceFilePath withAtIndex:indexPath.row];
}
//创建录音按钮
- (void)createRecordVoiceButton
{
    _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _recordBtn.frame = CGRectMake(20, KScreenHeight - 70, KScreenWidth - 40, 50);
    [_recordBtn setTitle:@"按住录音" forState:UIControlStateNormal];
    [_recordBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_recordBtn setBackgroundImage:[[UIImage imageNamed:@"btn_chatbar_press_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
   
    [_recordBtn setBackgroundImage:[[UIImage imageNamed:@"btn_chatbar_press_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch] forState:UIControlStateSelected];
    [_recordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.view addSubview:_recordBtn];
    
    //添加按钮的点击事件
    //开始录音
    [_recordBtn addTarget:self action:@selector(startRecordVoice:) forControlEvents:UIControlEventTouchDown];
    
    //录音完成
    [_recordBtn addTarget:self action:@selector(confirmRecordVoice) forControlEvents:UIControlEventTouchUpInside];
    
    //取消录音
    [_recordBtn addTarget:self action:@selector(cancelRecordVoice) forControlEvents:UIControlEventTouchUpOutside];
    
    //更新录音显示状态,手指向上滑动后 提示松开取消录音
    [_recordBtn addTarget:self action:@selector(updateCancelRecorderVoice) forControlEvents:UIControlEventTouchDragExit];
    //更新录音状态,手指重新滑动到范围内,提示向上取消录音
     [_recordBtn addTarget:self action:@selector(updateContinueRecorderVoice) forControlEvents:UIControlEventTouchDragEnter];
}

//开始录音
- (void)startRecordVoice:(UIButton *)btn
{
    __block BOOL isAllow;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted){
            if (granted) {
                isAllow = YES;
            }else{
                isAllow = NO;
            }
        }];
    }
    if (isAllow) {
        //停止播放
        [[AudioPlayer sharePlayer] stopAudioPlayer];
        
        //开始录音
        [[SoundRecorder shareInstance] startSoundRecorder:self.view withRecorderPath:[self recorderPath]];
        
        if (_timerRecorder) {
            [_timerRecorder invalidate];
            _timerRecorder = nil;
        }
        //开启定时器
        _timerRecorder = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sixtyTimeStopSendVoice) userInfo:nil repeats:YES];
    }else{
        NSLog(@"没有权限不能进行录音");
    }
}
//录音完成
- (void)confirmRecordVoice
{
    if ([[SoundRecorder shareInstance] soundRecoderTime] < 1.0f) {
        if (_timerRecorder) {
            [_timerRecorder invalidate];
            _timerRecorder = nil;
        }
        //录制声音比较短
        [self recorderVoiceShortTime];
        return;
    }
    if ([[SoundRecorder shareInstance] soundRecoderTime] < 61) {
        //存储数据
        [self storeTheData];
        //停止
        [[SoundRecorder shareInstance] stopSoundRecorder:self.view];
    }
    //销毁定时器
    if (_timerRecorder) {
        [_timerRecorder invalidate];
        _timerRecorder = nil;
    }
}
//录制声音比较短
- (void)recorderVoiceShortTime
{
    [[SoundRecorder shareInstance] showShotTimeign:self.view];
}
//取消录音
- (void)cancelRecordVoice
{
    [[SoundRecorder shareInstance] soundRecorderFailed:self.view];
}
//更新录音显示状态,手指向上滑动后 提示松开取消录音
- (void)updateCancelRecorderVoice
{
    [[SoundRecorder shareInstance] readyCancelSound];
}
//更新录音状态,手指重新滑动到范围内,提示向上取消录音
- (void)updateContinueRecorderVoice
{
    [[SoundRecorder shareInstance] resetNormalRecord];
}
//#pragma mark -AVAudioRecorderDelegate
//- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
//{
//    NSLog(@"录音结束");
//    NSFileManager *manager = [NSFileManager defaultManager];
//    
//    NSString *voicePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    //获取当前文件夹的所有的子文件subPathsAtPath
//    NSArray *pathArray = [manager subpathsAtPath:voicePath];
//    
//    //需要只获得录音文件
//    NSMutableArray *audioPathArray = [NSMutableArray array];
//    
//    //遍历所有这个文件夹下的子文件
//    for (NSString *audioPath in pathArray) {
//        //区分是否是录音文件
//        if ([audioPath.pathExtension isEqualToString:@"aiff"]) {
//            [audioPathArray addObject:audioPath];
//        }
//    }
//    NSLog(@"%@",audioPathArray);
//}
//语音存储的路径
- (NSString *)recorderPath
{
    NSString *filePath = [DocumentPath stringByAppendingPathComponent:@"SoundFile"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        NSError *error;
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
    }
    return filePath;
}
//定时器调用录制语音的方法
- (void)sixtyTimeStopSendVoice
{
    int countDown = 60 - [[SoundRecorder shareInstance] soundRecoderTime];
    NSLog(@"countDown is %d soundRecordTime is %f",countDown,[[SoundRecorder shareInstance] soundRecoderTime]);
    if (countDown <= 10) {
        [[SoundRecorder shareInstance] showCountDown:countDown - 1];
    }
    if ([[SoundRecorder shareInstance] soundRecoderTime] >= 60 && [[SoundRecorder shareInstance] soundRecoderTime] <= 61) {
        if (_timerRecorder) {
            [_timerRecorder invalidate];
            _timerRecorder = nil;
        }
        [self.recordBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}
//存储数据
- (void)storeTheData
{
    SoundMessageModel *voiceModel = [[SoundMessageModel alloc] init];
    voiceModel.voiceFilePath = [[SoundRecorder shareInstance] soundFilePath];
    voiceModel.voiceSeconds = [[SoundRecorder shareInstance] soundRecoderTime];
    [self.dataArray addObject:voiceModel];
    [_tableView reloadData];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];

}
#pragma mark - SoundRecorderDelegete
- (void)showSoundRecorderFailed
{
    //录音失败
//    [[SoundRecorder shareInstance] soundRecorderFailed:self.view];
    if (_timerRecorder) {
        [_timerRecorder invalidate];
        _timerRecorder = nil;
    }
}
- (void)didStopSoundRecorder
{
    
}
#pragma mark - AudioPalyerDelegate
- (void)audioPalyerStateDidChanged:(AudioPlayerState)audioPlayerState withForIndex:(NSUInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    AudioTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    
    VoicePlayerState voicePlayerSate;
    switch (audioPlayerState) {
        case AudioPlayerStateNormal:
            voicePlayerSate = VoicePlayerStateNormal;
            break;
        case AudioPlayerStatePlaying:
            voicePlayerSate = VoicePlayerStatePlaying;
            break;
        case AudioPlayerStateCancel:
            voicePlayerSate = VoicePlayerStateCancel;
            break;
  
        default:
            break;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell setVoicePlayState:voicePlayerSate];
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
