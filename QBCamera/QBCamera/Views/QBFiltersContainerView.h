//
//  QBFiltersContainerView.h
//  QBCamera
//
//  Created by LeoKing on 15/10/8.
//  Copyright © 2015年 Qbar.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage/GPUImage.h>
@interface QBFiltersContainerView : UIView
+ (void)show:(NSArray *)filters camera:(GPUImageStillCamera *)camera callback:(QBCallback)selectCallback;
@end
