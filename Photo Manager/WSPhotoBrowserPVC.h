//
//  WSPhotoBrowserPVC.h
//  Photo Manager
//
//  Created by Tony Song on 14-2-15.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WS_PHOTO_BROWSER_PVC_NAVIGATIONBAR_BOTTOM_LANDSCAPE 52
#define WS_PHOTO_BROWSER_PVC_NAVIGATIONBAR_BOTTOM_PORTRAIT 64

// UIPageViewController which contains multiple WSImageViewController and allow switch over between
// photos.
//
// I need this class only because I need to hide the status bar and tool bar when browse photo in
// full screen mode and it can only be done in this page view controller.
@interface WSPhotoBrowserPVC : UIPageViewController

@property (nonatomic) BOOL parentAlbumsShown; // if parent albums view is shown

// hide parent albums view controller
- (void)hideParentAlbums;

@end
