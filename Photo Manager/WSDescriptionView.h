//
//  WSDescriptionView.h
//  Photo Manager
//
//  Created by Tony Song on 14-2-19.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSDescriptionView : UIView

@property (nonatomic, strong) NSString *descriptionText;

- (void)setTextViewDelegate:(id<UITextViewDelegate>)delegate;
- (void)dismissKeyboard;

@end
