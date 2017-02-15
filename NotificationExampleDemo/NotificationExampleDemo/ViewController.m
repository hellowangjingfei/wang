//
//  ViewController.m
//  NotificationExampleDemo
//
//  Created by wangXiao on 16/11/28.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 50);
    btn.backgroundColor = [UIColor blackColor];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"Post" object:nil];
}
- (void)receiveNotification:(NSNotification *)noti
{
    NSLog(@"%s",__func__);
}

- (void)buttonClick:(UIButton *)btn
{
    FirstViewController *firstViewCtrl = [[FirstViewController alloc] init];
    [self.navigationController pushViewController:firstViewCtrl animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
