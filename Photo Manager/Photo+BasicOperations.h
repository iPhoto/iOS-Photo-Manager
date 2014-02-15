//
//  Photo+BasicOperations.h
//  PhotoManager
//
//  Created by Song Xintong on 14-2-9.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "Photo.h"
#import <AssetsLibrary/AssetsLibrary.h>

// Category of basic operations on the Photo class.
@interface Photo (BasicOperations)

// Returns a instance of Photo class binding with the instance of Photo entity
// which is corresponding to |asset|. Uses |context| to access the entity in
// Core Data.
//
// If there is no instance of Photo entity corresponding to |asset|, this method
// will create one with information of |asset| and return it.
//
// This method will do nothing and return nil either if |asset| or |context| is
// nil or if type of |asset| if not ALAssetTypePhoto or if some error happens
// during accessing Core Data.
+ (Photo *)photoOfALAsset:(ALAsset *)asset
   inManagedObjectContext:(NSManagedObjectContext *)context;

// Returns all photos' information in Core Data. Each photo's information is returned in a instance
// of Photo class binding with the instance of Photo entity in Core Data. Uses |context| to access
// Core Data.
//
// The results in the returning array is not guaranteed to be ordered.
+ (NSArray *)allPhotosInManagedObjectContext:(NSManagedObjectContext *)context;
@end
