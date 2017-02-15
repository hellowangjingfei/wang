//
//  FirstViewController.m
//  GPUImageExampleDemo
//
//  Created by wangXiao on 16/11/15.
//  Copyright © 2016年 wangXiao. All rights reserved.
//

#import "FirstViewController.h"
#import "GPUImage.h"


#define kScreemWidth  [UIScreen mainScreen].bounds.size.width
#define kScreemHeight  [UIScreen mainScreen].bounds.size.height
@interface FirstViewController ()
{
    GPUImagePicture *staticPicture;
    //GPUImageCrosshairGenerator             //十字
    //GPUImageLineGenerator                  //线条
    //GPUImageSharpenFilter                   //锐化
    GPUImageOutput<GPUImageInput> *brightnessFilter; //亮度---------十字
    GPUImageOutput<GPUImageInput> *contrastFilter; //对比度------------线条
    GPUImageOutput<GPUImageInput> *saturationFilter; //饱和度-----------锐化
    NSMutableArray *arrayTemp;
    UISlider *brightnessSlider;
    UISlider *contrastSlider;
    UISlider *saturationSlider;
    GPUImageFilterPipeline *pipeline;
}

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.index == 0) {
        [self firstColor];
    }else if (self.index == 1){
        [self twoPicture];
    }else if (self.index == 2){
         [self threePicture];
    }else if (self.index == 3){
         [self fourPicture];
    }else if (self.index == 4){
       
    }
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
      [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
}
- (void)firstColor
{
    UIImage *sImage = [UIImage imageNamed:@"4569739_162222707370_2.jpg"];
    staticPicture = [[GPUImagePicture alloc] initWithImage:sImage smoothlyScaleOutput:YES];
    
    
    GPUImageView *gpuView = [[GPUImageView alloc] initWithFrame:CGRectMake((kScreemWidth - 200) / 2, 70, 200, 200)];
    [self.view addSubview:gpuView];
    //    self.view = gpuView;
    //饱和度
    saturationFilter = [[GPUImageSaturationFilter alloc] init];
    [saturationFilter forceProcessingAtSize:gpuView.sizeInPixels];
    [saturationFilter addTarget:gpuView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreemHeight -150, 60, 40)];
    label.text = @"饱和度:";
    [self.view addSubview:label];
    saturationSlider = [[UISlider alloc] initWithFrame:CGRectMake(70, kScreemHeight - 150, kScreemWidth - 80, 40)];
    [saturationSlider addTarget:self action:@selector(sliderChangeValue:) forControlEvents:UIControlEventValueChanged];
    saturationSlider.minimumValue = 0.0;
    saturationSlider.maximumValue = 2.0;
    saturationSlider.value = 1.0;
    saturationSlider.tag = 99;
    [self.view addSubview:saturationSlider];
    
    [staticPicture processImage];
    
    
    //亮度
    brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    [brightnessFilter forceProcessingAtSize:gpuView.sizeInPixels];
    [brightnessFilter addTarget:gpuView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreemHeight -100, 60, 40)];
    label1.text = @"亮度:";
    [self.view addSubview:label1];
    brightnessSlider = [[UISlider alloc] initWithFrame:CGRectMake(70, kScreemHeight - 100, kScreemWidth - 80, 40)];
    [brightnessSlider addTarget:self action:@selector(sliderChangeValue:) forControlEvents:UIControlEventValueChanged];
    brightnessSlider.minimumValue = 0.0;
    brightnessSlider.maximumValue = 1.0;
    brightnessSlider.value = 0.0;
    brightnessSlider.tag = 100;
    [self.view addSubview:brightnessSlider];
    
    [staticPicture processImage];
    
    //对比度
    contrastFilter = [[GPUImageContrastFilter alloc] init];
    [contrastFilter forceProcessingAtSize:gpuView.sizeInPixels];
    [contrastFilter addTarget:gpuView];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreemHeight - 50, 60, 40)];
    label2.text = @"对比度:";
    [self.view addSubview:label2];
    contrastSlider = [[UISlider alloc] initWithFrame:CGRectMake(70, kScreemHeight - 50, kScreemWidth - 80, 40)];
    contrastSlider.minimumValue = 0.0;
    contrastSlider.maximumValue = 1.0;
    contrastSlider.value = 1.0;
    contrastSlider.tag = 101;
    [contrastSlider addTarget:self action:@selector(sliderChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:contrastSlider];
    
    [staticPicture processImage];
    
    //组合，把所有的滤镜效果添加到数组中
    [staticPicture addTarget:saturationFilter];
    [staticPicture addTarget:brightnessFilter];
    [staticPicture addTarget:saturationFilter];
    arrayTemp = [[NSMutableArray alloc] initWithObjects:brightnessFilter,contrastFilter,saturationFilter,nil];
    pipeline = [[GPUImageFilterPipeline alloc] initWithOrderedFilters:arrayTemp input:staticPicture output:gpuView];
 
}
- (void)twoPicture
{
   // GPUImageGaussianBlurFilter              //高斯模糊
   // GPUImageCropFilter                      //剪裁
    //GPUImageWhiteBalanceFilter              //白平横
    
    UIImage *sImage = [UIImage imageNamed:@"0035035785965409_b.jpg"];
    staticPicture = [[GPUImagePicture alloc] initWithImage:sImage smoothlyScaleOutput:YES];
    
    
    //高斯模糊
    saturationFilter = [[GPUImageGaussianBlurFilter  alloc] init];
    GPUImageView *gpuImgView = [[GPUImageView alloc] initWithFrame:CGRectMake((kScreemWidth - 200) / 2, 70, 200, 200)];
    [self.view addSubview:gpuImgView];
    [saturationFilter forceProcessingAtSize:gpuImgView.sizeInPixels];
    [saturationFilter addTarget:gpuImgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreemHeight -150, 100, 40)];
    label.text = @"高斯模糊:";
    [self.view addSubview:label];
    saturationSlider = [[UISlider alloc] initWithFrame:CGRectMake(120, kScreemHeight - 150, kScreemWidth - 130, 40)];
    [saturationSlider addTarget:self action:@selector(sliderChangeValue:) forControlEvents:UIControlEventValueChanged];
    saturationSlider.minimumValue = 0.0;
    saturationSlider.maximumValue = 24.0;
    saturationSlider.value = 2.0;
    saturationSlider.tag = 99;
    [self.view addSubview:saturationSlider];
    
    [staticPicture processImage];
    
    //剪裁
    brightnessFilter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0.0, 0.0, 1.0, 0.25)];
    [brightnessFilter forceProcessingAtSize:gpuImgView.sizeInPixels];
    [brightnessFilter addTarget:gpuImgView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreemHeight -100,100, 40)];
    label1.text = @"剪裁:";
    [self.view addSubview:label1];
    brightnessSlider = [[UISlider alloc] initWithFrame:CGRectMake(120, kScreemHeight - 100, kScreemWidth - 130, 40)];
    [brightnessSlider addTarget:self action:@selector(sliderChangeValue:) forControlEvents:UIControlEventValueChanged];
    brightnessSlider.minimumValue = 0.2;
    brightnessSlider.maximumValue = 1.0;
    brightnessSlider.value = 0.5;
    brightnessSlider.tag = 100;
    [self.view addSubview:brightnessSlider];
    
    [staticPicture processImage];
    
    
    //白平横
    contrastFilter = [[GPUImageWhiteBalanceFilter alloc] init];
    [contrastFilter forceProcessingAtSize:gpuImgView.sizeInPixels];
    [contrastFilter addTarget:gpuImgView];

    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreemHeight - 50, 100, 40)];
    label2.text = @"白平横:";
    [self.view addSubview:label2];
    contrastSlider = [[UISlider alloc] initWithFrame:CGRectMake(120, kScreemHeight - 50, kScreemWidth - 130, 40)];
    contrastSlider.minimumValue = 2500.0;
    contrastSlider.maximumValue = 7500.0;
    contrastSlider.value = 5000.0;
    contrastSlider.tag = 101;
    [contrastSlider addTarget:self action:@selector(sliderChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:contrastSlider];

    [staticPicture processImage];
    
    
    //组合，把所有的滤镜效果添加到数组中
    [staticPicture addTarget:saturationFilter];
    [staticPicture addTarget:brightnessFilter];
    [staticPicture addTarget:contrastFilter];
    arrayTemp = [[NSMutableArray alloc] initWithObjects:saturationFilter,brightnessFilter,contrastFilter,nil];
    pipeline = [[GPUImageFilterPipeline alloc] initWithOrderedFilters:arrayTemp input:staticPicture output:gpuImgView];

}
- (void)threePicture
{

        //GPUImagePolkaDotFilter                  //褐色（怀旧）
      //GPUImageCrosshatchFilter                  //交叉线阴影，形成黑白网状画面
    //GPUImagePolarPixellateFilter            //同心圆像素化
    
     UIImage *sImage = [UIImage imageNamed:@"0035035785965409_b.jpg"];
    staticPicture = [[GPUImagePicture alloc] initWithImage:sImage smoothlyScaleOutput:YES];
    
    
    //褐色（怀旧）
    saturationFilter = [[GPUImageSepiaFilter  alloc] init];
    [(GPUImageSepiaFilter *)saturationFilter setIntensity:0.0];
    GPUImageView *gpuImgView = [[GPUImageView alloc] initWithFrame:CGRectMake((kScreemWidth - 200) / 2, 70, 200, 200)];
    [self.view addSubview:gpuImgView];
    [saturationFilter forceProcessingAtSize:gpuImgView.sizeInPixels];
    [saturationFilter addTarget:gpuImgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreemHeight -150, 100, 40)];
    label.text = @"褐色（怀旧):";
    [self.view addSubview:label];
    saturationSlider = [[UISlider alloc] initWithFrame:CGRectMake(120, kScreemHeight - 150, kScreemWidth - 130, 40)];
    [saturationSlider addTarget:self action:@selector(sliderChangeValue:) forControlEvents:UIControlEventValueChanged];
    saturationSlider.minimumValue = 0.0;
    saturationSlider.maximumValue = 1.0;
    saturationSlider.value = 0.0;
    saturationSlider.tag = 99;
    [self.view addSubview:saturationSlider];
    
    [staticPicture processImage];
    
    //像素圆点花样
    brightnessFilter = [[GPUImagePolkaDotFilter alloc] init];
    [brightnessFilter forceProcessingAtSize:gpuImgView.sizeInPixels];
    [brightnessFilter addTarget:gpuImgView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreemHeight -100,100, 40)];
    label1.text = @"像素圆点花样:";
    [self.view addSubview:label1];
    brightnessSlider = [[UISlider alloc] initWithFrame:CGRectMake(120, kScreemHeight - 100, kScreemWidth - 130, 40)];
    [brightnessSlider addTarget:self action:@selector(sliderChangeValue:) forControlEvents:UIControlEventValueChanged];
    brightnessSlider.minimumValue = 0.0;
    brightnessSlider.maximumValue = 1.0;
    brightnessSlider.value = 0.15;
    brightnessSlider.tag = 100;
    [self.view addSubview:brightnessSlider];
    
    [staticPicture processImage];
    //同心圆像素化
    contrastFilter = [[GPUImagePolarPixellateFilter alloc] init];
    [contrastFilter forceProcessingAtSize:gpuImgView.sizeInPixels];
    [contrastFilter addTarget:gpuImgView];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreemHeight - 50, 100, 40)];
    label2.text = @"同心圆像素化:";
    [self.view addSubview:label2];
    contrastSlider = [[UISlider alloc] initWithFrame:CGRectMake(120, kScreemHeight - 50, kScreemWidth - 130, 40)];
    contrastSlider.minimumValue = -0.1;
    contrastSlider.maximumValue = 0.1;
    contrastSlider.value = 0.05;
    contrastSlider.tag = 101;
    [contrastSlider addTarget:self action:@selector(sliderChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:contrastSlider];
    
    [staticPicture processImage];

    
    //组合，把所有的滤镜效果添加到数组中
    [staticPicture addTarget:saturationFilter];
    [staticPicture addTarget:brightnessFilter];
    [staticPicture addTarget:contrastFilter];
    arrayTemp = [[NSMutableArray alloc] initWithObjects:saturationFilter,brightnessFilter,contrastFilter,nil];
    pipeline = [[GPUImageFilterPipeline alloc] initWithOrderedFilters:arrayTemp input:staticPicture output:gpuImgView];


}
- (void)fourPicture
{
    //GPUImageSwirlFilter                     //漩涡，中间形成卷曲的画面
   //GPUImageSmoothToonFilter               //相比上面的效果更细腻，上面是粗旷的画风 ----卡通效果（黑色粗线描边）
   // GPUImageVignetteFilter                //晕影，形成黑色圆形边缘，突出中间图像的效果
    
    UIImage *sImage = [UIImage imageNamed:@"0035035785965409_b.jpg"];
    staticPicture = [[GPUImagePicture alloc] initWithImage:sImage smoothlyScaleOutput:YES];
    
    
    //漩涡，中间形成卷曲的画面
    saturationFilter = [[GPUImageSwirlFilter  alloc] init];
//    [(GPUImageSepiaFilter *)saturationFilter setAngle:1.0];
    GPUImageView *gpuImgView = [[GPUImageView alloc] initWithFrame:CGRectMake((kScreemWidth - 200) / 2, 70, 200, 200)];
    [self.view addSubview:gpuImgView];
    [saturationFilter forceProcessingAtSize:gpuImgView.sizeInPixels];
    [saturationFilter addTarget:gpuImgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreemHeight -150, 100, 40)];
    label.text = @"漩涡:";
    [self.view addSubview:label];
    saturationSlider = [[UISlider alloc] initWithFrame:CGRectMake(120, kScreemHeight - 150, kScreemWidth - 130, 40)];
    [saturationSlider addTarget:self action:@selector(sliderChangeValue:) forControlEvents:UIControlEventValueChanged];
    saturationSlider.minimumValue = 0.0;
    saturationSlider.maximumValue = 2.0;
    saturationSlider.value = 1.0;
    saturationSlider.tag = 99;
    [self.view addSubview:saturationSlider];
    
    [staticPicture processImage];
    
    //卡通效果
    brightnessFilter = [[GPUImageSmoothToonFilter alloc] init];
    [brightnessFilter forceProcessingAtSize:gpuImgView.sizeInPixels];
    [brightnessFilter addTarget:gpuImgView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreemHeight -100,100, 40)];
    label1.text = @"卡通效果:";
    [self.view addSubview:label1];
    brightnessSlider = [[UISlider alloc] initWithFrame:CGRectMake(120, kScreemHeight - 100, kScreemWidth - 130, 40)];
    [brightnessSlider addTarget:self action:@selector(sliderChangeValue:) forControlEvents:UIControlEventValueChanged];
    brightnessSlider.minimumValue = 1.0;
    brightnessSlider.maximumValue = 6.0;
    brightnessSlider.value = 1.0;
    brightnessSlider.tag = 100;
    [self.view addSubview:brightnessSlider];
    
    [staticPicture processImage];
    //晕影
    contrastFilter = [[GPUImageVignetteFilter alloc] init];
    [contrastFilter forceProcessingAtSize:gpuImgView.sizeInPixels];
    [contrastFilter addTarget:gpuImgView];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreemHeight - 50, 100, 40)];
    label2.text = @"晕影:";
    [self.view addSubview:label2];
    contrastSlider = [[UISlider alloc] initWithFrame:CGRectMake(120, kScreemHeight - 50, kScreemWidth - 130, 40)];
    contrastSlider.minimumValue = 0.5;
    contrastSlider.maximumValue = 0.9;
    contrastSlider.value = 0.75;
    contrastSlider.tag = 101;
    [contrastSlider addTarget:self action:@selector(sliderChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:contrastSlider];
    
    [staticPicture processImage];
    
    
    //组合，把所有的滤镜效果添加到数组中
    [staticPicture addTarget:saturationFilter];
    [staticPicture addTarget:brightnessFilter];
    [staticPicture addTarget:contrastFilter];
    arrayTemp = [[NSMutableArray alloc] initWithObjects:saturationFilter,brightnessFilter,contrastFilter,nil];
    pipeline = [[GPUImageFilterPipeline alloc] initWithOrderedFilters:arrayTemp input:staticPicture output:gpuImgView];
}
- (void)sliderChangeValue:(UISlider *)slider
{
    if (slider.tag == 99) {
        if (self.index == 0) {
            GPUImageSaturationFilter *gpuSaturation = (GPUImageSaturationFilter *)saturationFilter;
            gpuSaturation.saturation = slider.value;
            [staticPicture processImage];
        }else if (self.index == 1){
            //GPUImageGaussianBlurFilter
            GPUImageGaussianBlurFilter *gpuHighPass = (GPUImageGaussianBlurFilter *)saturationFilter;
            [gpuHighPass setBlurRadiusInPixels:slider.value];
            [staticPicture processImage];
        }else if (self.index == 2){
            //GPUImageHighPassFilter
            GPUImageSepiaFilter *gpuHighPass = (GPUImageSepiaFilter *)saturationFilter;
            [gpuHighPass setIntensity:slider.value];
            [staticPicture processImage];
        }else if (self.index == 3){
            //GPUImageSwirlFilter
            GPUImageSwirlFilter *gpuHighPass = (GPUImageSwirlFilter *)saturationFilter;
            [gpuHighPass setAngle:slider.value];
            [staticPicture processImage];
        }

        
    }else if (slider.tag == 100) {
        if (self.index == 0) {
            GPUImageBrightnessFilter *gpuBrightness = (GPUImageBrightnessFilter *)brightnessFilter;
            gpuBrightness.brightness = slider.value;
            [staticPicture processImage];
        }else if (self.index == 1){
            GPUImageCropFilter *gpuBrightness = (GPUImageCropFilter *)brightnessFilter;
            [gpuBrightness setCropRegion:CGRectMake(0.0, 0.0,1.0,slider.value)];
            [staticPicture processImage];
        }else if (self.index == 2){
            GPUImagePolkaDotFilter *gpuBrightness = (GPUImagePolkaDotFilter *)brightnessFilter;
            [gpuBrightness setFractionalWidthOfAPixel:slider.value];
            [staticPicture processImage];
        }else if (self.index == 3){
            //GPUImageSmoothToonFilter
            GPUImageSmoothToonFilter *gpuBrightness = (GPUImageSmoothToonFilter *)brightnessFilter;
            [gpuBrightness setBlurRadiusInPixels:slider.value];
            [staticPicture processImage];
        }

    }else if (slider.tag == 101){
        if (self.index == 0) {
            GPUImageContrastFilter *gpuContrast= (GPUImageContrastFilter *)contrastFilter;
            gpuContrast.contrast = slider.value;
        }else if (self.index == 1){
            GPUImageWhiteBalanceFilter *gpuContrast= (GPUImageWhiteBalanceFilter *)contrastFilter;
            [gpuContrast setTemperature:slider.value];
        }else if (self.index == 2){
            GPUImagePolarPixellateFilter *gpuContrast= (GPUImagePolarPixellateFilter *)contrastFilter;
            [gpuContrast setPixelSize:CGSizeMake(slider.value, slider.value)];
        }else if (self.index == 3){
            //GPUImageVignetteFilter
            GPUImageVignetteFilter *gpuContrast= (GPUImageVignetteFilter *)contrastFilter;
            [gpuContrast setVignetteEnd:slider.value];

        }

        [staticPicture processImage];
    }
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
