//
//  WSFinishLoadingDelegate.h
//  Photo Manager
//
//  Created by Tony Song on 14-2-15.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import <Foundation/Foundation.h>

// Delegate that receiving message of some loading process is finished.
@protocol WSFinishLoadingDelegate <NSObject>

@required
// Called by sender when loading process is finished
- (void)loadingFinished:(id)sender;

@end
