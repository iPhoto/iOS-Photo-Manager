//
//  Album.h
//  Photo Manager
//
//  Created by Tony Song on 14-2-12.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Album, Photo;

@interface Album : NSManagedObject

@property (nonatomic, retain) NSNumber * archived;
@property (nonatomic, retain) NSString * descriptionText;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) id locations;
@property (nonatomic, retain) NSDate * timeFrom;
@property (nonatomic, retain) NSDate * timeTo;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *albums;
@property (nonatomic, retain) NSSet *albumsBelongsTo;
@property (nonatomic, retain) NSSet *photos;
@end

@interface Album (CoreDataGeneratedAccessors)

- (void)addAlbumsObject:(Album *)value;
- (void)removeAlbumsObject:(Album *)value;
- (void)addAlbums:(NSSet *)values;
- (void)removeAlbums:(NSSet *)values;

- (void)addAlbumsBelongsToObject:(Album *)value;
- (void)removeAlbumsBelongsToObject:(Album *)value;
- (void)addAlbumsBelongsTo:(NSSet *)values;
- (void)removeAlbumsBelongsTo:(NSSet *)values;

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
