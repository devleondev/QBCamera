//
//  QBPhotosCollectionViewCell.m
//  QBCamera
//
//  Created by LeoKing on 15/9/25.
//  Copyright © 2015年 Qbar.Inc. All rights reserved.
//

#import "QBPhotosCollectionViewCell.h"

@interface QBPhotosCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) ALAsset *asset;
@end

@implementation QBPhotosCollectionViewCell
- (void)loadAsset:(ALAsset *)asset
{
    [self setAsset:asset];
    
    //如果是相册内容
    if (asset)
    {
        CGImageRef thumb = [asset thumbnail];
        UIImage *image = [UIImage imageWithCGImage:thumb];
        [self.imgView setImage:image];
    }
    else
    {
        UIImage *image = [UIImage imageNamed:@"ic_camera_white"];
        UIImage *imageLight = [UIImage imageNamed:@"ic_camera_blue"];
        [self.imgView setImage:image];
        [self.imgView setHighlightedImage:imageLight];
    }
}
@end
