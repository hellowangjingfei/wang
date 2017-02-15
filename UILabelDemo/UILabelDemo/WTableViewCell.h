//
//  WTableViewCell.h
//  UILabelDemo
//
//  Created by wangjingfei on 2017/1/3.
//  Copyright © 2017年 wangXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentModel.h"

typedef void(^LabelHeightBlock)(BOOL isOpen);

@interface WTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (nonatomic,strong) ContentModel *contentModel;

@property (nonatomic,copy) LabelHeightBlock labelBlock;

@property (nonatomic,assign) BOOL isOpen;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UIButton *hideBtn;

@end
