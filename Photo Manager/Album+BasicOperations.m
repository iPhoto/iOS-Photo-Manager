//
//  Album+BasicOperations.m
//  PhotoManager
//
//  Created by Song Xintong on 14-2-9.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "Album+BasicOperations.h"
#import "Photo.h"

@implementation Album (BasicOperations)

+ (Album *)albumWithTitle:(NSString *)title
           containsAlbums:(NSSet *)albums
           containsPhotos:(NSSet *)photos
          belongsToAlbums:(NSSet *)albumsBelongsTo
   inManagedObjectContext:(NSManagedObjectContext *)context
                conflicts:(NSSet *)conflicts
{
    conflicts = nil; // must init before check params

    // check params
    if (!title) {
        NSLog(@"Album.albumWithTitle:containsAlbums:containsPhotos:"
              @"belongsToAlbums:inManagedObjectContext:conflicts:");
        NSLog(@"Title is nil.");
        return nil;
    }
    
    if (!context) {
        NSLog(@"Album.albumWithTitle:containsAlbums:containsPhotos:"
              @"belongsToAlbums:inManagedObjectContext:conflicts:");
        NSLog(@"Context is nil.");
        return nil;
    }
    
    // check for circulations
    NSMutableSet *conflictsTmp = [[NSMutableSet alloc] init];
    for (Album *parent in albumsBelongsTo) {
        for (Album *child in albums) {
            if ([parent isChildOf:child] || parent.id == child.id) {
                NSDictionary *dictonary =
                    [NSDictionary dictionaryWithObjectsAndKeys:
                        @"Parent", parent, @"Child", child, nil];
                [conflictsTmp addObject:dictonary];
            }
        }
    }
    if ([conflictsTmp count]) { // circulations happend
        conflicts = conflictsTmp;
        return nil;
    }
    
    Album *album = nil; // to return

    // create album
    album = [NSEntityDescription insertNewObjectForEntityForName:@"Album"
                                          inManagedObjectContext:context];
    album.id = [NSString stringWithFormat:@"%f",
                [[NSDate date] timeIntervalSince1970]];
    album.title = title;
    [album addPhotos:photos];
    [album addAlbums:albums];
    [album addAlbumsBelongsTo:albumsBelongsTo];

    // set timeFrom & timeTo
    album.timeFrom = nil;
    album.timeTo = nil;

    for (Photo *childPhoto in photos) {
        if (childPhoto.time) {
            if (album.timeFrom) {
                album.timeFrom = [album.timeFrom earlierDate:childPhoto.time];
            } else {
                album.timeFrom = childPhoto.time;
            }
            if (album.timeTo) {
                album.timeTo = [album.timeTo laterDate:childPhoto.time];
            } else {
                album.timeTo = childPhoto.time;
            }
        }
    }
    
    for (Album *childAlbum in albums) {
        if (childAlbum.timeFrom) {
            if (album.timeFrom) {
                album.timeFrom = [album.timeFrom
                                  earlierDate:childAlbum.timeFrom];
            } else {
                album.timeFrom = childAlbum.timeFrom;
            }
        }
        if (childAlbum.timeTo) {
            if (album.timeTo) {
                album.timeTo = [album.timeTo laterDate:childAlbum.timeTo];
            } else {
                album.timeTo = childAlbum.timeTo;
            }
        }
    }

    // set timeFrom & timeTo for all parents
    for (Album *parentAlbum in [album allParentAlbums]) {
        if (album.timeFrom) {
            if (parentAlbum.timeFrom) {
                parentAlbum.timeFrom = [parentAlbum.timeFrom
                                        earlierDate:album.timeFrom];
            } else {
                parentAlbum.timeFrom = album.timeFrom;
            }
        }
        if (album.timeTo) {
            if (parentAlbum.timeTo) {
                parentAlbum.timeTo = [parentAlbum.timeTo
                                      laterDate:album.timeTo];
            } else {
                parentAlbum.timeTo = album.timeTo;
            }
        }
    }

#warning TODO: set location

    return album;
}

+ (Album *)allAlbumsAndPhotosInManagedObjectContext:(NSManagedObjectContext *)context
{
    // fecth all photos and albums
    NSFetchRequest *request;
    NSError *error;
    NSArray *albums;
    NSArray *photos;
    request = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
    albums = [context executeFetchRequest:request error:&error];
    if (!albums) {
        NSLog(@"Album.allAlbumsInManagedObjectContext:");
        NSLog(@"Fetch all albums error: %@", error);
    }
    request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    photos = [context executeFetchRequest:request error:&error];
    if (!photos) {
        NSLog(@"Album.allAlbumsInManagedObjectContext:");
        NSLog(@"Fetch all photos error: %@", error);
    }
    // create Album instance
    Album *album = [[Album alloc] init];
#warning TODO: remove magic words
    album.id = @"SPECIAL_ID_ALL";
    album.title = @"ALL";
    [album addAlbums:[[NSSet alloc] initWithArray:albums]];
    [album addPhotos:[[NSSet alloc] initWithArray:photos]];
    return album;
}

- (BOOL) isChildOf:(Album *)album
{
    if (![self.albumsBelongsTo count]) {
        return NO;
    } else {
        for (Album *parent in self.albumsBelongsTo) {
            if ([parent isChildOf:album]) {
                return YES;
            }
        }
        return NO;
    }
}

- (NSSet *)allParentAlbums
{
    NSMutableSet *parentAlbums = [[NSMutableSet alloc] init];
    for (Album *parentAlbum in self.albumsBelongsTo) {
        [parentAlbums
         addObjectsFromArray:[[parentAlbum allParentAlbums] allObjects]];
    }
    return parentAlbums;
}

@end
