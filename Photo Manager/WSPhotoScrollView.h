//
//  WSPhotoScrollView.h
//  Photo Manager
//
//  Created by Tony Song on 14-2-17.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import <UIKit/UIKit.h>

// Scroll view used to display a photo. This scroll view will keep image's size, position,
// orientation and scale range right under zooming, dragging, device rotation and page switches.
@interface WSPhotoScrollView : UIScrollView <UIScrollViewDelegate>

@property (strong, nonatomic) UIImage *image; // displayed image
@property (strong, nonatomic) UIImageView *imageView; // displayed image view

- (void)updateZoomScale; // reset zoom scale range with current image size and device orientation
- (void)updateOrientation:(UIInterfaceOrientation)orientation; // reset frame size to fit current
                                                                // orientation

- (void)doubleTapped:(UITapGestureRecognizer *)tapGesture; // zoom image when user double tapped

@end
