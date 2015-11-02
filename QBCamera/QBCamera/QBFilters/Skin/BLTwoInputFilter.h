//
//  BLTwoInputFilter.h
//  QBCamera
//
//  Created by LeoKing on 15/9/17.
//  Copyright (c) 2015年 Qbar.Inc. All rights reserved.
//

#import "GPUImageFilter.h"

extern NSString *const BLTwoInputTextureVertexShaderString;
@interface BLTwoInputFilter : GPUImageFilter
{
    GPUImageFramebuffer *secondInputFramebuffer;
    GLint filterSecondTextureCoordinateAttribute;
    GLint filterInputTextureUniform2;
    GPUImageRotationMode inputRotation2;
    CMTime firstFrameTime, secondFrameTime;
    
    BOOL hasSetFirstTexture, hasReceivedFirstFrame, hasReceivedSecondFrame, firstFrameWasVideo, secondFrameWasVideo;
    BOOL firstFrameCheckDisabled, secondFrameCheckDisabled;
}

- (void)disableFirstFrameCheck;
- (void)disableSecondFrameCheck;

@end
