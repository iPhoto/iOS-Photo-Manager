//
//  WSPhotosCVC.m
//  Photo Manager
//
//  Created by Tony Song on 14-2-14.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "WSPhotosCVC.h"

#import "WSPhotoCollectionCell.h"
#import "WSImageViewController.h"

#import "Photo+BasicOperations.h"

#import "UIIdentifierString.h"
#import "DisplayString.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface WSPhotosCVC () <UICollectionViewDataSource, UICollectionViewDelegate,
UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectButton;

@property (nonatomic, strong) ALAssetsLibrary *library; // to access photo assets
@property (nonatomic) BOOL selecting; // is under selection mode

@end

@implementation WSPhotosCVC

#pragma mark - IBActions

- (IBAction)selectPhotos:(UIBarButtonItem *)sender
{
    self.selecting = !self.selecting;
}

#pragma mark - Access properties

- (NSArray *)photos
{
    if (!_photos) {
        _photos = [[NSArray alloc] init];
    }
    return _photos;
}

- (ALAssetsLibrary *)library
{
    if (!_library) {
        _library = [[ALAssetsLibrary alloc] init];
    }
    return _library;
}

- (void)setSelecting:(BOOL)selecting
{
    _selecting = selecting;
    
    self.selectButton.title = _selecting ? DS_CANCEL : DS_SELECT;
    [self.navigationItem setHidesBackButton:_selecting animated:NO];
    self.navigationItem.title = _selecting ? DS_SELECT_PHOTOS : self.title;
    
    self.tabBarController.tabBar.hidden = _selecting;
    self.toolbar.hidden = !_selecting;

    if (!_selecting) {
        for (NSIndexPath *indexpath in [self.collectionView indexPathsForSelectedItems]) {
            [self.collectionView deselectItemAtIndexPath:indexpath animated:NO];
            WSPhotoCollectionCell *cell =
            (WSPhotoCollectionCell *)[self.collectionView cellForItemAtIndexPath:indexpath];
            [cell setSelectedViewHidden:YES];
        }
    }
    self.collectionView.allowsMultipleSelection = _selecting;
}

#pragma mark - Lifecycle

- (void)viewDidLoad // Override
{
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.selecting = NO;
}

# pragma mark - Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if (![self.photos count]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:IS_STORYBOARD_NAME bundle:nil];
        self.collectionView.backgroundView =
            ((UIViewController *)[storyboard instantiateViewControllerWithIdentifier:IS_NO_PHOTO]).view;
        self.selectButton.enabled = NO;
    } else {
        self.collectionView.backgroundView = nil;
    }
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WSPhotoCollectionCell *cell = [collectionView
                                   dequeueReusableCellWithReuseIdentifier:IS_PHOTO_CELL
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

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.selecting) {
        return;
    }
    WSPhotoCollectionCell *cell = (WSPhotoCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setSelectedViewHidden:NO];
}

- (void)collectionView:(UICollectionView *)collectionView
didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WSPhotoCollectionCell *cell = (WSPhotoCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setSelectedViewHidden:YES];
}

#pragma mark - Page view data source

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
                                                       indexPath:newIndexPath
                                                           frame:self.view.bounds];
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
        row = [self collectionView:self.collectionView
            numberOfItemsInSection:indexpath.section] - 1;
    }
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    Photo *photo = [self.photos objectAtIndex:newIndexPath.row];
    
    return [WSImageViewController imageViewControllerForAssetURL:[NSURL URLWithString:photo.id]
                                                       indexPath:newIndexPath
                                                           frame:self.view.bounds];
}

#pragma mark - Page view delegate

- (void)pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    WSImageViewController *ivc = [pendingViewControllers lastObject];
    if (ivc.navigationController.navigationBarHidden) {
        ivc.view.backgroundColor = [UIColor blackColor];
        [ivc setDescriptionViewHidden:YES Animated:NO];
    } else {
        ivc.view.backgroundColor = [UIColor whiteColor];
        [ivc setDescriptionViewHidden:NO Animated:NO];
    }
    [self.parentViewController setNeedsStatusBarAppearanceUpdate];

#warning This is not suggested. But I don't know other way to get oriented frame size before transition
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        ivc.view.frame = CGRectMake(0, 0, screenSize.height, screenSize.width);
    } else {
        ivc.view.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    }
    [ivc fitImageToView];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    WSImageViewController *ivc = [pageViewController.viewControllers lastObject];
    ivc.parentViewController.title = [NSString stringWithFormat:DS_PHOTO_TITLE_FORMAT,
                                      ivc.indexpath.row + 1,
                                    [self collectionView:self.collectionView
                                    numberOfItemsInSection:ivc.indexpath.section]];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender // Override
{
    if ([segue.identifier compare:IS_SEGUE_SHOW_PHOTO] == NSOrderedSame) {
        WSPhotoCollectionCell *cell = sender;
        WSImageViewController *imageViewController = [WSImageViewController imageViewControllerForAsset:cell.asset
                                                                                              indexPath:cell.indexpath
                                                                                                  frame:self.view.bounds];
        imageViewController.view.backgroundColor = [UIColor whiteColor];
        
        UIPageViewController *destination = segue.destinationViewController;
        [destination setViewControllers:@[imageViewController]
                              direction:UIPageViewControllerNavigationDirectionForward
                               animated:YES completion:nil];
        destination.dataSource = self;
        destination.delegate = self;
        destination.title = [NSString stringWithFormat:DS_PHOTO_TITLE_FORMAT, cell.indexpath.row + 1,
                             [self collectionView:self.collectionView
                           numberOfItemsInSection:cell.indexpath.section]];
    }

}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender // Override
{
    if ([identifier compare:IS_SEGUE_SHOW_PHOTO] == NSOrderedSame) {
        return !self.selecting;
    }
    return YES;
}

@end
