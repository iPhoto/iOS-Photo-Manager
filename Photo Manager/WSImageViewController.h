//
//  WSImageViewController.h
//  Photo Manager
//
//  Created by Song Xintong on 14-2-14.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "WSPhotoScrollView.h"

// UIViewController to display a photo.
@interface WSImageViewController : UIViewController

@property (nonatomic, strong) WSPhotoScrollView *scrollView;

@property (nonatomic, strong) UIImage *image; // full resolution image of photo
@property (nonatomic, strong) NSIndexPath *indexpath; // position of photo in parent collection view
@property (strong, nonatomic) UITapGestureRecognizer *singleTapRecognizer; // to switch full screen
@property (strong, nonatomic) UITapGestureRecognizer *doubleTapRecognizer; // to zoom in and out

// Returns a instance of WSImageViewController that displays the photo represented by |asset|.
//
// This method requires caller to provide |indexpath|, indicating the position of displayed photo in
// parent collection view, which is used to help find witch photo should be switched to when user
// swipes.
+ (WSImageViewController *)imageViewControllerForAsset:(ALAsset *)asset
                                             indexPath:(NSIndexPath *)indexpath;

// See WSImageViewController.imageViewControllerForAsset:indexPath:
//
// The only different is that caller provides URL identifier |assetURL| instead of the ALAsset
// instance.
+ (WSImageViewController *)imageViewControllerForAssetURL:(NSURL *)assetURL
                                                indexPath:(NSIndexPath *)indexpath;


@end
