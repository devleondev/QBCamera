//
//  BLHardLightFilter.h
//  QBCamera
//
//  Created by LeoKing on 15/9/17.
//  Copyright (c) 2015年 Qbar.Inc. All rights reserved.
//

#import "GPUImageFilterGroup.h"

@class GPUImageGaussianBlurFilter;
@interface BLHardLightFilter : GPUImageFilterGroup
{
    GPUImageGaussianBlurFilter *blurFilter;
    GPUImageFilter *greenBlueBlendFilter;
}
@property (readwrite, nonatomic) CGFloat blurRadiusInPixels;
@end
