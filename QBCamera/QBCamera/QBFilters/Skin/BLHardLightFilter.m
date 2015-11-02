//
//  BLHardLightFilter.m
//  QBCamera
//
//  Created by LeoKing on 15/9/17.
//  Copyright (c) 2015年 Qbar.Inc. All rights reserved.
//

#import "BLHardLightFilter.h"
#import "GPUImageGaussianBlurFilter.h"
#import "GPUImageTwoInputFilter.h"

NSString *const BLHardLightFilterFragmentShaderString = SHADER_STRING
(
     varying highp vec2 textureCoordinate;
     varying highp vec2 textureCoordinate2;
     
     uniform sampler2D inputImageTexture;
     uniform sampler2D inputImageTexture2;
     
     const highp vec3 W = vec3(0.2125, 0.7154, 0.0721);
     
     void main()
     {
         mediump vec4 base = texture2D(inputImageTexture, textureCoordinate);
         mediump vec4 overlay = texture2D(inputImageTexture2, textureCoordinate2);
         
         highp float ba;
         if (2.0 * overlay.b < overlay.a)
         {
             ba = 2.0 * overlay.b * base.b + overlay.b * (1.0 - base.a) + base.b * (1.0 - overlay.a);
         }
         else
         {
             ba = overlay.a * base.a - 2.0 * (base.a - base.b) * (overlay.a - overlay.b) + overlay.b * (1.0 - base.a) + base.b * (1.0 - overlay.a);
         }
         
         gl_FragColor = vec4(ba, ba, ba, 1.0);
     }
);

@implementation BLHardLightFilter
@synthesize blurRadiusInPixels;

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    [self addFilter:blurFilter];
    
    greenBlueBlendFilter = [[GPUImageTwoInputFilter alloc] initWithFragmentShaderFromString:BLHardLightFilterFragmentShaderString];
    [self addFilter:greenBlueBlendFilter];
    
    [blurFilter addTarget:greenBlueBlendFilter atTextureLocation:1];
    
    self.initialFilters = [NSArray arrayWithObjects:blurFilter, greenBlueBlendFilter, nil];
    self.terminalFilter = greenBlueBlendFilter;
    self.blurRadiusInPixels = 5.0;
    
    return self;
}

#pragma mark -
#pragma mark Accessors

- (void)setBlurRadiusInPixels:(CGFloat)newValue;
{
    blurFilter.blurRadiusInPixels = newValue;
}

- (CGFloat)blurRadiusInPixels;
{
    return blurFilter.blurRadiusInPixels;
}

@end
