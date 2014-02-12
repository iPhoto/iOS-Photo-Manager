//
//  Photo.h
//  Photo Manager
//
//  Created by Tony Song on 14-2-12.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Album;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSNumber * archived;
@property (nonatomic, retain) NSString * descriptionText;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) id location;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber * unClassified;
@property (nonatomic, retain) NSSet *albumsBelongsTo;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addAlbumsBelongsToObject:(Album *)value;
- (void)removeAlbumsBelongsToObject:(Album *)value;
- (void)addAlbumsBelongsTo:(NSSet *)values;
- (void)removeAlbumsBelongsTo:(NSSet *)values;

@end
