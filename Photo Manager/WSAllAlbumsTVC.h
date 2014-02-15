//
//  WSAllAlbumsTVC.h
//  Photo Manager
//
//  Created by Song Xintong on 14-2-12.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import <UIKit/UIKit.h>

// UITableViewController for the root table which contains all the albums when browsing photos.
//
// This is different from WSAlbumTVC because it also contains photo groups such as "All Photos",
// "Archieved Photos" and "Unclassified Photos" which contains no sub albums but photos.
@interface WSAllAlbumsTVC : UITableViewController

@end
