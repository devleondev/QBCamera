//
//  BLHighContrastFilter.m
//  QBCamera
//
//  Created by LeoKing on 15/9/16.
//  Copyright (c) 2015年 Qbar.Inc. All rights reserved.
//

#import "BLHighContrastFilter.h"
#import "GPUImageGaussianBlurFilter.h"
#import "GPUImageTwoInputFilter.h"

NSString *const BLHighContrastFragmentShaderString = SHADER_STRING
(
    varying highp vec2 textureCoordinate;
    varying highp vec2 textureCoordinate2;

    uniform sampler2D inputImageTexture;
    uniform sampler2D inputImageTexture2;
    void main()
    {
        mediump vec4 base = texture2D(inputImageTexture, textureCoordinate);
        mediump vec4 overlay = texture2D(inputImageTexture2, textureCoordinate2);
        mediump vec4 result = base - overlay;
        gl_FragColor = vec4(result.rgb + 0.5, 1.0);
    }
);

@implementation BLHighContrastFilter
@synthesize blurRadiusInPixels;

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    blurFilter.blurRadiusInPixels = 5.0;
    [self addFilter:blurFilter];
    
    greenBlueBlendFilter = [[GPUImageTwoInputFilter alloc] initWithFragmentShaderFromString:BLHighContrastFragmentShaderString];
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


