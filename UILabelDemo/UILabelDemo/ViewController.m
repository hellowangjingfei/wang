//
//  ViewController.m
//  UILabelDemo
//
//  Created by wangjingfei on 2016/12/30.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import "ViewController.h"
#import "WTableViewCell.h"
#import "ContentModel.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL isOpen;

@property (nonatomic,strong) UILabel *label;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor redColor];
//    _label = [[UILabel alloc] init];
//    _label.numberOfLines = 0;
//    [self.view addSubview:_label];
//   
//    NSString *title = @"很多的时候如果只是😝😋😝要显示一😝😋😝些简单的短文本，比如确定、取消什么的，一个UILabel就足够了。但是某些情况下，文本较长。包含这些文本的View的高度取决于文本的高度。比如我们常见的微博。虽然文本所占的🙄🙃😝高度内容限制在了140字，但是用户发的😝😋😝微博是140字内的多少字，我们不清楚。那么在用到UITableView的时候，每条微博所在的😋🙄🙃Cell的高度都要根据其中包含的文字及其他内容所需要的实际高度来进行设定。当然，此文只讨论文本的高度计算问题，而且难度也只集中在文本的动态高度上。🙄😝🙃";
//    _label.text = title;
//    
//    CGRect rect = [_label textRectForBounds:self.view.bounds limitedToNumberOfLines:4];
//    _label.frame = CGRectMake(0, 70, rect.size.width, rect.size.height);
//    _label.backgroundColor = [UIColor greenColor];
//   
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(20, kScreenHeight - 50, kScreenWidth - 40, 40);
//    btn.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:btn];
//    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    UITextView *textView = [[UITextView alloc] init];
//    textView.text = title;
    
    [self createTableView];
    _dataArray = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        NSString *title;
        if (i % 10 == 0) {
            title = @"😝🌹😋🌹😝🌹😝🌹😋🌹😝🌹🙄🌹🙃🌹😝🌹😝🌹😋🌹😝🌹😋🌹🙄🌹🙃🌹🙄😝🙃😝😋😝😝🌹😋😝🙄🙃😝😝😋😝😋🙄🙃🙄😝🙃😝😋😝😝😋😝🙄🙃😝😝😋😝😋🙄🙃🙄😝🙃😝😋😝😝😋😝🙄🌹🙃😝😝😋😝😋🙄🙃🙄😝🙃😝😋😝😝😋😝🙄🙃😝😝😋😝😋🙄🙃🙄😝🙃😝😋😝😝😋😝🙄🙃😝😝😋🌹😝😋🙄🙃🙄😝🙃😝😋😝😝😋😝🙄🙃😝😝😋😝😋🙄🙃🙄😝🙃😝😋😝😝😋😝🙄🙃😝😝😋😝😋🌹🙄🙃🙄🌹😝🙃😝😋😝😝😋😝🙄🙃😝😝😋😝😋🙄🙃🙄😝🙃🌹";
        }else{
             title = @"很多的时候如果只是😝😋😝要显示一😝😋😝些简单的短文本，比如确定、取消什么的，一个UILabel就足够了。但是某些情况下，文本较长。包含这些文本的View的高度取决于文本的高度。比如我们常见的微博。虽然文本所占的🙄🙃😝高度内容限制在了140字，但是用户发的😝😋😝微博是140字内的多少字，我们不清楚。那么在用到UITableView的时候，每条微博所在的😋🙄🙃Cell的高度都要根据其中包含的文字及其他内容所需要的实际高度来进行设定。当然，此文只讨论文本的高度计算问题，而且难度也只集中在文本的动态高度上。🙄😝🙃";
        }
        
        ContentModel *model = [[ContentModel alloc] init];
        model.content = title;
        [_dataArray addObject:model];
    }
    [_tableView reloadData];
    
}
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.estimatedRowHeight = 50.0f;
//    _tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_tableView];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"UITableViewCell";
    WTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"WTableViewCell" owner:nil options:nil]lastObject];

    }
    ContentModel *model = [_dataArray objectAtIndex:indexPath.row];
    cell.contentModel = model;
    cell.labelBlock = ^(BOOL isOpen){
        model.isOpen = isOpen;
        [_tableView reloadData];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContentModel *model = [_dataArray objectAtIndex:indexPath.row];
//    if (model.isOpen == YES) {
//          return [model contentHeight:model.content withContentWidth:(kScreenWidth - 24 - 50) withIsOpen:model.isOpen] + 24;
//    }
    return [model contentHeight:model.content withContentWidth:(kScreenWidth - 24 - 50) withIsOpen:model.isOpen] + 24 + 30;
}
//- (void)buttonClick:(UIButton *)btn
//{
//    if (!_isOpen) {
//        CGRect rect = [_label textRectForBounds:self.view.bounds limitedToNumberOfLines:_label.numberOfLines];
//        _label.frame = CGRectMake(0, 70, rect.size.width, rect.size.height);
//    }else{
//        CGRect rect = [_label textRectForBounds:self.view.bounds limitedToNumberOfLines:4];
//        _label.frame = CGRectMake(0, 70, rect.size.width, rect.size.height);
//    }
//    _isOpen = !_isOpen;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
