//
//  TwoViewController.m
//  GPUImageExampleDemo
//
//  Created by wangXiao on 16/11/15.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import "TwoViewController.h"
#import "GPUImage.h"
#import "WaterMarkImageView.h"
#import "VideoCameraView.h"
#import "LocationMovieView.h"

#define kScreemWidth  [UIScreen mainScreen].bounds.size.width
#define kScreemHeight  [UIScreen mainScreen].bounds.size.height
@interface TwoViewController ()<WaterMarkImageViewDelegate>
{
    UIImage *inputImg;
    UIImageView *imag;
    NSMutableArray *imgArr;
    VideoCameraView *vedioView;
    LocationMovieView *locationMovieView;
}

@property (nonatomic,strong) UIImageView *iconImgView;

@property (nonatomic,strong) GPUImagePicture *picture;

@property (nonatomic,strong) GPUImageView *gpuImgView;

@property (nonatomic,strong) GPUImageFilterGroup *filterGroup;

//当前选中的ImgView
@property (nonatomic,strong) WaterMarkImageView *cunrrentImgView;

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.indexPage == 0) {
        imgArr = [NSMutableArray new];
        [self createImageView];
        [self createButton];
    }else if (self.indexPage == 1){
        [self createVedioView];
    }else if (self.indexPage == 2){
        [self localVideoProcessing];
    }else if (self.indexPage == 3){
        
    }

}
- (void)localVideoProcessing
{
    locationMovieView = [[LocationMovieView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:locationMovieView];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [vedioView.vedioTimer invalidate];
    vedioView.vedioTimer = nil;
    [vedioView.movieWriter cancelRecording];
    vedioView = nil;
    [locationMovieView.imgMovie cancelProcessing];
    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
}
- (void)createVedioView
{
    vedioView = [[VideoCameraView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:vedioView];
}
- (void)createImageView
{
    
    
    UIImage *image = [UIImage imageNamed:@"u=1409752615,1144487711&fm=21&gp=0.jpg"];
    
    CGFloat width = image.size.width;
    
    CGFloat height = image.size.height;
    
    //加图片水印
    
    UIImage *image01 = [self addToImage:image image:image withRect:CGRectMake(0, 20, 30, 30)];
    
    imag = [[UIImageView alloc] initWithImage:image01];
    imag.frame = CGRectMake(10, 100, width,height);
    
    [self.view addSubview:imag];
    
    //压缩图片大小并保存
    
    [self zipImageData:image];
}
- (void)createButton
{
    NSArray *nameArr = @[@"剪切",@"压缩",@"保存"];
    for (int i = 0; i < nameArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 1000 + i;
        btn.backgroundColor = [UIColor blackColor];
        [btn setTitle:[nameArr objectAtIndex:i] forState:UIControlStateNormal];
        CGFloat btnWidth = (kScreemWidth - 40 )/ 3;
        btn.frame = CGRectMake(10 + (btnWidth + 10) * i, kScreemHeight - 70, btnWidth, 50);
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)buttonClick:(UIButton *)btn
{
    if (btn.tag == 1000) {
        //剪切图片
        UIImage *image = [UIImage imageNamed:@"u=1409752615,1144487711&fm=21&gp=0.jpg"];
        UIImage *image1 =[self cutImage:image withRect:CGRectMake(10, 20, 60, 100)];//
        
        int w = image1.size.width;
        
        int h = image1.size.height;
        
        UIImage *image11 = [self addText:image1 text:@"剪切" withRect:CGRectMake(10,(h-30)/2, w, 30) ];
        
        WaterMarkImageView *imag1 = [[WaterMarkImageView alloc] initWithFrame:CGRectMake(10, 210, image1.size.width,image1.size.height) withImage:image11];
        imag1.delegate = self;
        imag1.targetRect = CGRectMake(10, 100, image.size.width,image.size.height);
        [self.view addSubview:imag1];
        if (_cunrrentImgView) {
            [_cunrrentImgView removeDeleteBtnAndBorder];
        }
        _cunrrentImgView = imag1;
        [imgArr addObject:_cunrrentImgView];

    }else if (btn.tag == 1001){
        //缩小图片
         UIImage *image = [UIImage imageNamed:@"u=1409752615,1144487711&fm=21&gp=0.jpg"];
        UIImage *image2 = [self scaleToSize:image size:CGSizeMake(60, 100)];
        
        UIImage *image22 = [self addText:image2 text:@"压缩" withRect:CGRectMake(10,(100-30)/2, 60, 30) ];
        
        WaterMarkImageView *imag2 = [[WaterMarkImageView alloc] initWithFrame:CGRectMake(10, 230, image2.size.width,image2.size.height) withImage:image22];
        imag2.delegate = self;
        imag2.targetRect = CGRectMake(10, 100, image.size.width,image.size.height);
//        imag2.frame = CGRectMake(10, 300, image2.size.width,image2.size.height);
        
        [self.view addSubview:imag2];
        if (_cunrrentImgView) {
            [_cunrrentImgView removeDeleteBtnAndBorder];
        }
        _cunrrentImgView = imag2;
         [imgArr addObject:_cunrrentImgView];
        
    }else if (btn.tag == 1002){
        //保存
        if (_cunrrentImgView) {
            [_cunrrentImgView removeDeleteBtnAndBorder];
        }
        for (WaterMarkImageView *imgView in imgArr) {
            if (imgView) {
                CGRect rect = [imgView convertRect:imgView.bounds toView:imag];
//                imgView.transform
                UIImage *image01 = [self addToImage:imag.image image:imgView.image withRect:rect];
        
                imag.image = image01;
                [imgView removeFromSuperview];
            }
        }

        UIImageWriteToSavedPhotosAlbum(imag.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = nil ;

    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
}
//压缩图片
- (void)removeCurrentImageView:(WaterMarkImageView *)markImgView
{
    for (WaterMarkImageView *viewImg in imgArr) {
        if (viewImg == markImgView) {
            [imgArr removeObject:viewImg];
        }
    }
}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{

    // 设置成为当前正在使用的context
    
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    
    return scaledImage;
    
}


//截图图片

- (UIImage *)cutImage:(UIImage *)image withRect:(CGRect )rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    
    UIImage * img = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return img;
}

//压缩图片大小

- (void)zipImageData:(UIImage *)image
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyyMMddHHSSS"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@.jpg",currentDateStr];
    
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:dateStr];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        NSError *error;
        
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        
    }
    NSData *imgData = UIImageJPEGRepresentation(image, 1);
    
    if([imgData writeToFile:path atomically:YES])
    {
        
        NSLog(@"saveSuccess");
        
    }
}

