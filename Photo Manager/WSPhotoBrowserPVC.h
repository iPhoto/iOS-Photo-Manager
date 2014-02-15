//
//  WSPhotoBrowserPVC.h
//  Photo Manager
//
//  Created by Tony Song on 14-2-15.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import <UIKit/UIKit.h>

// UIPageViewController which contains multiple WSImageViewController and allow switch over between
// photos.
//
// I need this class only because I need to hide the status bar when browse photo in full screen
// mode and it can only be done in this page view controller.
@interface WSPhotoBrowserPVC : UIPageViewController

@end
