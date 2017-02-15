//
//  FirstViewController.m
//  NavDemo
//
//  Created by wangjingfei on 2017/1/3.
//  Copyright © 2017年 wangXiao. All rights reserved.
//

#import "FirstViewController.h"
#import "JZNavigationExtension.h"

@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation FirstViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//     [self.navigationController setJz_navigationBarSize:CGSizeMake(0, 64)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = [UIColor greenColor];
    [self createTableView];
     [self createRightItem];
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
- (void)createRightItem
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"PUSH" style:UIBarButtonItemStyleDone target:self action:@selector(buttonClick:)];
    self.navigationItem.leftBarButtonItem = rightItem;
}
- (void)buttonClick:(UIBarButtonItem *)btnItem
{
//    FirstViewController *firstViewCtrl = [[FirstViewController alloc] init];
//    //    [firstViewCtrl.navigationController setJz_navigationBarSize:CGSizeMake(0, 64)];
//    firstViewCtrl.title = @"title";
//    firstViewCtrl.jz_navigationBarTintColor = [UIColor redColor];
//    [self.navigationController pushViewController:firstViewCtrl animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
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
