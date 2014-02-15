//
//  WSImageViewController.m
//  Photo Manager
//
//  Created by Song Xintong on 14-2-14.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "WSImageViewController.h"

#import "UIIdentifierString.h"
#import "DisplayString.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface WSImageViewController () <UIScrollViewDelegate>

@property (nonatomic, strong)UIImageView *imageView;

@end

@implementation WSImageViewController

#pragma mark - Access properties

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

#pragma mark - Lifecyle

+ (WSImageViewController *)imageViewControllerForAsset:(ALAsset *)asset
                                             indexPath:(NSIndexPath *)indexpath
{
    WSImageViewController *imageViewController =
    [[UIStoryboard storyboardWithName:IS_STORYBOARD_NAME bundle:nil]
     instantiateViewControllerWithIdentifier:IS_PHOTO_BROWSER];
    imageViewController.image =
    [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
    imageViewController.indexpath = indexpath;
    return imageViewController;
}

+ (WSImageViewController *)imageViewControllerForAssetURL:(NSURL *)assetURL
                                                indexPath:(NSIndexPath *)indexpath
{
    WSImageViewController *imageViewController =
    [[UIStoryboard storyboardWithName:IS_STORYBOARD_NAME bundle:nil]
     instantiateViewControllerWithIdentifier:IS_PHOTO_BROWSER];
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
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)switchFullScreenMode:(UITapGestureRecognizer *)sender // tap once,
                                                                // switch to full screen or back
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

- (IBAction)zoomInOrOut:(UITapGestureRecognizer *)sender // tap twice, zoom in or out
{
    if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale) { // zoom out
        [self fitImageToScrollViewAnimated:YES];
    } else { // zoom in at tap point
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
        CGRect rect = CGRectMake(centerX, centerY, viewSize.width / maxScale,
                                 viewSize.height / maxScale);
        [self.scrollView zoomToRect:rect animated:YES];
    }
}

#pragma mark - Scroll view delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
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

#pragma mark - Image scaling

- (void)fitScrollViewToImage
{
#warning Bounds size of scroll view shuold be set in storyboard. Setting it with screen size introduce error if UI is changed.
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

@end
