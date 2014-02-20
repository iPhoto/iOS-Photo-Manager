//
//  WSImageViewController.m
//  Photo Manager
//
//  Created by Song Xintong on 14-2-14.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "WSImageViewController.h"

#import "WSAppDelegate.h"

#import "WSDescriptionView.h"

#import "UIIdentifierString.h"
#import "DisplayString.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface WSImageViewController ()

@property (strong, nonatomic) WSDescriptionView *descriptionView;

@end

@implementation WSImageViewController

#pragma mark - Access properties

- (WSDescriptionView *)descriptionView
{
    if (!_descriptionView) {
        CGSize viewSize = self.view.bounds.size;
        CGFloat toolbarHeight = self.navigationController.toolbar.frame.size.height;
        CGRect frame = CGRectMake(0, viewSize.height - toolbarHeight - 30, viewSize.width, 30);
        _descriptionView = [[WSDescriptionView alloc] initWithFrame:frame];
    }
    return _descriptionView;
}

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

- (void)viewWillAppear:(BOOL)animated
{
    [self.view addSubview:self.descriptionView];
    self.descriptionView.descriptionText = @"Something very long. Something very long. Something very long. Something very long. Something very long. Something very long. Something very long. Something very long. Something very long. Something very long. Something very long. Something very long. Something very long. Something very long. Something very long. Something very long. Something very long. Something very long. Something very long. Something very long. Something very long. Something very long. Something very long. Something very long. ";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
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
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.navigationController setToolbarHidden:NO animated:YES];
        [UIView animateWithDuration:0.2 animations:^{
            self.view.backgroundColor = [UIColor whiteColor];
        }];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.navigationController setToolbarHidden:YES animated:YES];
        [UIView animateWithDuration:0.2 animations:^{
            self.view.backgroundColor = [UIColor blackColor];
        }];
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
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale];
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardFrame = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSNumber *keyboardDuration = [[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    UIViewAnimationCurve keyboardCurve = [[[notification userInfo] valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    UIViewAnimationOptions keyboardAnimationOptions = keyboardCurve;
    CGRect originalFrame = self.descriptionView.frame;
    CGRect newFrame = CGRectMake(originalFrame.origin.x,
                                 keyboardFrame.origin.y - originalFrame.size.height,
                                 originalFrame.size.width,
                                 originalFrame.size.height);
    [UIView animateWithDuration:[keyboardDuration doubleValue]
                          delay:0 options:keyboardAnimationOptions
                     animations:^{
                         self.descriptionView.frame = newFrame;
                     }
                     completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
}

@end
