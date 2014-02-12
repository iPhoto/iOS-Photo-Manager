//
//  Photo+BasicOperations.m
//  PhotoManager
//
//  Created by Song Xintong on 14-2-9.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "Photo+BasicOperations.h"

@implementation Photo (BasicOperations)

+ (Photo *)photoOfALAsset:(ALAsset *)asset
     inManagedObjectContext:(NSManagedObjectContext *)context
{
    // check params
    if (!asset) {
        NSLog(@"Photo.photoOfALAsset:inManagedObjectContext:");
        NSLog(@"Asset is nil.");
        return nil;
    }
    
    if ([asset valueForKey:ALAssetPropertyType] != ALAssetTypePhoto) {
        NSLog(@"Photo.photoOfALAsset:inManagedObjectContext:");
        NSLog(@"Asset type is not photo.");
        return nil;
    }
    
    if (!context) {
        NSLog(@"Photo.photoOfALAsset:inManagedObjectContext:");
        NSLog(@"Context is nil.");
        return nil;
    }
    
    Photo *photo = nil; // to return

    // fetch corresponding instance from Core Data
    NSString *assetURL = [[asset valueForKey:ALAssetPropertyAssetURL]
                          absoluteString];
    NSFetchRequest *request = [NSFetchRequest
                               fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@", assetURL];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];

    if (!matches || ([matches count] > 1)) { // error happened
        NSLog(@"Photo.photoOfALAsset:inManagedObjectContext:");
        NSLog(@"Matches: %ul FetchError: %@", [matches count], error);
    } else if (![matches count]) { // nothing match, create a new instance
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"
                                              inManagedObjectContext:context];
        photo.id = assetURL;
        photo.location = [asset valueForKey:ALAssetPropertyLocation];
        photo.time = [asset valueForKey:ALAssetPropertyDate];
    } else { // find corresponding instance in Core Data
        photo = [matches lastObject];
    }

    return photo;
}

@end
