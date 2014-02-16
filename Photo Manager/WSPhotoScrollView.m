//
//  WSPhotoScrollView.m
//  Photo Manager
//
//  Created by Tony Song on 14-2-17.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "WSPhotoScrollView.h"

@implementation WSPhotoScrollView

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
    [self addSubview:self.imageView];
    self.contentSize = self.imageView.frame.size;
    
    CGSize imageSize = self.contentSize;
    CGSize viewSize = self.bounds.size;
    CGFloat minScaleX, minScaleY, maxScaleX, maxScaleY;
    if (imageSize.width > viewSize.width) {
        minScaleX = viewSize.width / imageSize.width;
        maxScaleX = 0.0;
    } else {
        minScaleX = 1.0;
        maxScaleX = viewSize.width / imageSize.width;
    }
    if (imageSize.height > viewSize.height) {
        minScaleY = viewSize.height / imageSize.height;
        maxScaleY = 0.0;
    } else {
        minScaleY = 1.0;
        maxScaleY = viewSize.height / imageSize.height;
    }
    
    self.minimumZoomScale = minScaleX > minScaleY ? minScaleY : minScaleX;
    self.maximumZoomScale = maxScaleX > maxScaleY ? maxScaleX : maxScaleY;
    if (self.maximumZoomScale < 3 * self.minimumZoomScale) {
        self.maximumZoomScale = 3 * self.minimumZoomScale;
    }
    
    [self setZoomScale:self.minimumZoomScale animated:NO];
    [self centerContent];
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)doubleTapped:(UITapGestureRecognizer *)tapGesture
{
    if (self.zoomScale == self.minimumZoomScale) {
        CGPoint touchPoint = [tapGesture locationInView:self.imageView];
        CGFloat scale = self.maximumZoomScale / self.minimumZoomScale;
        CGSize viewSize = self.bounds.size;
        CGFloat originX, originY;
        originX = touchPoint.x - viewSize.width * 0.5 / scale;
        originY = touchPoint.y - viewSize.height * 0.5 / scale;
        CGRect rect = CGRectMake(originX, originY, viewSize.width / scale,
                                 viewSize.height / scale);
        [self zoomToRect:rect animated:YES];
    }else {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)centerContent {
    CGFloat top = 0, left = 0;
    if (self.contentSize.width < self.bounds.size.width) {
        left = (self.bounds.size.width-self.contentSize.width) * 0.5f;
    }
    if (self.contentSize.height < self.bounds.size.height) {
        top = (self.bounds.size.height-self.contentSize.height) * 0.5f;
    }
    self.contentInset = UIEdgeInsetsMake(top, left, top, left);
}

- (void)scrollViewDidZoom:(__unused UIScrollView *)scrollView {
    [self centerContent];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self centerContent];
}

@end
