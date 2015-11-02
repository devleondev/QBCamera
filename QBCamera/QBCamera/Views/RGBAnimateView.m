//
//  RGBAnimateView.m
//  QBCamera
//
//  Created by LeoKing on 15/9/25.
//  Copyright © 2015年 Qbar.Inc. All rights reserved.
//

#import "RGBAnimateView.h"

@implementation RGBAnimateView

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.callback)
    {
        self.callback(nil);
    }
}

@end
