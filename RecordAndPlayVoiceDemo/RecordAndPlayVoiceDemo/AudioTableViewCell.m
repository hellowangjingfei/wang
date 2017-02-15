//
//  AudioTableViewCell.m
//  RecordAndPlayVoiceDemo
//
//  Created by wangjingfei on 2016/12/23.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import "AudioTableViewCell.h"

@implementation AudioTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createTableViewCellViews];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self createTableViewCellViews];
}
//创建UI
- (void)createTableViewCellViews
{
    //头像
    _imgPicView = [[UIImageView alloc] init];
    _imgPicView.layer.cornerRadius = 5;
    _imgPicView.clipsToBounds = YES;
    _imgPicView.image = [UIImage imageNamed:@"h00032"];
    [self.contentView addSubview:_imgPicView];
    
    //语音背景图片
    _bgImgView = [[UIImageView alloc] init];
    _bgImgView.userInteractionEnabled = YES;
    [self.contentView addSubview:_bgImgView];
    
    //添加手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick:)];
    [_bgImgView addGestureRecognizer:tapGesture];
    [_bgImgView setImage:[[UIImage imageNamed:@"bg_chat_me"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 8, 20) resizingMode:UIImageResizingModeStretch]];
    [_bgImgView setHighlightedImage:[[UIImage imageNamed:@"bg_chat_me"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 8, 20) resizingMode:UIImageResizingModeStretch]];
    
    //语音播放动画
    _animationImgView = [[UIImageView alloc] init];
    
    _animationImgView.image = [UIImage imageNamed:@"icon_voice_sender_3"];
    [self.contentView addSubview:_animationImgView];
    NSArray *imgArray = @[[UIImage imageNamed:@"icon_voice_sender_1"],[UIImage imageNamed:@"icon_voice_sender_2"],[UIImage imageNamed:@"icon_voice_sender_3"]];
    _animationImgView.animationImages = imgArray;
    _animationImgView.animationDuration = 1.5f;
    _animationImgView.animationRepeatCount = 0;


    //语音的时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:14.0f];
    _timeLabel.text = @"0''";
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeLabel];
}
- (void)tapGestureClick:(UITapGestureRecognizer *)tap
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapGestureClickCell:)]) {
        [_delegate tapGestureClickCell:self];
    }
}
- (void)setDataModel:(SoundMessageModel *)dataModel
{
    _dataModel = dataModel;
    //头像
    _imgPicView.frame = CGRectMake(KScreenWidth - 13 - 40, 13, 40, 40);
    //语音背景图片
    _bgImgView.frame = CGRectMake(KScreenWidth - (50 + (int)_dataModel.voiceSeconds * 2.5) - 13 - 8 - 40, 13, 50 + _dataModel.voiceSeconds * 3, 40);

    _animationImgView.frame = CGRectMake(KScreenWidth - 25 - 13 - 8 - 40, 24, 12, 18);

    //语音时间
    NSString *str = [NSString stringWithFormat:@"%ld''",(long)_dataModel.voiceSeconds];
    
    _timeLabel.frame = CGRectMake(13, 13, KScreenWidth - 13 - _bgImgView.frame.size.width - 8 - 40 - 13, 40);
     _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.text = str;

}
//状态
- (void)setVoicePlayState:(VoicePlayerState)voicePlayState
{
    if (_voicePlayState != voicePlayState) {
        _voicePlayState = voicePlayState;
    }
    self.timeLabel.hidden = NO;
    self.animationImgView.hidden = NO;

    if (_voicePlayState == VoicePlayerStatePlaying) {
        [self.animationImgView startAnimating];
    }else if (_voicePlayState == VoicePlayerStateDownLoading){
        self.timeLabel.hidden = YES;
        self.animationImgView.hidden = YES;
    }else{
        [self.animationImgView stopAnimating];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
