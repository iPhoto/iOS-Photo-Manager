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

// Reset zoom scale range with current image size and orientation.
- (void)updateZoomScale;

// Zoom image in or out when user double tapped
- (void)doubleTapped:(UITapGestureRecognizer *)tapGesture;

@end
