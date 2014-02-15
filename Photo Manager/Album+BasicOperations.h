//
//  Album+BasicOperations.h
//  PhotoManager
//
//  Created by Song Xintong on 14-2-9.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "Album.h"

#define ALBUM_ID_ALL_PHOTOS @"ALL_PHOTOS"

// Category of basic operations on the Album class.
@interface Album (BasicOperations)

// Creates a new instance of Album entity in Core Data and returns the instance
// of Album class binding with the created instance in Core Data.
//
// The title of the new album is defined by |title|. |albums| and |photos| are
// sets of albums and photos inside the new album, while |albumsBelongsTo| are
// sets of albums the new album belongs to. |albums|, |photos| and
// |albumsBelonsTo| should be guaranteed to contains only instance of Album,
// Photo and Album class.
//
// If one album A from |albumsBelongsTo| is equal to or a direct/indirect child
// of another album B from |albums|, then creating a new album in A having B
// inside it will introuce a circulation. Such A and B are defined as a pair of
// conflict albums, where A is called Parent while B is called "Child".
//
// If there is any pair of conflict albums, the new album will not be created.
// This method will set |conflicts| to a set of all pairs of conflict albums,
// each pair is a NSDictionary with @"Parent" and @"Child" mapping to Parent
// and Child of the conflict. Then the method will return nil.
//
// If there is no conflict albums, |conflicts| is set to nil.
//
// This method uses |context| to access the entity in Core Data.
//
// This method will do nothing and return nil if either |title| or |context| is
// nil.
+ (Album *)albumWithTitle:(NSString *)title
           containsAlbums:(NSSet *)albums
           containsPhotos:(NSSet *)photos
          belongsToAlbums:(NSSet *)albumsBelongsTo
   inManagedObjectContext:(NSManagedObjectContext *)context
                conflicts:(NSSet *)conflicts;

// Returns YES if this album is a direct/indirect child of |album|. Otherwise
// returns NO.
- (BOOL)isChildOf:(Album *)album;

// Returns all direct/indirect parent albums.
- (NSSet *)allParentAlbums;

@end
