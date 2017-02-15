//
//  WaterMarkImageView.m
//  GPUImageExampleDemo
//
//  Created by wangXiao on 16/11/16.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import "WaterMarkImageView.h"

@implementation WaterMarkImageView
{
    UIButton *deleteBtn;
    UIView *bgView;
}
- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)img
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeCenter;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        _displayImage = img;
        _currenRect = frame;
        self.image = _displayImage;
        //添加删除按钮
        [self addDeleteButton];
        [self addGestureRecognizerToCurrenView];
    }
    return self;
}
//添加删除按钮
- (void)addDeleteButton
{
     deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (bgView) {
        deleteBtn.frame = CGRectMake(bgView.frame.size.width - 20, 0, 20, 20);
    }else{
        deleteBtn.frame = CGRectMake(self.frame.size.width - 20, 0, 20, 20);
    }
   
  
    [deleteBtn setImage:[UIImage imageNamed:@"tw_delete_nor"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBtn];
}
- (void)deleteButtonClick:(UIButton *)btn
{
    [self removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(removeCurrentImageView:)]) {
        [_delegate removeCurrentImageView:(WaterMarkImageView *)(btn.superview)];
    }
}
- (void)addGestureRecognizerToCurrenView
{
    //添加点击事件
    /*
     UITapGestureRecognizer
     
     UIPinchGestureRecognizer
     
     UIRotationGestureRecognizer
     
     UISwipeGestureRecognizer
     
     UIPanGestureRecognizer
     
     UILongPressGestureRecognizer
     */
    //单击
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick:)];
    
    [self addGestureRecognizer:tapGesture];
    
    //移动
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureClick:)];
    [self addGestureRecognizer:panGesture];
    
    //捏合
    UIPinchGestureRecognizer *pinGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinGestureClick:)];
    [self addGestureRecognizer:pinGesture];
    
    // 旋转手势
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGestureClick:)];
    [self addGestureRecognizer:rotationGesture];
}
//单击事件----------显示删除按钮和边框
- (void)tapGestureClick:(UITapGestureRecognizer *)tapGesture
{
    UIView *view = tapGesture.view;
    bgView = view;
//    if (_isHideYOrN == YES) {
//        if (!deleteBtn) {
//            [self addDeleteButton];
//        }
//       
//    }
    if (_isHideYOrN == YES) {
        id btn_view = [bgView.subviews lastObject];
        if (btn_view == nil) {
            [self addDeleteButton];
        }else{
            deleteBtn.hidden = NO;
        }
    }
}
//移动手势---------移动图片的位置
- (void)panGestureClick:(UIPanGestureRecognizer *)panGesture
{
    UIView *view = panGesture.view;
    bgView = view;
    CGFloat tarViewW = _targetRect.size.width;
    CGFloat tarViewH = _targetRect.size.height;
    CGFloat tarViewX = _targetRect.origin.x;
    CGFloat tarViewY = _targetRect.origin.y;
    NSLog(@"panGesture--------%@",panGesture);
    CGPoint translation = [panGesture translationInView:view.superview];
    [panGesture setTranslation:CGPointZero inView:view.superview];
       if (view.center.x >= tarViewX && view.center.x <= tarViewX + tarViewW && view.center.y >= tarViewY && view.center.y <= tarViewY + tarViewH) {
        if (panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged) {
            [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];

            
        }
    }
    
    
//    if (_isHideYOrN == YES) {
//        if (!deleteBtn) {
//            [self addDeleteButton];
//        }
//    }
//    CGPoint translation = [panGesture translationInView:self];
//    CGPoint newCenter = CGPointMake(view.center.x+ translation.x,
//                                    view.center.y + translation.y);//    限制屏幕范围：
//    newCenter.y = MAX(tarViewY + tarViewH, newCenter.y);
//    newCenter.y = MIN(tarViewY,  newCenter.y);
//    newCenter.x = MAX(tarViewX + tarViewW , newCenter.x);
//    newCenter.x = MIN(tarViewX ,newCenter.x);
//    view.center = newCenter;
//    [panGesture setTranslation:CGPointZero inView:view.superview];
    if (_isHideYOrN == YES) {
        id btn_view = [bgView.subviews lastObject];
        if (btn_view == nil) {
            [self addDeleteButton];
        }else{
            deleteBtn.hidden = NO;
        }
    }
}
//捏合手势---------放大/缩小
- (void)pinGestureClick:(UIPinchGestureRecognizer *)pinGesture
{
    UIView *view = pinGesture.view;
    bgView = view;
    if (pinGesture.state == UIGestureRecognizerStateBegan || pinGesture.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinGesture.scale, pinGesture.scale);
        pinGesture.scale = 1;
    }
}
//旋转手势---------旋转
- (void)rotationGestureClick:(UIRotationGestureRecognizer *)rotationGesture
{
    UIView *view = rotationGesture.view;
    bgView = view;
    if (rotationGesture.state == UIGestureRecognizerStateBegan || rotationGesture.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGesture.rotation);
        [rotationGesture setRotation:0];
    }
}
- (void)removeDeleteBtnAndBorder
{
    _isHideYOrN = YES;
//    [deleteBtn removeFromSuperview];
    deleteBtn.hidden = YES;
}
- (void)displayDeleteBtnAndBorder:(WaterMarkImageView *)imgView
{
    if (_isHideYOrN == YES) {
        id btn_view = [imgView.subviews lastObject];
        if (btn_view == nil) {
            [self addDeleteButton];
        }else{
             deleteBtn.hidden = NO;
        }
    }
}
@end
