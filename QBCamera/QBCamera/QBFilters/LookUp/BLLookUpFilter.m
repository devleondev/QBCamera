//
//  BLDylanFilter.m
//  QBCamera
//
//  Created by LeoKing on 15/9/24.
//  Copyright © 2015年 Qbar.Inc. All rights reserved.
//

#import "BLLookUpFilter.h"
#import "GPUImagePicture.h"
#import "GPUImageLookupFilter.h"

@implementation BLLookUpFilter
- (id)initWithLookUp:(NSString *)fileName
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    UIImage *image = [UIImage imageNamed:fileName];
    
    NSAssert(image, @"To use GPUImageAmatorkaFilter you need to add lookup_amatorka.png from GPUImage/framework/Resources to your application bundle.");
    
    lookupImageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageLookupFilter *lookupFilter = [[GPUImageLookupFilter alloc] init];
    [self addFilter:lookupFilter];
    
    [lookupImageSource addTarget:lookupFilter atTextureLocation:1];
    [lookupImageSource processImage];
    
    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = lookupFilter;
    
    return self;
}
@end
