//
//  WSImageViewController.m
//  Photo Manager
//
//  Created by Song Xintong on 14-2-14.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "WSImageViewController.h"

@interface WSImageViewController () <UIScrollViewDelegate>

@property (nonatomic, strong)UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation WSImageViewController

- (void)switchFullScreenMode:(UITapGestureRecognizer *)sender {
    if(self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.view.backgroundColor = [UIColor whiteColor];
        [self.tabBarController.tabBar setHidden:NO];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        self.view.backgroundColor = [UIColor blackColor];
        [self.tabBarController.tabBar setHidden:YES];
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
    if (!self.image) {
        self.scrollView.contentSize = CGSizeZero;
    } else {
        self.scrollView.contentSize = self.image.size;

        CGRect contentRect = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
        [self.scrollView zoomToRect:contentRect animated:NO];

        CGFloat offsetX, offsetY;
        if (self.scrollView.bounds.size.width > self.scrollView.contentSize.width) {
            offsetX = (self.scrollView.bounds.size.width - self.scrollView.contentSize.width) * 0.5;
        } else {
            offsetX = 0.0;
        }

        if (self.scrollView.bounds.size.height > self.scrollView.contentSize.height) {
            offsetY = (self.scrollView.bounds.size.height - self.scrollView.contentSize.height) * 0.5;
        } else {
            offsetY = 0.0;
        }

        self.imageView.center = CGPointMake(self.scrollView.contentSize.width * 0.5 + offsetX,
                                     self.scrollView.contentSize.height * 0.5 + offsetY);



        //self.scrollView.maximumZoomScale = 2.0;
        //self.scrollView.minimumZoomScale = 0.2;
        //self.scrollView.z
    }
}

/*
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView *subView = [scrollView.subviews objectAtIndex:0];

    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;

    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;

    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}*/

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

@end
