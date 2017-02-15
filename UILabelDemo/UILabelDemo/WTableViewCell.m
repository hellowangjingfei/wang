//
//  WTableViewCell.m
//  UILabelDemo
//
//  Created by wangjingfei on 2017/1/3.
//  Copyright © 2017年 wangXiao. All rights reserved.
//

#import "WTableViewCell.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation WTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _contentLabel.backgroundColor = [UIColor redColor];
    _contentLabel.numberOfLines = 0;
    _imgView.backgroundColor = [UIColor blueColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setContentModel:(ContentModel *)contentModel
{
    if (_contentModel != contentModel) {
        _contentModel = contentModel;
    }
  
    if (_contentModel.isOpen == NO) {
        _contentLabel.numberOfLines = 3;
    }
//    else{
//        _hideBtn.hidden = YES;
//    }
    _contentHeight.constant = [contentModel contentHeight:contentModel.content withContentWidth:(kScreenWidth - 24 - 50) withIsOpen:contentModel.isOpen];
     _contentLabel.text = contentModel.content;
    [self setNeedsLayout];
}
- (IBAction)buttonClick:(UIButton *)sender {

    if (_labelBlock) {
        _contentModel.isOpen = !_contentModel.isOpen;
        _labelBlock(_contentModel.isOpen);
    }

}

@end
