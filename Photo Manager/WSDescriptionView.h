//
//  WSDescriptionView.h
//  Photo Manager
//
//  Created by Tony Song on 14-2-19.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import <UIKit/UIKit.h>

// View to display and edit description of a photo or album.
@interface WSDescriptionView : UIView

@property (nonatomic, strong) NSString *descriptionText; // description text to display

// Notify text view to stop editing and dismiss keyboard.
- (void)dismissKeyboard;
- (void)fitBoundsToTextLength;
@end
