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

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong)UIImage *image; // full resolution image of photo
@property (nonatomic, strong)NSIndexPath *indexpath; // position of photo in parent collection view

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

// Scaling and moving the displayed photo to fit the size of surrounded scroll view.
//
// The photo will be displayed centered and fully displayed, and as big as possible under that
// condition.
//
// |animated| indicates whether if the changing is happend animatedly or not.
- (void)fitImageToScrollViewAnimated:(BOOL)animated;

@end
