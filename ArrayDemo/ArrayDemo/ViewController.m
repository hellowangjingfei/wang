//
//  ViewController.m
//  ArrayDemo
//
//  Created by wangjingfei on 2016/12/28.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import "ViewController.h"
#import <Security/Security.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor redColor];
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:nil];
    [array addObject:@"1"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
