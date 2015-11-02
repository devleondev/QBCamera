//
//  QBPhotosViewController.m
//  QBCamera
//
//  Created by LeoKing on 15/9/25.
//  Copyright © 2015年 Qbar.Inc. All rights reserved.
//

#import "QBPhotosViewController.h"
#import "QBPhotosCollectionViewCell.h"
#import "QBEditViewController.h"

@interface QBPhotosViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *photosCollectionView;
@property (strong, nonatomic) NSMutableArray *assetsArray;
@property (strong, nonatomic) NSMutableArray *groupsArray;
@property (strong, nonatomic) ALAssetsLibrary *library;
@end

@implementation QBPhotosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configData];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showOrHideStatusBar:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - collection view
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetsArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = NSStringFromClass([QBPhotosCollectionViewCell class]);
    QBPhotosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (indexPath.row == 0)
    {
        //相机
        [cell loadAsset:nil];
    }
    else
    {
        //加载图片
        ALAsset *asset = self.assetsArray[indexPath.row - 1];
        [cell loadAsset:asset];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        //返回到相机
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        //得到选择的图片，导航到编辑界面
        ALAsset *asset = self.assetsArray[indexPath.row - 1];
        [self performSegueWithIdentifier:@"PB_EDIT" sender:asset];
    }
}

#pragma mark - data
- (void)configData
{
    self.assetsArray = [[NSMutableArray alloc] initWithCapacity:100];
    self.groupsArray = [[NSMutableArray alloc] initWithCapacity:10];
    self.library = [[ALAssetsLibrary alloc] init];
}

- (void)loadData
{
    //获得相册的最后一张图
    __weak QBPhotosViewController *weakSelf = self;
    [weakSelf.library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group)
        {
            [weakSelf.groupsArray addObject:group];
            
            id type = [group valueForProperty:ALAssetsGroupPropertyType];
            if ([type integerValue] == 16)
            {
                [self loadGroupData:group];
            }
        }
    } failureBlock:^(NSError *error) {}];
}

- (void)loadGroupData:(ALAssetsGroup *)group
{
    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result)
        {
            [self.assetsArray addObject:result];
        }
    }];
    [self.photosCollectionView reloadData];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    QBEditViewController *controller = [segue destinationViewController];
    SEL selector = @selector(setAsset:);
    if ([controller respondsToSelector:selector])
    {
        [controller setAsset:sender];
    }
}
@end
