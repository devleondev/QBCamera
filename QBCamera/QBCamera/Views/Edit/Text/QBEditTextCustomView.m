//
//  QBEditTextCustomView.m
//  QBCamera
//
//  Created by LeoKing on 15/10/12.
//  Copyright © 2015年 Qbar.Inc. All rights reserved.
//

#import "QBEditTextCustomView.h"
#include <math.h>

#define pi M_PI
#define degreesToRadian(x) (pi * x / 180.0)
#define radiansToDegrees(x) (180.0 * x / pi)
CGFloat distanceBetweenPoints (CGPoint first, CGPoint second)
{
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX*deltaX + deltaY*deltaY );
};

CGFloat angleBetweenPoints(CGPoint first, CGPoint second)
{
    CGFloat height = second.y - first.y;
    CGFloat width = first.x - second.x;
    CGFloat rads = atan(height/width);
    return radiansToDegrees(rads);
}

CGFloat angleBetweenLines(CGPoint line1Start, CGPoint line1End, CGPoint line2Start, CGPoint line2End)
{
    CGFloat a = line1End.x - line1Start.x;
    CGFloat b = line1End.y - line1Start.y;
    CGFloat c = line2End.x - line2Start.x;
    CGFloat d = line2End.y - line2Start.y;
    
    CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
    return radiansToDegrees(rads);
}

@interface QBEditTextCustomView ()
@property (nonatomic, strong) UIView *superView;
@property (nonatomic, weak) IBOutlet UITextField *contentView;
@property (nonatomic, strong) UITouch *beginTouch;
@end

@implementation QBEditTextCustomView

#pragma mark - Public
+ (instancetype)showWithSuperView:(UIView *)superView
{
    NSString *xibName = NSStringFromClass([QBEditTextCustomView class]);
    QBEditTextCustomView *instance = [[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil][0];
    [instance setFrame:superView.bounds];
    [superView addSubview:instance];
    return instance;
}

+ (void)dismiss
{
    
}

#pragma mark - Touchs
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (touches.count > 0)
    {
        UITouch *touch = [touches anyObject];
        BOOL isIn = [self isInOperationArea:touch];
        if (isIn)
        {
            [self setBeginTouch:touch];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (touches.count > 0)
    {
        UITouch *touch = [touches anyObject];
        CGAffineTransform transform = [self transformAngle:touch];
        [self.contentView setTransform:transform];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setBeginTouch:nil];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setBeginTouch:nil];
}

#pragma mark - 

//判断点击的点是否在操作区域内
- (BOOL)isInOperationArea:(UITouch *)touch
{
    CGPoint touchPoint = [touch locationInView:self];
    
    CGFloat width = 30;
    CGFloat height = 30;
    CGFloat maxX = CGRectGetMaxX(self.contentView.frame) - width / 2;
    CGFloat minY = CGRectGetMinY(self.contentView.frame) - height / 2;
    CGRect inFrame = CGRectMake(maxX, minY, width, height);
    
    return CGRectContainsPoint(inFrame, touchPoint);
}

//计算旋转倾角
- (CGAffineTransform)transformAngle:(UITouch *)touch
{
    CGPoint endPoint = [touch locationInView:self];
    CGPoint startPoint = [[self beginTouch] locationInView:self];
    CGFloat angle = angleBetweenPoints(startPoint, endPoint);
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    return transform;
}


@end
