//
//  QBCameraViewController.m
//  Melon
//
//  Created by Zhangyue on 15/7/3.
//  Copyright (c) 2015年 TStudio.Inc. All rights reserved.
//

#import "QBCameraViewController.h"
#import <GPUImage/GPUImage.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "FeBasicAnimationBlock.h"
#import "BLHighContrastFilter.h"
#import "GPUImageHardLightBlendFilter.h"
#import "BLHardLightFilter.h"
#import "GPUImageBloomFilter.h"
#import "BLLookUpFilter.h"
#import "RGBAnimateView.h"
#import "QBFiltersContainerView.h"

@interface QBCameraViewController ()

//视图
@property (weak, nonatomic) IBOutlet GPUImageView *cameraImageView;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;
@property (weak, nonatomic) IBOutlet UIView *captureInView;
@property (weak, nonatomic) IBOutlet UIView *captureOutView;
@property (weak, nonatomic) IBOutlet UIButton *photobrowserButton;
@property (weak, nonatomic) IBOutlet RGBAnimateView *filtersButton;

//拍照相机
@property (strong, nonatomic) GPUImageStillCamera *stillCamera;

//拍照按钮
@property (strong, nonatomic) NSMutableArray *filters;
@property (strong, nonatomic) GPUImageOutput<GPUImageInput> *selectedFilter;

@end

@implementation QBCameraViewController

- (void)configData
{
    self.filters = [[NSMutableArray alloc] initWithCapacity:10];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configData];
    
    [self configureFilter];
    
    [self configUI];
    
    [self configureCamera];
    
    [self switchFilter:0];
    
    [self configGuesture];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.stillCamera startCameraCapture];
    [self showOrHideStatusBar:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.stillCamera stopCameraCapture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - ConfigUI
- (void)configUI
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    
    [[self.captureButton layer] setCornerRadius:CGRectGetHeight(self.captureButton.frame) / 2];
    [[self.captureButton layer] setMasksToBounds:YES];
    
    [[self.captureInView layer] setCornerRadius:CGRectGetHeight(self.captureInView.frame) / 2];
    [[self.captureInView layer] setMasksToBounds:YES];
    
    [[self.captureOutView layer] setCornerRadius:CGRectGetHeight(self.captureOutView.frame) / 2];
    [[self.captureOutView layer] setMasksToBounds:YES];
    
    [[self.photobrowserButton layer] setCornerRadius:CGRectGetHeight(self.photobrowserButton.frame) / 2];
    [[self.photobrowserButton layer] setMasksToBounds:YES];
    
    __weak QBCameraViewController *camera = self;
    [camera.filtersButton setCallback:^(id sender){
        [QBFiltersContainerView show:self.filters camera:camera.stillCamera callback:^(NSNumber *indexNum) {
            [camera switchFilter:[indexNum integerValue]];
        }];
    }];
    
    [self updatePhotoBrowserButton];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Actions
- (IBAction)touchDownCaptureButton:(id)sender
{
    [self.stillCamera capturePhotoAsImageProcessedUpToFilter:self.selectedFilter
                                       withCompletionHandler:^(UIImage *processedImage, NSError *error) {
                                           //拍照获得图片错误
                                           if(error)
                                           {
                                               NSLog(@"拍照错误: %@", error);
                                           }
                                           else
                                           {
                                               SEL selector = @selector(image:didFinishSavingWithError:contextInfo:);
                                               UIImageWriteToSavedPhotosAlbum(processedImage, self, selector, nil);
                                           }
                                       }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [self updatePhotoBrowserButton];
}

#pragma mark - Gesture
- (void)handleGesture:(UISwipeGestureRecognizer *)gesture
{
    switch (gesture.direction)
    {
        case UISwipeGestureRecognizerDirectionUp:
        case UISwipeGestureRecognizerDirectionDown:
        {
            //动作结束
            if (gesture.state == UIGestureRecognizerStateRecognized)
            {
                //切换前后置摄像头
                [self.stillCamera rotateCamera];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - Init
- (void)configureCamera
{
    self.stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack];
    self.stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
}

- (void)configureFilter
{
    //无效果滤镜
    GPUImageFilter *filter = [[GPUImageFilter alloc] init];
    [self.filters addObject:filter];
    
    //amatorka
    GPUImageAmatorkaFilter *amatorka = [[GPUImageAmatorkaFilter alloc] init];
    [self.filters addObject:amatorka];
    
    //Miss Etikate
    GPUImageMissEtikateFilter *missEtikate = [[GPUImageMissEtikateFilter alloc] init];
    [self.filters addObject:missEtikate];
    
    //Soft elegance
    GPUImageSoftEleganceFilter *softElegance = [[GPUImageSoftEleganceFilter alloc] init];
    [self.filters addObject:softElegance];
    
    //Sketch
    GPUImageSketchFilter *sketch = [[GPUImageSketchFilter alloc] init];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize size = CGSizeMake(window.frame.size.width * scale, window.frame.size.height * scale);
    [sketch setupFilterForSize:size];
    [sketch setEdgeStrength:1.0];
    [self.filters addObject:sketch];
    
    //-------  黑白风暴 ----START----
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
    
    //第一层滤镜
    GPUImageAmatorkaFilter *amator = [[GPUImageAmatorkaFilter alloc] init];
    [group addFilter:amator];
    
    //第二层滤镜
    GPUImageGrayscaleFilter *gray2 = [[GPUImageGrayscaleFilter alloc] init];
    [group addFilter:gray2];
    
    //amator结果输出到gray2
    [amator addTarget:gray2];
    
    //起始滤镜
    [group setInitialFilters:[NSArray arrayWithObject:amator]];
    
    //终止滤镜
    [group setTerminalFilter:gray2];
    [self.filters addObject:group];
    //-------  黑白风暴 ---END-----
    
    //Dylan
    BLLookUpFilter *dylan = [[BLLookUpFilter alloc] initWithLookUp:@"RedMelonLookUp.png"];
    [self.filters addObject:dylan];
}

- (void)switchFilter:(NSInteger)index
{
    //删除所有Targets
    [self.selectedFilter removeAllTargets];
    [self.stillCamera removeAllTargets];
    
    //重新设置
    self.selectedFilter = [self.filters objectAtIndex:index];
    [self.stillCamera addTarget:self.selectedFilter];
    [self.selectedFilter addTarget:self.cameraImageView];
}

- (void)configGuesture
{
    //摇一摇前后摄像头切换
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    [self becomeFirstResponder];
    
    //从下往上滑动，呼出相册
    UISwipeGestureRecognizer *bottomSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    bottomSwipe.direction = UISwipeGestureRecognizerDirectionUp;
    [self.cameraImageView addGestureRecognizer:bottomSwipe];
    
    //从上往下滑动，切换摄像头
    UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    upSwipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.cameraImageView addGestureRecognizer:upSwipe];
}

- (void)updatePhotoBrowserButton
{
    //获得相册的最后一张图
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    [lib enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        id type = [group valueForProperty:ALAssetsGroupPropertyType];
        if ([type integerValue] == 16)
        {
            CGImageRef imageRef = [group posterImage];
            UIImage *image = [UIImage imageWithCGImage:imageRef];
            [self.photobrowserButton setBackgroundImage:image forState:UIControlStateNormal];
            [UIView animateWithDuration:0.35 animations:^{
                self.photobrowserButton.alpha = 0.0;
                self.photobrowserButton.alpha = 1.0;
            }];
        }
        
    } failureBlock:^(NSError *error) {}];
}

@end
