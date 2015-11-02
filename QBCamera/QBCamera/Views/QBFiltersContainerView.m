//
//  QBFiltersContainerView.m
//  QBCamera
//
//  Created by LeoKing on 15/10/8.
//  Copyright © 2015年 Qbar.Inc. All rights reserved.
//

#import "QBFiltersContainerView.h"

@interface QBFiltersContainerView ()
@property (nonatomic, copy) QBCallback callback;
@property (nonatomic, strong) NSMutableArray *buttons;
@end

@implementation QBFiltersContainerView
+ (void)show:(NSArray *)filters camera:(GPUImageStillCamera *)camera callback:(QBCallback)selectCallback
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    QBFiltersContainerView *staticView = [[QBFiltersContainerView alloc] initWithFrame:window.frame];
    staticView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    [window addSubview:staticView];
    
    //得到当前target
    NSArray *currentTargets = camera.targets;
    
    //创建按钮
    [staticView createButtons:filters camera:camera];
    
    //显示
    [staticView showWithAnimation:filters];
    
    //设置回调
    __weak QBFiltersContainerView *weakView = staticView;
    [staticView setCallback:^(UIButton *selectedButton){
        
        //删除添加的对象
        NSMutableArray *targets = [[NSMutableArray alloc] initWithCapacity:10];
        [[camera targets] enumerateObjectsUsingBlock:^(id<GPUImageInput> obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL exists = [currentTargets containsObject:obj];
            if (!exists)
            {
                [targets addObject:obj];
            }
        }];
        
        //删除原来添加的对象
        [targets enumerateObjectsUsingBlock:^(id<GPUImageInput> obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [camera removeTarget:obj];
        }];
        
        //切换
        if (selectedButton)
        {
            NSInteger index = selectedButton.tag;
            if (selectCallback)
            {
                selectCallback(@(index));
            }
        }
        
        //隐藏
        [weakView hideWithAnimation:filters];
    }];
}

#pragma mark - Private
- (void)createButtons:(NSArray *)filters camera:(GPUImageStillCamera *)camera
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGFloat winWidth = CGRectGetWidth(window.frame);
    
    __block NSArray *titles = @[@"None", @"Amatorka", @"Miss Etikate", @"Soft elegance", @"Sketch", @"Strong B&W", @"Dylan"];
    
    NSInteger colum = 3;
    CGFloat row = filters.count % colum == 0? filters.count / colum : filters.count / colum + 1;
    __block CGFloat x = 0;
    __block CGFloat y = 0;
    CGFloat xMargin = 10;
    CGFloat xOffset = 0;
    CGFloat yMargin = 10;
    CGFloat yOffset = 0;
    __block CGFloat width = (winWidth - (colum - 1) * xMargin) / colum;
    __block CGFloat height = (winWidth * (4.0 / 3.0) - (row - 1) * yMargin) / row;
    self.buttons = [[NSMutableArray alloc] initWithCapacity:10];
    [filters enumerateObjectsUsingBlock:^(GPUImageFilter *filter, NSUInteger idx, BOOL * _Nonnull stop) {
        
        x = xOffset + (xMargin + width) * (idx % colum);
        y = yOffset + (yMargin + height) * (idx / colum);
        CGRect frame = CGRectMake(x, y, width, height);
        
        UIButton *button = [[UIButton alloc] initWithFrame:frame];
        button.backgroundColor = [UIColor clearColor];
        button.tag = idx;
        [button addTarget:self action:@selector(touchDownFilterButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        //加实时滤镜效果
        GPUImageView *imageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        imageView.userInteractionEnabled = NO;
        [button addSubview:imageView];
        [camera addTarget:filter];
        [filter addTarget:imageView];
        
        //加滤镜标题
        UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(4, height - 20, width - 8, 20)];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.text = titles[idx];
        titleView.textAlignment = NSTextAlignmentRight;
        titleView.textColor = [UIColor whiteColor];
        titleView.shadowColor = [UIColor lightGrayColor];
        titleView.shadowOffset = CGSizeMake(0.5, 0.5);
        titleView.font = [UIFont systemFontOfSize:12];
        [button addSubview:titleView];
        [self.buttons addObject:button];
        
    }];
}

- (void)showWithAnimation:(NSArray *)filters
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGFloat winWidth = CGRectGetWidth(window.frame);
    
    NSInteger colum = 3;
    CGFloat row = filters.count % colum == 0? filters.count / colum : filters.count / colum + 1;
    CGFloat xMargin = 10;
    CGFloat yMargin = 10;
    __block CGFloat width = (winWidth - (colum - 1) * xMargin) / colum;
    __block CGFloat height = (winWidth * (4.0 / 3.0) - (row - 1) * yMargin) / row;
    
    __weak QBFiltersContainerView *weakView = self;
    
    //视图动画效果
    [UIView animateWithDuration:0.25 animations:^{
        weakView.alpha = 0.0;
        weakView.alpha = 1.0;
    }];
    
    //按钮动画效果
    [weakView.buttons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //变换
        NSInteger tx = idx % colum - 1;
        NSInteger ty = idx / colum - 1;
        CGAffineTransform transform = CGAffineTransformMakeTranslation(tx * width, ty * height);
        CGAffineTransform orgTransform = CGAffineTransformIdentity;
        obj.transform = transform;
        
        [UIView animateWithDuration:0.25 animations:^{
            obj.transform = orgTransform;
        }];
        
        [UIView animateWithDuration:0.35 animations:^{
            obj.alpha = 0.0;
            obj.alpha = 1.0;
        }];
    }];
}

- (void)hideWithAnimation:(NSArray *)filters
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGFloat winWidth = CGRectGetWidth(window.frame);
    
    NSInteger colum = 3;
    CGFloat row = filters.count % colum == 0? filters.count / colum : filters.count / colum + 1;
    CGFloat xMargin = 10;
    CGFloat yMargin = 10;
    __block CGFloat width = (winWidth - (colum - 1) * xMargin) / colum;
    __block CGFloat height = (winWidth * (4.0 / 3.0) - (row - 1) * yMargin) / row;
    
    __weak QBFiltersContainerView *weakView = self;
        
    //动画效果
    [UIView animateWithDuration:0.25 animations:^{
        [weakView setAlpha:1.0];
        [weakView setAlpha:0.0];
    } completion:^(BOOL finished) {
        [weakView removeFromSuperview];
    }];
    
    //按钮的动画效果
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //变换
        NSInteger tx = idx % colum - 1;
        NSInteger ty = idx / colum - 1;
        obj.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.25 animations:^{
            obj.transform = CGAffineTransformMakeTranslation(tx * width, ty * height);
        }];
        
        [UIView animateWithDuration:0.35 animations:^{
            obj.alpha = 1.0;
            obj.alpha = 0.0;
        }];
    }];
}

#pragma mark - Action
- (void)touchDownFilterButton:(id)sender
{
    if(self.callback)
    {
        self.callback(sender);
    }
}

#pragma mark -
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(self.callback)
    {
        self.callback(nil);
    }
}
@end
