//
//  WSPhotosCVC.h
//  Photo Manager
//
//  Created by Tony Song on 14-2-14.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import <UIKit/UIKit.h>

// UICollectionViewController that presents photos for an album or a group of photo.
//
// This class is also data source and delegate of a page view controller that contains all image
// browser views of photos. This will allow user to switch between photos directly in browser.
@interface WSPhotosCVC : UICollectionViewController

@property (nonatomic, strong) NSArray *photos; // of Photo

@end
