//
//  WSAppDelegate.h
//  Photo Manager
//
//  Created by Tony Song on 14-2-12.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSFinishLoadingDelegate.h"

// This is delegate for the applicaiton.
@interface WSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, nonatomic) BOOL loadFinished; // indicator of whether photo loading finished

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

// Add a finish loading delegate |delegate| to the app delegate. |delegate| will be notified when
// photo loading is finished.
- (void)addFinishLoadingDelegate:(id<WSFinishLoadingDelegate>)delegate;

@end
