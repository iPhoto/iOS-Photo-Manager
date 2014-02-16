//
//  WSPhotoScrollView.h
//  Photo Manager
//
//  Created by Tony Song on 14-2-17.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSPhotoScrollView : UIScrollView <UIScrollViewDelegate>

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;

- (void)doubleTapped:(UITapGestureRecognizer *)tapGesture;

@end
