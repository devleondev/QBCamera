//
//  QBAbstractViewController.m
//  QBCamera
//
//  Created by LeoKing on 15/10/2.
//  Copyright © 2015年 Qbar.Inc. All rights reserved.
//

#import "QBAbstractViewController.h"

@interface QBAbstractViewController ()

@end

@implementation QBAbstractViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self baseConfigUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
- (void)baseConfigUI
{
    [self configNavBack];
}

- (void)configNavBack
{
    [self configNavImage:@"ic_nav_back" target:self action:@selector(didNaviLeftButtonClicked)];
}

- (void)configNavImage:(NSString *)imageName target:(id)target action:(SEL)action
{
    UINavigationController *nav = self.navigationController;
    if (nav)
    {
        NSArray *controllers = [nav viewControllers];
        UIViewController *firstObj = [controllers firstObject];
        UIViewController *lastObj = [controllers lastObject];
        
        //不是根控制器
        if (![firstObj isEqual:lastObj])
        {
            CGRect frame = CGRectMake(0, 7, 50, 30);
            UIView *backView = [[UIView alloc] initWithFrame:frame];
            
            UIImage *image = [UIImage imageNamed:imageName];
            CGRect imageFrame = CGRectMake(-4, (30 - image.size.height)/2, image.size.width, image.size.height);
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
            [imageView setImage:image];
            [backView addSubview:imageView];
            
            CGRect buttonFrame = CGRectMake(14, 0, 36, 30);
            UIButton *backButton = [[UIButton alloc] initWithFrame:buttonFrame];
            [backButton setBackgroundColor:[UIColor clearColor]];
            [backButton setTitle:@"返回" forState:UIControlStateNormal];
            [[backButton titleLabel] setFont:[UIFont systemFontOfSize:16]];
            [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:backButton];
            
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
        }
    }
}

- (void)configRightTitle:(NSString *)title target:(id)target action:(SEL)action
{
    CGRect windowFrame = [[[[UIApplication sharedApplication] delegate] window] frame];
    CGRect rightFrame = CGRectMake(CGRectGetWidth(windowFrame) - 36 - 16, 7, 36, 30);
    UIButton *rightButton = [[UIButton alloc] initWithFrame:rightFrame];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    [rightButton setTitle:title forState:UIControlStateNormal];
    [[rightButton titleLabel] setFont:[UIFont systemFontOfSize:16]];
    [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

#pragma mark - Show or hide Status bar
- (void)showOrHideStatusBar:(BOOL)state
{
    UIApplication *application = [UIApplication sharedApplication];
    UIStatusBarAnimation animation = state? UIStatusBarAnimationFade : UIStatusBarAnimationNone;
    if ([application respondsToSelector:@selector(setStatusBarHidden:withAnimation:)])
    {
        [application setStatusBarHidden:state withAnimation:animation];
    }
    else
    {
        [application setStatusBarHidden:state];
    }
}

#pragma mark - Actions
- (void)didNaviLeftButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