//加文字水印

- (UIImage *)addText:(UIImage *)img text:(NSString *)mark withRect:(CGRect)rect
{
    int w = img.size.width;
    
    int h = img.size.height;
    
    
    UIGraphicsBeginImageContext(img.size);
    
    [[UIColor redColor] set];
    
    [img drawInRect:CGRectMake(0, 0, w, h)];
  
    if([[[UIDevice currentDevice]systemName]floatValue] >= 7.0){
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:20.0f], NSFontAttributeName,[UIColor blueColor] ,NSForegroundColorAttributeName,nil];
        [mark drawInRect:rect withAttributes:dic];
        
    }else{
        //该方法在7.0及其以后都废弃了
        [mark drawInRect:rect withFont:[UIFont systemFontOfSize:20]];
    }
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
}
//加图片水印
- (UIImage *)addToImage:(UIImage *)img image:(UIImage *)newImage withRect:(CGRect)rect
{
    int w = img.size.width;
    int h = img.size.height;
    
    UIGraphicsBeginImageContext(img.size);
    [img drawInRect:CGRectMake(0, 0, w, h)];
    [newImage drawInRect:rect];
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return aimg;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if ([touch.view isKindOfClass:[UIView class]]) {
        if (_cunrrentImgView) {
            [_cunrrentImgView removeDeleteBtnAndBorder];
        }
    }
    if ([touch.view isKindOfClass:[UIImageView class]]){
        if (_cunrrentImgView) {

            [_cunrrentImgView removeDeleteBtnAndBorder];
        }
        _cunrrentImgView = (WaterMarkImageView *)view;
       
        [self.view insertSubview:view aboveSubview:_cunrrentImgView];
         [_cunrrentImgView displayDeleteBtnAndBorder:_cunrrentImgView];
    }

}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@",touches);
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
}
- (void)_initCreateView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.frame = CGRectMake((kScreemWidth - 200) / 2, 70, 200, 200);
    _iconImgView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_iconImgView];
    
    //图片输入源
    inputImg = [UIImage imageNamed:@"u=1409752615,1144487711&fm=21&gp=0.jpg"];
    //初始化 picture
    _picture = [[GPUImagePicture alloc] initWithImage:inputImg smoothlyScaleOutput:YES];
    
    //初始化gpuImgView
    _gpuImgView = [[GPUImageView alloc] initWithFrame:self.iconImgView.bounds];
    [self.iconImgView addSubview:_gpuImgView];
    
    //初始化 filterGroup
    _filterGroup = [[GPUImageFilterGroup alloc] init];
    [_picture addTarget:_filterGroup];
    
    //添加filter
    /*
     原理：
     1.filterGroup(addFilter)滤镜组添加每个滤镜
     2.按添加顺序（可自行调整）前一个filter（addFilter）添加后一个filter
     3.filterGroup.initialFilters = @[第一个filter];
     4.filterGroup.terminalFilter = 最后一个filter；
     */
    
    //褐色（怀旧）----------- GPUImageSepiaFilter
    GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
    //RGB -------------- GPUImageRGBFilter
    GPUImageRGBFilter *rgbFilter = [[GPUImageRGBFilter alloc] init];
    //    rgbFilter.red = 0.3;
    //    rgbFilter.green = 0.4;
    //    rgbFilter.blue = 0.1;
    //色彩替换（替换亮部和暗部色彩） ----------- GPUImageFalseColorFilter
    GPUImageFalseColorFilter *falseColorFilter = [[GPUImageFalseColorFilter alloc] init];
    
    [self addGPUImageFilter:sepiaFilter];
    [self addGPUImageFilter:rgbFilter];
    [self addGPUImageFilter:falseColorFilter];
    
    //处理图片
    [_picture processImage];
    [_filterGroup useNextFrameForImageCapture];
    self.iconImgView.image = [_filterGroup imageFromCurrentFramebuffer];
}
- (void)addGPUImageFilter:(GPUImageOutput<GPUImageInput> *)filter
{
    [_filterGroup addFilter:filter];
    GPUImageOutput<GPUImageInput> *newTerminalFilter = filter;
    NSInteger count = _filterGroup.filterCount;
    if (count == 1) {
        _filterGroup.initialFilters = @[newTerminalFilter];
        _filterGroup.terminalFilter = newTerminalFilter;
    }else{
        GPUImageOutput<GPUImageInput> *terminalFilter = _filterGroup.terminalFilter;
        NSArray *initialFilters = _filterGroup.initialFilters;
        [terminalFilter addTarget:newTerminalFilter];
        _filterGroup.initialFilters = @[initialFilters[0]];
        _filterGroup.terminalFilter = newTerminalFilter;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
