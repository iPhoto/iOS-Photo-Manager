//
//  WSImageViewControllerView.m
//  Photo Manager
//
//  Created by Tony Song on 14-2-21.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "WSImageViewControllerView.h"

#import "WSDescriptionView.h"

@interface WSImageViewControllerView ()

@property (nonatomic, strong) WSDescriptionView *descriptionView;
@property (nonatomic, weak) WSImageViewController *controller; // should be weak to avoid circular reference

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

- (WSDescriptionView *)descriptionView
{
    if (!_descriptionView) {
        _descriptionView = [[WSDescriptionView alloc] initWithFrame:self.bounds];
    }
    return _descriptionView;
}

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame controller:(WSImageViewController *)controller // public
{
    self = [super initWithFrame:frame];
    if (self) {
        self.controller = controller;
        self.keyboardOn = NO;
        [self addSubview:self.descriptionView];
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
        CGFloat toolbarHeight = self.controller.navigationController.toolbar.frame.size.height;
        self.descriptionView.frame = CGRectMake(0, viewSize.height - toolbarHeight - descriptionViewHeight,
                                                viewSize.width, descriptionViewHeight);
    }
}

#pragma mark - Description view and Keyboard

- (void)setDescriptionViewHidden:(BOOL)hidden Animated:(BOOL)animated // public
{
    if (animated) {
        [UIView transitionWithView:self.descriptionView
                          duration:0.2
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            if (hidden) {
                                [self.descriptionView removeFromSuperview];
                            } else {
                                [self addSubview:self.descriptionView];
                            }
                        }
                        completion:nil];
    } else {
        if (hidden) {
            [self.descriptionView removeFromSuperview];
        } else {
            [self addSubview:self.descriptionView];
        }
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

- (void)animateDescriptionViewBackWithDuration:(NSTimeInterval)duration
                                       options:(UIViewAnimationOptions)options;
{
    CGSize viewSize = self.bounds.size;
    CGFloat toolbarHeight = self.controller.navigationController.toolbar.frame.size.height;
    CGRect frame = CGRectMake(0,
                              viewSize.height - toolbarHeight - 100,
                              viewSize.width,
                              100);
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
