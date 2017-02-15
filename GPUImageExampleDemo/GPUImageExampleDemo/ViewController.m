//
//  ViewController.m
//  GPUImageExampleDemo
//
//  Created by wangXiao on 16/11/15.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "TwoViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _nameArr = [[NSMutableArray alloc] initWithObjects:@[@"颜色混合处理一",@"图片的水印"],@[@"图像混合处理一",@"视频的滤镜"],@[@"混合处理一",@"本地视频的滤镜"],@[@"视觉混合处理一",@"视觉混合处理二"],nil];
    
     [self _initCreateTableView];
    
}
- (void)_initCreateTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
#pragma mark -UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [_nameArr objectAtIndex:section];
    return arr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _nameArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSArray *arr = [_nameArr objectAtIndex:indexPath.section];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[arr objectAtIndex:indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     NSArray *arr = [_nameArr objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        FirstViewController *firstViewCtrl = [[FirstViewController alloc] init];
        firstViewCtrl.title = [arr objectAtIndex:indexPath.row];
        firstViewCtrl.index = (int)indexPath.section;
        [self.navigationController pushViewController:firstViewCtrl animated:YES];
    }else if (indexPath.row == 1){
        TwoViewController *twoViewCtrl = [[TwoViewController alloc] init];
        twoViewCtrl.title = [arr objectAtIndex:indexPath.row];
        twoViewCtrl.indexPage = (int)indexPath.section;
        [self.navigationController pushViewController:twoViewCtrl animated:YES];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
