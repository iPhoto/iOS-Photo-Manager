//
//  Photo+BasicOperations.m
//  PhotoManager
//
//  Created by Song Xintong on 14-2-9.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "Photo+BasicOperations.h"
#import <CoreLocation/CoreLocation.h>

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

    if ([asset valueForProperty:ALAssetPropertyType] != ALAssetTypePhoto) {
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
    NSString *assetURL = [[asset valueForProperty:ALAssetPropertyAssetURL]
                          absoluteString];
    NSFetchRequest *request = [NSFetchRequest
                               fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@", assetURL];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];

    if (!matches || ([matches count] > 1)) { // error happened
        NSLog(@"Photo.photoOfALAsset:inManagedObjectContext:");
        NSLog(@"Matches: %lu FetchError: %@", (unsigned long)[matches count], error);
    } else if (![matches count]) { // nothing match, create a new instance
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"
                                              inManagedObjectContext:context];
        photo.id = assetURL;
        photo.location = [asset valueForProperty:ALAssetPropertyLocation];
        photo.time = [asset valueForProperty:ALAssetPropertyDate];
    } else { // find corresponding instance in Core Data
        photo = [matches lastObject];
    }

    return photo;
}

+ (NSArray *)allPhotosInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest
                               fetchRequestWithEntityName:@"Photo"];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];

    if (!matches) { // error happened
        NSLog(@"Photo.allPhotosInManagedObjectContext:");
        NSLog(@"FetchError: %@", error);
    }

    return matches;
}

+ (NSArray *)unclassifiedPhotosInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest
                               fetchRequestWithEntityName:@"Photo"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"unClassified = YES"];
    request.predicate = predicate;
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];

    if (!matches) { // error happened
        NSLog(@"Photo.allPhotosInManagedObjectContext:");
        NSLog(@"FetchError: %@", error);
    }

    return matches;
}

+ (NSArray *)archivedPhotosInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest
                               fetchRequestWithEntityName:@"Photo"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"archived = YES"];
    request.predicate = predicate;
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];

    if (!matches) { // error happened
        NSLog(@"Photo.allPhotosInManagedObjectContext:");
        NSLog(@"FetchError: %@", error);
    }

    return matches;
}

- (NSString *)stringOfTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = kCFDateFormatterLongStyle;
    formatter.timeStyle = kCFDateFormatterNoStyle;
    formatter.locale = [NSLocale autoupdatingCurrentLocale];
    return [formatter stringFromDate:self.time];;
}

- (NSString *)stringOfLocation
{
    NSString *s = @"";
    CLLocation *location = self.location;
    if (location) {
        s = [NSString stringWithFormat:@"%f %f", location.coordinate.latitude, location.coordinate.longitude];
    }
    NSLog(@"%@", s);
    return s;
}

@end
