//
//  BLDylanFilter.h
//  QBCamera
//
//  Created by LeoKing on 15/9/24.
//  Copyright © 2015年 Qbar.Inc. All rights reserved.
//

#import "GPUImageFilterGroup.h"

@class GPUImagePicture;
@interface BLLookUpFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}
- (id)initWithLookUp:(NSString *)fileName;
@end
