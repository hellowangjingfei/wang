//
//  LocationMovieView.h
//  GPUImageExampleDemo
//
//  Created by wangXiao on 16/11/18.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface LocationMovieView : UIView<GPUImageMovieDelegate>

@property (nonatomic,strong) GPUImageMovie *imgMovie;

@property (nonatomic,strong) GPUImageFilterGroup *filterGroup;

@end
