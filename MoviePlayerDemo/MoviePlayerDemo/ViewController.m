//
//  ViewController.m
//  MoviePlayerDemo
//
//  Created by wangjingfei on 2016/12/26.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "TwoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *array = @[@"本地声音播放",@"使用AVFoundation录制视频"];
    for (int i = 0; i < array.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnWidth = (KScreenWidth - (array.count  + 1) * 10) / array.count;
        btn.frame = CGRectMake(10 + (btnWidth + 10) * i,100, btnWidth, 40);
        btn.backgroundColor = [UIColor blackColor];
        [btn setTitle:[NSString stringWithFormat:@"%@",[array objectAtIndex:i]] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}
- (void)buttonClick:(UIButton *)btn
{
    if (btn.tag == 100) {
        FirstViewController *firstViewCtrl = [[FirstViewController alloc] init];
        [self.navigationController pushViewController:firstViewCtrl animated:YES];
    }else if (btn.tag == 101){
        TwoViewController *firstViewCtrl = [[TwoViewController alloc] init];
        [self.navigationController pushViewController:firstViewCtrl animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
