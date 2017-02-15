//
//  FirstViewController.m
//  NotificationExampleDemo
//
//  Created by wangXiao on 16/11/28.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import "FirstViewController.h"
#import "TwoViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    TwoViewController *twoViewCtrl = [[TwoViewController alloc] init];
    [self.navigationController pushViewController:twoViewCtrl animated:YES];
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