//
//  WSPhotosCVC.m
//  Photo Manager
//
//  Created by Tony Song on 14-2-14.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "WSPhotosCVC.h"
#import "WSPhotoCollectionCell.h"
#import "Photo+BasicOperations.h"
#import "WSImageViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface WSPhotosCVC () <UICollectionViewDataSource, UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong)ALAssetsLibrary *library;

@end

@implementation WSPhotosCVC

- (ALAssetsLibrary *)library
{
    if (!_library) {
        _library = [[ALAssetsLibrary alloc] init];
    }
    return _library;
}

- (NSArray *)photos
{
    if (!_photos) {
        _photos = [[NSArray alloc] init];
    }
    return _photos;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WSPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"
                                                                            forIndexPath:indexPath];
    Photo *photo = [self.photos objectAtIndex:indexPath.row];
    [self.library assetForURL:[NSURL URLWithString:photo.id]
                  resultBlock:^(ALAsset *asset) {
                      cell.asset = asset;
                      cell.indexpath = indexPath;
                  }
                 failureBlock:^(NSError *error) {
                     NSLog(@"WSPhotosCVC.collectionView:cellForItemAtIndexPath:");
                     NSLog(@"Fetch asset failure error: %@", error);
                 }];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier compare:@"ShowPhoto"] == NSOrderedSame) {
        WSPhotoCollectionCell *cell = sender;
        
        WSImageViewController *imageViewController = [WSImageViewController imageViewControllerForAsset:cell.asset
                                                                                              indexPath:cell.indexpath];
        UIPageViewController *destination = segue.destinationViewController;
        [destination setViewControllers:@[imageViewController]
                              direction:UIPageViewControllerNavigationDirectionForward
                               animated:YES completion:nil];
        destination.dataSource = self;
        destination.delegate = self;
        destination.title = [NSString stringWithFormat:@"%ld/%ld", cell.indexpath.row + 1,
                                     [self collectionView:self.collectionView
                                   numberOfItemsInSection:cell.indexpath.section]];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSIndexPath *indexpath = ((WSImageViewController *)viewController).indexpath;
    NSInteger row = indexpath.row + 1;
    NSInteger section = indexpath.section;
    while (row == [self collectionView:self.collectionView
                       numberOfItemsInSection:indexpath.section]) {
        section = section + 1;
        if (section == [self numberOfSectionsInCollectionView:self.collectionView]) {
            return nil;
        }
        row = 0;
    }
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    Photo *photo = [self.photos objectAtIndex:newIndexPath.row];
    return [WSImageViewController imageViewControllerForAssetURL:[NSURL URLWithString:photo.id]
                                                    indexPath:newIndexPath];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSIndexPath *indexpath = ((WSImageViewController *)viewController).indexpath;
    NSInteger row = indexpath.row - 1;
    NSInteger section = indexpath.section;
    while (row < 0) {
        section = section - 1;
        if (section < 0) {
            return nil;
        }
        row = [self collectionView:self.collectionView numberOfItemsInSection:indexpath.section] - 1;
    }
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    Photo *photo = [self.photos objectAtIndex:newIndexPath.row];
    return [WSImageViewController imageViewControllerForAssetURL:[NSURL URLWithString:photo.id]
                                                                                    indexPath:newIndexPath];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    WSImageViewController *ivc = [pendingViewControllers lastObject];
    if (ivc.navigationController.navigationBarHidden) {
        ivc.view.backgroundColor = [UIColor blackColor];
    } else {
        ivc.view.backgroundColor = [UIColor whiteColor];
    }
    [self.parentViewController setNeedsStatusBarAppearanceUpdate];
    [ivc fitImageToScrollViewAnimated:NO];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    WSImageViewController *ivc = [pageViewController.viewControllers lastObject];
    ivc.parentViewController.title = [NSString stringWithFormat:@"%ld/%ld", ivc.indexpath.row + 1,
                                      [self collectionView:self.collectionView
                                    numberOfItemsInSection:ivc.indexpath.section]];
}

@end
