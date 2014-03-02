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
#import "WSPhotoBrowserPVC.h"
#import "UIIdentifierString.h"
#import "DisplayString.h"
#import "Photo+BasicOperations.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface WSImageViewController ()

@property (nonatomic, strong) WSImageViewControllerView *view;


@property (strong, nonatomic) Photo *photo;
@property (nonatomic) CGRect keyboardFrame; // frame of keyboard if it's on screen

@end

@implementation WSImageViewController

#pragma mark - Access properties

- (void)setImage:(UIImage *)image
{
    self.view.image = image;
}

- (UIImage *)image
{
    return self.view.image;
}

- (BOOL)keyboardOn
{
    return self.view.keyboardOn;
}

- (void)setPhoto:(Photo *)photo
{
    _photo = photo;
    self.view.descriptionText = photo.descriptionText;
    self.view.timeLocationText = [NSString stringWithFormat:@"%@ %@", photo.stringOfTime, photo.stringOfLocation];
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
                                                 frame:(CGRect)frame
{
    WSImageViewController *imageViewController = [[WSImageViewController alloc] initWithFrame:frame];

    imageViewController.photo = [Photo photoOfALAsset:asset
                               inManagedObjectContext:((WSAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext];
    imageViewController.indexpath = indexpath;
    imageViewController.image =
        [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];

    return imageViewController;
}

+ (WSImageViewController *)imageViewControllerForAssetURL:(NSURL *)assetURL
                                                indexPath:(NSIndexPath *)indexpath
                                                    frame:(CGRect)frame
{
    WSImageViewController *imageViewController = [[WSImageViewController alloc] initWithFrame:frame];
    imageViewController.indexpath = indexpath;

    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:assetURL
             resultBlock:^(ALAsset *asset) {
                 imageViewController.image =
                 [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
                 imageViewController.photo = [Photo photoOfALAsset:asset
                                            inManagedObjectContext:((WSAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext];
             }
            failureBlock:^(NSError *error) {
                NSLog(@"WSImageViewController.imageViewControllerForAssetURL:indexPath:");
                NSLog(@"Fetch asset failure error: %@", error);
            }];

    return imageViewController;
}

- (WSImageViewController *)initWithFrame:(CGRect)frame
{
    WSImageViewController *controller = [super init];
    if (controller) { // user custom root view instead
        controller.view = [[WSImageViewControllerView alloc] initWithFrame:frame controller:self];
    }
    return controller;
}

- (void)viewWillAppear:(BOOL)animated // Override
{
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

- (void)singleTapped // public
{
    if (self.keyboardOn) {
        [self dismissKeyboard];
        return;
    }
    
    WSPhotoBrowserPVC * parentPVC = (WSPhotoBrowserPVC *)self.parentViewController;
    if (parentPVC.parentAlbumsShown) {
        [parentPVC hideParentAlbums];
        return;
    }
    
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.navigationController setToolbarHidden:NO animated:YES];
        [self.view setDescriptionViewHidden:NO Animated:YES];
        [self.view setTimeLocationViewHidden:NO Animated:YES];
        [UIView animateWithDuration:0.2 animations:^{
            self.view.backgroundColor = [UIColor whiteColor];
        }];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.navigationController setToolbarHidden:YES animated:YES];
        [self.view setDescriptionViewHidden:YES Animated:YES];
        [self.view setTimeLocationViewHidden:YES Animated:YES];
        [UIView animateWithDuration:0.2 animations:^{
            self.view.backgroundColor = [UIColor blackColor];
        }];
    }
    WSAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.window.backgroundColor = self.view.backgroundColor;
    [self.parentViewController setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - Rotation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation // Override
                                         duration:(NSTimeInterval)duration
{
    [self.view fitImageToView];
}

- (void)fitImageToView // public
{
    [self.view fitImageToView];
}

#pragma mark - Description view
- (void)setDescriptionViewHidden:(BOOL)hidden Animated:(BOOL)animated
{
    [self.view setDescriptionViewHidden:hidden Animated:animated];
}

- (void)setTimeLocationViewHidden:(BOOL)hidden Animated:(BOOL)animated
{
    [self.view setTimeLocationViewHidden:hidden Animated:animated];
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification
{
    WSPhotoBrowserPVC *pvc = (WSPhotoBrowserPVC *)self.parentViewController;
    if (pvc.parentAlbumsShown) {
        [pvc hideParentAlbums];
    }
    
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
    self.photo.descriptionText = self.view.descriptionText;
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification
{
    // save keyboard frame for layout
    CGRect keyboardFrame = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardFrame = [self frameOfCurrentOrientationFromFrame:keyboardFrame];
}

- (CGRect)frameOfCurrentOrientationFromFrame:(CGRect)origFrame
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

- (void)dismissKeyboard
{
    [self.view dismissKeyboard];
}

@end
