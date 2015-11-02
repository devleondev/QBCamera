//
//  QBEditViewController.m
//  QBCamera
//
//  Created by LeoKing on 15/9/27.
//  Copyright © 2015年 Qbar.Inc. All rights reserved.
//

#import "QBEditViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "QBEditTextCustomView.h"

@interface QBEditViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *options;
@property (strong, nonatomic) NSArray *subOptions;
@property (strong, nonatomic) NSMutableArray *showItems;
@property (assign, nonatomic) BOOL showSubItems;
@end

@implementation QBEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
    [self configUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showOrHideStatusBar:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UI
- (void)configUI
{
    [self.imgView setUserInteractionEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self configRightTitle:@"完成" target:self action:@selector(touchDownDoneButton:)];
    [self configButtons:self.options canBack:NO];
}

- (void)clearButtons:(QBCallback)callback
{
    if (self.showItems.count == 0)
    {
        callback(nil);
    }
    else
    {
        //删除原先的按钮
        __weak QBEditViewController *weakSelf = self;
        [weakSelf.showItems enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
            [button setTransform:CGAffineTransformIdentity];
            [UIView animateWithDuration:0.15 delay:idx * 0.04 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [button setTransform:CGAffineTransformMakeTranslation(0, 88)];
            } completion:^(BOOL finished) {
                if (finished)
                {
                    [button removeFromSuperview];
                    
                    if (idx == weakSelf.showItems.count - 1)
                    {
                        [self.showItems removeAllObjects];
                        
                        if (callback)
                        {
                            callback(nil);
                        }
                    }
                }
            }];
        }];
    }
}

- (void)showButtons
{
    //显示
    [self.showItems enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        [button setTransform:CGAffineTransformMakeTranslation(0, 88)];
        [UIView animateWithDuration:0.15 delay:idx * 0.04 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [button setTransform:CGAffineTransformIdentity];
        } completion:^(BOOL finished) {}];
    }];
}

- (void)configButtons:(NSArray *)options canBack:(BOOL)canBack
{
    [self clearButtons:^(id sender) {
        //创建新按钮
        CGFloat offset = 8;
        CGFloat height = CGRectGetHeight(self.scrollView.frame);
        CGFloat width = CGRectGetHeight(self.scrollView.frame) - 2 * offset;
        
        NSInteger count = options.count;
        NSInteger maxIndex = canBack? count + 1 : count;
        for (NSInteger i = 0; i < maxIndex; i++)
        {
            CGFloat x = offset + (offset + width) * i;
            CGFloat y = 0;
            CGRect frame = CGRectMake(x, y, width, height);
            UIButton *tmpButton = [[UIButton alloc] initWithFrame:frame];
            tmpButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.16];
            
            if (canBack && i == 0)
            {
                [tmpButton setTitle:@"返回" forState:UIControlStateNormal];
            }
            else
            {
                NSInteger index = canBack? i - 1 : i;
                NSDictionary *item = options[index];
                NSString *title = item[@"title"];
                [tmpButton setTitle:title forState:UIControlStateNormal];
            }
            
            [[tmpButton titleLabel] setFont:[UIFont systemFontOfSize:12]];
            [tmpButton setContentEdgeInsets:UIEdgeInsetsMake(height - 20, 0, 0, 0)];
            [tmpButton setTag:i];
            [tmpButton addTarget:self action:@selector(touchDownOptionsButton:) forControlEvents:UIControlEventTouchUpInside];
            
            //添加分割线
            if (i < count - 1)
            {
                CALayer *layer = [[CALayer alloc] init];
                layer.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.16].CGColor;
                layer.frame = CGRectMake(width + offset / 2, 5, 0.5, height - 10);
                [tmpButton.layer addSublayer:layer];
            }
            
            [self.scrollView addSubview:tmpButton];
            [self.showItems addObject:tmpButton];
        }
        
        [self.scrollView setContentSize:CGSizeMake(offset + (offset + width) * count, height)];
        [self showButtons];
    }];
}

#pragma mark - data
- (CGRect)resetImageViewFrame:(UIImage *)fsImage
{
    CGFloat width = 300;
    CGFloat height = 400;
    if (fsImage.size.width > fsImage.size.height)
    {
        width = 300;
        height = fsImage.size.height / fsImage.size.width * width;
    }
    else
    {
        height = 400;
        width = height * fsImage.size.width / fsImage.size.height;
    }
    
    CGFloat x = (CGRectGetWidth(self.view.frame) - width)/2;
    CGFloat y = 8 + (400 - height) / 2;
    
    return CGRectMake(x, y, width, height);
}

- (void)loadData
{
    ALAssetRepresentation *dr = [self.asset defaultRepresentation];
    CGImageRef fsImageRef = [dr fullScreenImage];
    UIImage *fsImage = [[UIImage alloc] initWithCGImage:fsImageRef];
    [self.imgView setImage:fsImage];
    
    //更新图片视图大小
    CGRect newFrame = [self resetImageViewFrame:fsImage];
    [self.imgView setFrame:newFrame];
    
    //编辑选项
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"EditOptions" ofType:@"plist"];
    self.options = [[NSArray alloc] initWithContentsOfFile:fileName];
    
    //存储Buttons
    self.showItems = [[NSMutableArray alloc] initWithCapacity:10];
}

#pragma mark - Actions
- (void)touchDownOptionsButton:(UIButton *)optionButton
{
    NSInteger index = optionButton.tag;
    if (self.showSubItems)
    {
        if (index == 0)
        {
            [self configButtons:self.options canBack:NO];
            [self setSubOptions:nil];
            [self setShowSubItems:NO];
        }
        else
        {
            //选择了子选项
            NSString *selStr = self.subOptions[index - 1][@"sel"];
            if (selStr)
            {
                SEL selector = NSSelectorFromString(selStr);
                [self performSelectorOnMainThread:selector withObject:nil waitUntilDone:YES];
            }
        }
    }
    else
    {
        //显示子选项
        NSDictionary *item = self.options[index];
        NSArray *subItems = item[@"items"];
        [self setSubOptions:subItems];
        [self configButtons:subItems canBack:YES];
        [self setShowSubItems:YES];
    }
}

- (void)touchDownDoneButton:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Option Actions
//文字－自定义
- (void)touchDownTextCustom:(id)sender
{
    [QBEditTextCustomView showWithSuperView:self.imgView];
}

//文字－电影字幕
- (void)touchDownTextMovie:(id)sender
{
    
}

//文字 - 水印
- (void)touchDownTextWaterMark:(id)sender
{
    
}
@end
