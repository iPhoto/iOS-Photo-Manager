//
//  WSImageViewController.m
//  Photo Manager
//
//  Created by Song Xintong on 14-2-14.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "WSImageViewController.h"

#import "WSAppDelegate.h"

#import "UIIdentifierString.h"
#import "DisplayString.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface WSImageViewController ()

@end

@implementation WSImageViewController

#pragma mark - Access properties

- (void)setImage:(UIImage *)image
{
    self.scrollView.image = image;
}

- (UIImage *)image
{
    return self.scrollView.image;
}

- (WSPhotoScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[WSPhotoScrollView alloc] initWithFrame:self.view.bounds];

        [_scrollView updateOrientation:self.interfaceOrientation];
        [self.view addSubview:_scrollView];
        [_scrollView addGestureRecognizer:self.singleTapRecognizer];
        [_scrollView addGestureRecognizer:self.doubleTapRecognizer];
    }
    return _scrollView;
}

- (UITapGestureRecognizer *)singleTapRecognizer
{
    if (!_singleTapRecognizer) {
        _singleTapRecognizer =[[UITapGestureRecognizer alloc]
                               initWithTarget:self action:@selector(singleTapped:)];
        _singleTapRecognizer.numberOfTapsRequired = 1;
        [_singleTapRecognizer requireGestureRecognizerToFail:self.doubleTapRecognizer];
    }
    return _singleTapRecognizer;
}

- (UITapGestureRecognizer *)doubleTapRecognizer
{
    if (!_doubleTapRecognizer) {
        _doubleTapRecognizer =[[UITapGestureRecognizer alloc]
                               initWithTarget:self action:@selector(doubleTapped:)];
        _doubleTapRecognizer.numberOfTapsRequired = 2;
    }
    return _doubleTapRecognizer;
}

#pragma mark - Lifecyle

+ (WSImageViewController *)imageViewControllerForAsset:(ALAsset *)asset
                                             indexPath:(NSIndexPath *)indexpath
{
    WSImageViewController *imageViewController = [[WSImageViewController alloc] init];

    imageViewController.indexpath = indexpath;
    imageViewController.image =
        [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];

    return imageViewController;
}

+ (WSImageViewController *)imageViewControllerForAssetURL:(NSURL *)assetURL
                                                indexPath:(NSIndexPath *)indexpath
{
    WSImageViewController *imageViewController = [[WSImageViewController alloc] init];

    imageViewController.indexpath = indexpath;

    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:assetURL
             resultBlock:^(ALAsset *asset) {
                 imageViewController.image =
                 [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
             }
            failureBlock:^(NSError *error) {
                NSLog(@"WSImageViewController.imageViewControllerForAssetURL:indexPath:");
                NSLog(@"Fetch asset failure error: %@", error);
            }];

    return imageViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

#pragma mark - Gesture reconization

- (void)singleTapped:(UITapGestureRecognizer *)sender // tap once, switch to full screen or back
{
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController setToolbarHidden:NO];
        self.view.backgroundColor = [UIColor whiteColor];
    } else {
        [self.navigationController setNavigationBarHidden:YES];
        [self.navigationController setToolbarHidden:YES];
        self.view.backgroundColor = [UIColor blackColor];
    }
    WSAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.window.backgroundColor = self.view.backgroundColor;
    [self.parentViewController setNeedsStatusBarAppearanceUpdate];
}

- (void)doubleTapped:(UITapGestureRecognizer *)sender // tap twice, tell scroll view to zoom photo
{
    [self.scrollView doubleTapped:sender];
}

#pragma mark - Rotation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        [self.scrollView updateOrientation:toInterfaceOrientation];
        [self.scrollView updateZoomScale];
    }];
}

@end
