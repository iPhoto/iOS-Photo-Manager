//
//  WSImageViewController.m
//  Photo Manager
//
//  Created by Song Xintong on 14-2-14.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "WSImageViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface WSImageViewController () <UIScrollViewDelegate>

@property (nonatomic, strong)UIImageView *imageView;



@end

@implementation WSImageViewController

+ (WSImageViewController *)imageViewControllerForAsset:(ALAsset *)asset
                                             indexPath:(NSIndexPath *)indexpath
{
    WSImageViewController *imageViewController =
    [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
     instantiateViewControllerWithIdentifier:@"PhotoBrowser"];
    imageViewController.image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
    imageViewController.indexpath = indexpath;
    return imageViewController;
}

+ (WSImageViewController *)imageViewControllerForAssetURL:(NSURL *)assetURL
                                                indexPath:(NSIndexPath *)indexpath
{
    WSImageViewController *imageViewController =
    [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
     instantiateViewControllerWithIdentifier:@"PhotoBrowser"];
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

- (IBAction)switchFullScreenMode:(UITapGestureRecognizer *)sender
{
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO];
        self.view.backgroundColor = [UIColor whiteColor];
    } else {
        [self.navigationController setNavigationBarHidden:YES];
        self.view.backgroundColor = [UIColor blackColor];
    }
    [self.parentViewController setNeedsStatusBarAppearanceUpdate];
}

- (IBAction)zoomInOrOut:(UITapGestureRecognizer *)sender
{
    NSLog(@"%f", self.scrollView.zoomScale);
    if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale) {
        [self fitImageToScrollViewAnimated:YES];
    } else {
        CGSize viewSize = self.scrollView.bounds.size;
        CGFloat maxScale = self.scrollView.maximumZoomScale;
        CGPoint touchPoint = [sender locationInView:self.imageView];
        CGFloat centerX, centerY;
        centerX = touchPoint.x - viewSize.width * 0.5 / maxScale;
        centerY = touchPoint.y - viewSize.height * 0.5 / maxScale;
        if (centerX < 0) {
            centerX = 0.0;
        }
        if (centerY < 0) {
            centerY = 0.0;
        }
        CGRect rect = CGRectMake(centerX, centerY, viewSize.width / maxScale, viewSize.height / maxScale);
        [self.scrollView zoomToRect:rect animated:YES];
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIImage *)image
{
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    [self.imageView sizeToFit];

    [self fitScrollViewToImage];
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    _scrollView.delegate = self;

    [self fitScrollViewToImage];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)fitScrollViewToImage
{
#warning
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self.scrollView setBounds:CGRectMake(0, 0, screenSize.width, screenSize.height)];
                                             
    if (!self.image) {
        self.scrollView.contentSize = CGSizeZero;
    } else {
        self.scrollView.contentSize = self.image.size;
        
        CGSize imageSize = self.scrollView.contentSize;
        CGSize viewSize = self.scrollView.bounds.size;
        CGFloat minScaleX, minScaleY, maxScaleX, maxScaleY;
        if (imageSize.width > viewSize.width) {
            minScaleX = viewSize.width / imageSize.width;
            maxScaleX = 1.0;
        } else {
            minScaleX = 1.0;
            maxScaleX = viewSize.width / imageSize.width;
        }
        if (imageSize.height > viewSize.height) {
            minScaleY = viewSize.height / imageSize.height;
            maxScaleY = 1.0;
        } else {
            minScaleY = 1.0;
            maxScaleY = viewSize.height / imageSize.height;
        }
        
        self.scrollView.minimumZoomScale = minScaleX > minScaleY ? minScaleY : minScaleX;
        self.scrollView.maximumZoomScale = maxScaleX > maxScaleY ? maxScaleX : maxScaleY;
        if (self.scrollView.maximumZoomScale < 3 * self.scrollView.minimumZoomScale) {
            self.scrollView.maximumZoomScale = 3 * self.scrollView.minimumZoomScale;
        }
    }
    
    [self fitImageToScrollViewAnimated:NO];
}

- (void)fitImageToScrollViewAnimated:(BOOL)animated
{
    CGSize viewSize = self.scrollView.bounds.size;
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:animated];
    if (animated) {
        [UIView animateWithDuration:1.0 animations:^{
            self.imageView.center = CGPointMake(viewSize.width * 0.5, viewSize.height * 0.5);
        }];
    } else {
        self.imageView.center = CGPointMake(viewSize.width * 0.5, viewSize.height * 0.5);
    }
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
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
    [self.scrollView addSubview:self.imageView];
    
    CGSize size = self.scrollView.bounds.size;
    NSLog(@"%f, %f", size.width, size.height);
	// Do any additional setup after loading the view.
    /*if (self.navigationController.navigationBarHidden) {
        self.view.backgroundColor = [UIColor blackColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
