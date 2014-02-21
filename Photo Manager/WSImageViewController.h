//
//  WSImageViewController.h
//  Photo Manager
//
//  Created by Song Xintong on 14-2-14.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

// UIViewController to display a photo.
@interface WSImageViewController : UIViewController

@property (nonatomic, strong) UIImage *image; // full resolution image of photo
@property (nonatomic, strong) NSIndexPath *indexpath; // position of photo in parent collection view

// Returns a instance of WSImageViewController that displays the photo represented by |asset|.
//
// This method requires caller to provide |indexpath|, indicating the position of displayed photo in
// parent collection view, which is used to help find witch photo should be switched to when user
// swipes.
//
// |frame| is the initail frame.
+ (WSImageViewController *)imageViewControllerForAsset:(ALAsset *)asset
                                             indexPath:(NSIndexPath *)indexpath
                                                 frame:(CGRect)frame;

// See WSImageViewController.imageViewControllerForAsset:indexPath:
//
// The only different is that caller provides URL identifier |assetURL| instead of the ALAsset
// instance.
//
// |frame| is the initail frame.
+ (WSImageViewController *)imageViewControllerForAssetURL:(NSURL *)assetURL
                                                indexPath:(NSIndexPath *)indexpath
                                                    frame:(CGRect)frame;

// Handle single tap gesture. If keyboar is on, this will dismiss the keyboard. Otherwise, this will
// switch between full screen mode and normal mode.
- (void)singleTapped;

// Set description view visibility.
//
// |hidden| indicates the visibility state should be set to description view. |animated|
// indicates should this change be animated.
- (void)setDescriptionViewHidden:(BOOL)hidden Animated:(BOOL)animated;

// Reset image to fit the screen and orientation.
- (void)fitImageToView;

@end
