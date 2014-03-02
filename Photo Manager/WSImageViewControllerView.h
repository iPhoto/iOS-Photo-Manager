//
//  WSImageViewControllerView.h
//  Photo Manager
//
//  Created by Tony Song on 14-2-21.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WSImageViewController.h"

// Root view for WSImageViewController. I need to subclass WSImageViewController.view
// to override its layoutSubviews method, which keep the description view at right
// position.
@interface WSImageViewControllerView : UIView

@property (nonatomic) BOOL keyboardOn; // if keyboard is on
@property (nonatomic) CGRect keyboardFrame; // frame of keyboard in the WSImageViewControllerView's coordinate system
@property (nonatomic, strong) NSString *descriptionText; // text of description view
@property (nonatomic, strong) NSString *timeLocationText;
@property (nonatomic, strong) UIImage *image; // image of scroll view to display

// Custom initialization method. Need to keep reference of controller to get toolbar
// height for layouting. Return the initialized instance.
//
// |controller| is the WSImageViewController instance which use this
// WSImageViewControllerView instance as roo view.
- (id)initWithFrame:(CGRect)frame controller:(WSImageViewController *)controller;

// Set description view visibility.
//
// |hidden| indicates the visibility state should be set to description view. |animated|
// indicates should this change be animated.
- (void)setDescriptionViewHidden:(BOOL)hidden Animated:(BOOL)animated;

- (void)setTimeLocationViewHidden:(BOOL)hidden Animated:(BOOL)animated;

// Animate description view to the top of the keyboard. This should be called on keyboard
// showing.
//
// |keyboardFrame| is the frame the keyboard will shown to. |duration| and |options| are
// animation duration and options of keyboard showing.
- (void)animateDescriptionViewWithKeyboardFrame:(CGRect)keyboardFrame
                                       duration:(NSTimeInterval)duration
                                        options:(UIViewAnimationOptions)options;

// Animate description view back to the top of the tool bar. This should be called on
// keyboard didmissing.
//
// |duration| and |options| are animation duration and options of keyboard dismissing.
- (void)animateDescriptionViewBackWithDuration:(NSTimeInterval)duration
                                       options:(UIViewAnimationOptions)options;

// Notify description view to stop editing and dismiss keyboard.
- (void)dismissKeyboard;

// Reset image to fit the screen and orientation.
- (void)fitImageToView;

@end
