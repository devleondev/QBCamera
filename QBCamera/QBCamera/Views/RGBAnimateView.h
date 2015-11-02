//
//  RGBAnimateView.h
//  QBCamera
//
//  Created by LeoKing on 15/9/25.
//  Copyright © 2015年 Qbar.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RGBAnimateView : UIView
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, copy) QBCallback callback;
@end
