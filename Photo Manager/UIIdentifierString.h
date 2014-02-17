//
//  UIIdentifierString.h
//  Photo Manager
//
//  Created by Tony Song on 14-2-15.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//
// This file defines all strings that are used as identifiers in the storyboard.

#ifndef Photo_Manager_UIIdentifierString_h
#define Photo_Manager_UIIdentifierString_h

#pragma mark - Storyboard

#define IS_STORYBOARD_NAME @"Main"

#pragma mark - View Controllers

#define IS_ROOT_CONTROLLER @"RootController"
#define IS_PHOTO_BROWSER @"PhotoBrowser"
#define IS_NO_PHOTO @"NoPhotos"

#pragma mark - Table View Cells

#define IS_PHOTOS_ONLY_CELL @"PhotosOnlyCell"
#define IS_PHOTOS_AND_ALBUMS_CELL @"PhotosAndAlbumsCell"

#pragma mark - Collection View Cells

#define IS_PHOTO_CELL @"PhotoCell"

#pragma mark - Segues

#define IS_SEGUE_TO_PHOTOS @"ToPhotos"
#define IS_SEGUE_SHOW_PHOTO @"ShowPhoto"

#endif
