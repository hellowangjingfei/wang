//
//  FirstViewController.m
//  MoviePlayerDemo
//
//  Created by wangjingfei on 2016/12/26.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import "FirstViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor blackColor];
    btn.frame = CGRectMake((KScreenWidth - 100) / 2, 100, 100, 50);
    [btn setTitle:@"播放" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(buttonPlayClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)buttonPlayClick:(UIButton *)btn
{
   SystemSoundID soundID = [self loadSound:@"videoRing.caf"];
  
    if (soundID) {
        // 播放音效
        // AudioServicesPlayAlertSound在播放音效的同时会震动
//        AudioServicesPlaySystemSound(soundID);
        AudioServicesPlayAlertSound(soundID);
    }
   
}
//加载音效
- (SystemSoundID)loadSound:(NSString *)soundFileName
{
    //指定声音的文件
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:soundFileName ofType:nil];
    
    //初始化音效
    SystemSoundID soundID;
    //URL  => CFURLRef
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)([NSURL fileURLWithPath:pathStr]), &soundID);
    return soundID;
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
