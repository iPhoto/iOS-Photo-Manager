//
//  WSImageViewControllerView.m
//  Photo Manager
//
//  Created by Tony Song on 14-2-21.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "WSImageViewControllerView.h"

#import "WSDescriptionView.h"
#import "WSPhotoScrollView.h"
#import "WSTimeLocationView.h"
#import "WSPhotoBrowserPVC.h"

#define WS_IMAGE_VIEW_CONTROLLER_TOOL_BAR_HEIGHT_LANDSCAPE 32
#define WS_IMAGE_VIEW_CONTROLLER_TOOL_BAR_HEIGHT_PORTRAIT 44

@interface WSImageViewControllerView ()

@property (nonatomic, strong) WSDescriptionView *descriptionView;
@property (nonatomic, strong) WSTimeLocationView *timeLocationView;
@property (nonatomic, strong) WSPhotoScrollView *scrollView;
@property (nonatomic, weak) WSImageViewController *controller; // should be weak to avoid circular reference

@property (strong, nonatomic) UITapGestureRecognizer *singleTapRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *doubleTapRecognizer;

@end

@implementation WSImageViewControllerView

#pragma mark - Access properties

- (NSString *)descriptionText
{
    return self.descriptionView.descriptionText;
}

- (void)setDescriptionText:(NSString *)descriptionText
{
    self.descriptionView.descriptionText = descriptionText;
}

- (UIImage *)image
{
    return self.scrollView.image;
}

- (void)setImage:(UIImage *)image
{
    self.scrollView.image = image;
}

- (WSDescriptionView *)descriptionView
{
    if (!_descriptionView) {
        _descriptionView = [[WSDescriptionView alloc] initWithFrame:self.bounds];
    }
    return _descriptionView;
}

- (WSTimeLocationView *)timeLocationView
{
    if (!_timeLocationView) {
        _timeLocationView = [[WSTimeLocationView alloc] initWithFrame:self.bounds];
    }
    return _timeLocationView;
}

- (WSPhotoScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[WSPhotoScrollView alloc] initWithFrame:self.bounds];
        [self insertSubview:_scrollView atIndex:0];
        [_scrollView addGestureRecognizer:self.singleTapRecognizer];
        [_scrollView addGestureRecognizer:self.doubleTapRecognizer];
    }
    return _scrollView;
}

- (UITapGestureRecognizer *)singleTapRecognizer
{
    if (!_singleTapRecognizer) {
        _singleTapRecognizer =[[UITapGestureRecognizer alloc]
                               initWithTarget:self.controller action:@selector(singleTapped)];
        _singleTapRecognizer.numberOfTapsRequired = 1;
        [_singleTapRecognizer requireGestureRecognizerToFail:self.doubleTapRecognizer];
    }
    return _singleTapRecognizer;
}

- (UITapGestureRecognizer *)doubleTapRecognizer
{
    if (!_doubleTapRecognizer) {
        _doubleTapRecognizer = [[UITapGestureRecognizer alloc]
                                initWithTarget:self action:@selector(doubleTapped:)];
        _doubleTapRecognizer.numberOfTapsRequired = 2;
    }
    return _doubleTapRecognizer;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_scrollView) {
        _scrollView.frame = frame;
    }
}

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame controller:(WSImageViewController *)controller // public
{
    self = [super initWithFrame:frame];
    if (self) {
        self.controller = controller;
        self.keyboardOn = NO;
        [self addSubview:self.descriptionView];
        [self addSubview:self.timeLocationView];
    }
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews // Override
{
    CGFloat descriptionViewHeight = self.descriptionView.bounds.size.height;
    CGSize viewSize = self.bounds.size;
    
    if (self.keyboardOn) {
        CGFloat keyboardTop = self.keyboardFrame.origin.y;
        self.descriptionView.frame = CGRectMake(0, keyboardTop - descriptionViewHeight,
                                            viewSize.width, descriptionViewHeight);
    } else {
#warning Using fixed numbers. This is because toobar height was not up-to-date sometimes.
        CGFloat toolbarHeight = UIInterfaceOrientationIsLandscape(self.controller.interfaceOrientation) ?
        WS_IMAGE_VIEW_CONTROLLER_TOOL_BAR_HEIGHT_LANDSCAPE : WS_IMAGE_VIEW_CONTROLLER_TOOL_BAR_HEIGHT_PORTRAIT;
        
        self.descriptionView.frame = CGRectMake(0, viewSize.height - toolbarHeight - descriptionViewHeight,
                                                viewSize.width, descriptionViewHeight);
    }
    
    CGFloat navigationBarBottom = UIInterfaceOrientationIsLandscape(self.controller.interfaceOrientation) ?
    WS_PHOTO_BROWSER_PVC_NAVIGATIONBAR_BOTTOM_LANDSCAPE : WS_PHOTO_BROWSER_PVC_NAVIGATIONBAR_BOTTOM_PORTRAIT;
    self.timeLocationView.frame = CGRectMake(0, navigationBarBottom, self.bounds.size.width, WS_TIME_LOCATION_VIEW_HEIGHT);

    self.scrollView.frame = self.bounds;
}

- (void)fitImageToView // public
{
    [self.scrollView updateZoomScale];
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale];
}

#pragma mark - Gesture recognization

- (void)doubleTapped:(UITapGestureRecognizer *)sender // tap twice, notify scroll view to zoom photo
{
    [self.scrollView doubleTapped:sender];
}

#pragma mark - Description view and Keyboard

- (void)setDescriptionViewHidden:(BOOL)hidden Animated:(BOOL)animated // public
{
    if (animated) {
        [UIView transitionWithView:self.descriptionView
                          duration:0.2
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.descriptionView.hidden = hidden;
                        }
                        completion:nil];
    } else {
        self.descriptionView.hidden = hidden;
    }
}

- (void)setTimeLocationViewHidden:(BOOL)hidden Animated:(BOOL)animated // public
{
    if (animated) {
        [UIView transitionWithView:self.timeLocationView
                          duration:0.2
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.timeLocationView.hidden = hidden;
                        }
                        completion:nil];
    } else {
        self.timeLocationView.hidden = hidden;
    }
}

- (void)animateDescriptionViewWithKeyboardFrame:(CGRect)keyboardFrame // public
                                       duration:(NSTimeInterval)duration
                                        options:(UIViewAnimationOptions)options
{
    CGRect originalFrame = self.descriptionView.frame;
    CGRect newFrame = CGRectMake(originalFrame.origin.x,
                                 keyboardFrame.origin.y - originalFrame.size.height,
                                 originalFrame.size.width,
                                 originalFrame.size.height);
    [UIView animateWithDuration:duration
                          delay:0
                        options:options
                     animations:^{
                         self.descriptionView.frame = newFrame;
                     }
                     completion:nil];
}

- (void)animateDescriptionViewBackWithDuration:(NSTimeInterval)duration // public
                                       options:(UIViewAnimationOptions)options;
{
    CGSize viewSize = self.bounds.size;
    CGFloat toolbarHeight = self.controller.navigationController.toolbar.frame.size.height;
    CGRect frame = CGRectMake(0,
                              viewSize.height - toolbarHeight - self.descriptionView.frame.size.height,
                              viewSize.width,
                              self.descriptionView.frame.size.height);
    [UIView animateWithDuration:duration
                          delay:0
                        options:options
                     animations:^{
                         self.descriptionView.frame = frame;
                     }
                     completion:nil];
}

- (void)dismissKeyboard // public
{
    [self.descriptionView dismissKeyboard];
}


@end
