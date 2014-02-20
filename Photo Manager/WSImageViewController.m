//
//  WSImageViewController.m
//  Photo Manager
//
//  Created by Song Xintong on 14-2-14.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "WSImageViewController.h"

#import "WSAppDelegate.h"
#import "WSImageViewControllerView.h"
#import "WSPhotoScrollView.h"
#import "UIIdentifierString.h"
#import "DisplayString.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface WSImageViewController ()

@property (nonatomic, strong) WSImageViewControllerView *view;
@property (nonatomic, strong) WSPhotoScrollView *scrollView;

@property (strong, nonatomic) UITapGestureRecognizer *singleTapRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *doubleTapRecognizer;

@property (nonatomic) BOOL keyboardOn;
@property (nonatomic) CGRect keyboardFrame;

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
        
#warning TODO: Orientation
        [_scrollView updateOrientation:self.interfaceOrientation];
        [self.view insertSubview:_scrollView atIndex:0];
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
        _doubleTapRecognizer = [[UITapGestureRecognizer alloc]
                                initWithTarget:self action:@selector(doubleTapped:)];
        _doubleTapRecognizer.numberOfTapsRequired = 2;
    }
    return _doubleTapRecognizer;
}

- (BOOL)keyboardOn
{
    return self.view.keyboardOn;
}

- (void)setKeyboardOn:(BOOL)keyboardOn
{
    UIView *v = self.view;
    if (!v) {
        return;
    }
    self.view.keyboardOn = keyboardOn;
}

- (CGRect)keyboardFrame
{
    return self.view.keyboardFrame;
}

- (void)setKeyboardFrame:(CGRect)keyboardFrame
{
    self.view.keyboardFrame = keyboardFrame;
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

- (WSImageViewController *)init // Override
{
    WSImageViewController *controller = [super init];
    if (controller) { // user custom root view instead
        controller.view = [[WSImageViewControllerView alloc] initWithFrame:controller.view.frame controller:self];
    }
    return controller;
}

- (void)viewWillAppear:(BOOL)animated // Override
{
#warning Using test description text.
    self.view.descriptionText = @"照片描述照片描述照片描述照片描述照片描述照片描述照片描述照片描述照片描述照片描述照片描述照片描述照片描述照片描述";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidChangeFrame:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated // Override
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidChangeFrameNotification
                                                  object:nil];
}

#pragma mark - Gesture reconization

- (void)singleTapped:(UITapGestureRecognizer *)sender // tap once, dismiss keyboard if it's on,
                                                    // otherwise switch to full screen or back
{
    if (self.keyboardOn) {
#warning User taps on navigation bar will not dismiss keyboard.
        [self.view dismissKeyboard];
        return;
    }
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.navigationController setToolbarHidden:NO animated:YES];
        [self.view setDescriptionViewHidden:NO Animated:YES];
        [UIView animateWithDuration:0.2 animations:^{
            self.view.backgroundColor = [UIColor whiteColor];
        }];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.navigationController setToolbarHidden:YES animated:YES];
        [self.view setDescriptionViewHidden:YES Animated:YES];
        [UIView animateWithDuration:0.2 animations:^{
            self.view.backgroundColor = [UIColor blackColor];
        }];
    }
    WSAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.window.backgroundColor = self.view.backgroundColor;
    [self.parentViewController setNeedsStatusBarAppearanceUpdate];
}

- (void)doubleTapped:(UITapGestureRecognizer *)sender // tap twice, notify scroll view to zoom photo
{
    [self.scrollView doubleTapped:sender];
}

#pragma mark - Rotation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation // Override
                                         duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        [self.scrollView updateOrientation:toInterfaceOrientation];
        [self.scrollView updateZoomScale];
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale];
        CGSize viewSize = self.view.bounds.size;
        CGFloat toolbarHeight = self.navigationController.toolbar.frame.size.height;
        CGRect frame = CGRectMake(0, viewSize.height - toolbarHeight - 100, viewSize.width, 100);
        //self.descriptionView.frame = frame;
    }];
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardFrame = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrame = [self frameOfCurrentOrientationFromFrame:keyboardFrame];
    NSTimeInterval keyboardDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
#warning UIKeyboardAnimationCurve returned 7, which is not valid.
    UIViewAnimationCurve keyboardCurve = [[[notification userInfo] valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    UIViewAnimationOptions keyboardAnimationOptions = keyboardCurve << 16;
    [self.view animateDescriptionViewWithKeyboardFrame:keyboardFrame
                                              duration:keyboardDuration
                                               options:keyboardAnimationOptions];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSTimeInterval keyboardDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
#warning UIKeyboardAnimationCurve returned 7, which is not valid.
    UIViewAnimationCurve keyboardCurve = [[[notification userInfo] valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    UIViewAnimationOptions keyboardAnimationOptions = keyboardCurve << 16;
    [self.view animateDescriptionViewBackWithDuration:keyboardDuration
                                              options:keyboardAnimationOptions];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    self.keyboardOn = YES;
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    self.keyboardOn = NO;
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification
{
    // save keyboard frame for layout
    CGRect keyboardFrame = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardFrame = [self frameOfCurrentOrientationFromFrame:keyboardFrame];
}

- (CGRect)frameOfCurrentOrientationFromFrame:(CGRect)origFrame // public
{
    CGRect frame = origFrame;
    CGSize viewSize = self.view.bounds.size; // do not support up-sides-down
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        frame = CGRectMake(origFrame.origin.y,
                           viewSize.height - origFrame.size.width - origFrame.origin.x,
                           origFrame.size.height,
                           origFrame.size.width);
    }
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        frame = CGRectMake(viewSize.width - origFrame.origin.y - origFrame.size.height,
                           origFrame.origin.x,
                           origFrame.size.height,
                           origFrame.size.width);
    }
    return frame;
}

@end
