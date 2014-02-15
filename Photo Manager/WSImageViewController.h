//
//  WSImageViewController.h
//  Photo Manager
//
//  Created by Song Xintong on 14-2-14.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface WSImageViewController : UIViewController

@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong)NSIndexPath *indexpath;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

+ (WSImageViewController *)imageViewControllerForAsset:(ALAsset *)asset
                                             indexPath:(NSIndexPath *)indexpath;

+ (WSImageViewController *)imageViewControllerForAssetURL:(NSURL *)assetURL
                                                indexPath:(NSIndexPath *)indexpath;

- (void)fitImageToScrollViewAnimated:(BOOL)animated;

@end
