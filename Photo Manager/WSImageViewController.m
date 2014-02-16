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

@property (nonatomic, strong) UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *singleTapReconizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *doubleTapReconizer;

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
    
    if (self.scrollView) {
        [self.scrollView addSubview:self.imageView];
        [self fitScrollViewToImage];
    }
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    _scrollView.delegate = self;
    
    if (self.image) {
        [self.scrollView addSubview:self.imageView];
        [self fitScrollViewToImage];
    }
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
    
    [self.singleTapReconizer requireGestureRecognizerToFail:self.doubleTapReconizer];
    
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
    CGPoint offset = self.scrollView.contentOffset;
    NSLog(@"offset: %f %f", offset.x, offset.y);
    /*
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO];
        self.view.backgroundColor = [UIColor whiteColor];
    } else {
        [self.navigationController setNavigationBarHidden:YES];
        self.view.backgroundColor = [UIColor blackColor];
    }
    [self.parentViewController setNeedsStatusBarAppearanceUpdate];
     */
}

- (IBAction)zoomInOrOut:(UITapGestureRecognizer *)sender // tap twice, zoom in or out
{
    if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale) { // zoom out
        [self zoomImageToFitScrollViewAnimated:YES];
    } else { // zoom in at tap point
        CGPoint touchPoint = [sender locationInView:self.imageView];
        CGFloat scale = self.scrollView.maximumZoomScale / self.scrollView.minimumZoomScale;
        CGSize viewSize = self.scrollView.bounds.size;
        CGFloat originX, originY;
        originX = touchPoint.x - viewSize.width * 0.5 / scale;
        originY = touchPoint.y - viewSize.height * 0.5 / scale;
        CGRect rect = CGRectMake(originX, originY, viewSize.width / scale,
                                 viewSize.height / scale);
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
    [self moveImageToFitScrollViewAnimated:NO];
}

#pragma mark - Image scaling

- (void)fitScrollViewToImage
{
#warning Bounds size of scroll view shuold be set in storyboard. Setting it with screen size introduce error if UI is changed.
    if (!self.scrollView) {
        return;
    }
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self.scrollView setBounds:CGRectMake(0, 0, screenSize.width, screenSize.height)];
                                             
    if (!self.image) {
        self.scrollView.contentSize = CGSizeZero;
    } else {
        self.scrollView.zoomScale = 1.0;
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
        
        [self zoomImageToFitScrollViewAnimated:NO];
    }
}

- (void)zoomImageToFitScrollViewAnimated:(BOOL)animated
{
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:animated];
    [self moveImageToFitScrollViewAnimated:animated];
}

- (void)moveImageToFitScrollViewAnimated:(BOOL)animated
{
    CGSize viewSize = self.scrollView.bounds.size;
    CGSize contentSize = self.scrollView.contentSize;
    CGPoint contentOffset = self.scrollView.contentOffset;
    CGFloat offsetX, offsetY;
    if (viewSize.width > contentSize.width) {
        offsetX = (contentSize.width - viewSize.width) * 0.5;
    } else if (contentOffset.x < 0) {
        offsetX = 0.0;
    } else if (contentOffset.x + viewSize.width > contentSize.width) {
        offsetX = contentSize.width - viewSize.width;
    } else {
        offsetX = contentOffset.x;
    }
    if (viewSize.height > contentSize.height) {
        offsetY = (contentSize.height - viewSize.height) * 0.5;
    } else if (contentOffset.y < 0) {
        offsetY = 0.0;
    } else if (contentOffset.y + viewSize.height > contentSize.height) {
        offsetY = contentSize.height - viewSize.height;
    } else {
        offsetY = contentOffset.y;
    }
    
    [self.scrollView setContentOffset:CGPointMake(offsetX, offsetY) animated:animated];
    
}

@end
