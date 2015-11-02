//
//  QBEditViewController.h
//  QBCamera
//
//  Created by LeoKing on 15/9/27.
//  Copyright © 2015年 Qbar.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBAbstractViewController.h"

@class ALAsset;
@interface QBEditViewController : QBAbstractViewController
@property (strong, nonatomic) ALAsset *asset;
@end
