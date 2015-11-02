//
//  GPUImageBloomFilter.m
//  QBCamera
//
//  Created by LeoKing on 15/9/18.
//  Copyright (c) 2015年 Qbar.Inc. All rights reserved.
//

#import "GPUImageBloomFilter.h"

NSString *const kGPUImageBloomFragmentShaderString = SHADER_STRING
(
 varying lowp vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 void main() {
     lowp vec4 sum = vec4(0);
     lowp int j;
     lowp int i;
     for( i = -4; i < 4; i++)
     {
         for (j = -3; j < 3; j++)
         {
             sum += texture2D(inputImageTexture, textureCoordinate + vec2(j, i) * 0.004) * 0.25;
         }
     }
     
     if (texture2D(inputImageTexture, textureCoordinate).r < 0.3)
     {
         gl_FragColor = sum * sum * 0.012 + texture2D(inputImageTexture, textureCoordinate);
     }
     else
     {
         if (texture2D(inputImageTexture, textureCoordinate).r < 0.5)
         {
             gl_FragColor = sum * sum * 0.009 + texture2D(inputImageTexture, textureCoordinate);
         }
         else
         {
             gl_FragColor = sum * sum * 0.0075 + texture2D(inputImageTexture, textureCoordinate);
         }
     }
 }
);

@implementation GPUImageBloomFilter
- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kGPUImageBloomFragmentShaderString]))
    {
        return nil;
    }
    return self;
}
@end
