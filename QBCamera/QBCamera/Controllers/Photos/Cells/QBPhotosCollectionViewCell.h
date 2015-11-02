//
//  QBPhotosCollectionViewCell.h
//  QBCamera
//
//  Created by LeoKing on 15/9/25.
//  Copyright © 2015年 Qbar.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface QBPhotosCollectionViewCell : UICollectionViewCell
- (void)loadAsset:(ALAsset *)asset;
@end
