//
//  ViewController.m
//  NavDemo
//
//  Created by wangjingfei on 2017/1/3.
//  Copyright © 2017年 wangXiao. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "JZNavigationExtension.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setJz_navigationBarSize:CGSizeMake(0, 44)];
    self.jz_navigationBarTintColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createRightItem];
//    self.navigationController.navigationBar.translucent = NO;
    self.title = @"First";
}
- (void)createRightItem
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"PUSH" style:UIBarButtonItemStyleDone target:self action:@selector(buttonClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)buttonClick:(UIBarButtonItem *)btnItem
{
    FirstViewController *firstViewCtrl = [[FirstViewController alloc] init];
//    [firstViewCtrl.navigationController setJz_navigationBarSize:CGSizeMake(0, 64)];
    firstViewCtrl.title = @"title";
    firstViewCtrl.jz_navigationBarTintColor = [UIColor redColor];
    [self.navigationController pushViewController:firstViewCtrl animated:YES];
}
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
