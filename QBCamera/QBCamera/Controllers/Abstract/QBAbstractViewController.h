//
//  QBAbstractViewController.h
//  QBCamera
//
//  Created by LeoKing on 15/10/2.
//  Copyright © 2015年 Qbar.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBAbstractViewController : UIViewController
- (void)showOrHideStatusBar:(BOOL)state;
- (void)configRightTitle:(NSString *)title target:(id)target action:(SEL)action;
@end
