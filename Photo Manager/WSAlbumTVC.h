//
//  WSAlbumTVC.h
//  PhotoManager
//
//  Created by Tony Song on 14-2-12.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album+BasicOperations.h"

@interface WSAlbumTVC : UITableViewController

@property (nonatomic, strong)NSManagedObjectContext *context;
@property (nonatomic, strong)Album *album;

@end
