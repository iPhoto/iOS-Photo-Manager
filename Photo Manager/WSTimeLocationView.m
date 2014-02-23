//
//  WSTimeLocationView.m
//  Photo Manager
//
//  Created by Tony Song on 14-2-23.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "WSTimeLocationView.h"

#define WS_TIME_LOCATION_VIEW_BLUR_BACKGROUND_ALPHA 0.3
#define WS_TIME_LOCATION_VIEW_BACKGROUND_COLOR_ALPHA 0.8

@interface WSTimeLocationView ()

@property (strong, nonatomic) UILabel *lable;
@property (nonatomic, strong) UIToolbar *blurBackgroundBar;

@end

@implementation WSTimeLocationView

#pragma mark - Access properties

- (NSString *)timeLocationText
{
    return self.lable.text;
}

- (void)setTimeLocationText:(NSString *)timeLocationText
{
    self.lable.text = timeLocationText;
}

- (UILabel *)lable
{
    if (!_lable) {
        _lable = [[UILabel alloc] init];
        
        _lable.backgroundColor = nil;
        
        _lable.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _lable.textColor = [UIColor whiteColor];
        
    }
    return _lable;
}

- (UIToolbar *)blurBackgroundBar
{
    if (!_blurBackgroundBar) {
        _blurBackgroundBar = [[UIToolbar alloc] initWithFrame:self.bounds];
        [_blurBackgroundBar setAlpha:WS_TIME_LOCATION_VIEW_BLUR_BACKGROUND_ALPHA];
    }
    return _blurBackgroundBar;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor]
                                colorWithAlphaComponent:WS_TIME_LOCATION_VIEW_BACKGROUND_COLOR_ALPHA];
        
        [self.layer insertSublayer:[self.blurBackgroundBar layer] atIndex:0];
    }
    return self;
}

- (void)layoutSubviews // Override
{
    self.blurBackgroundBar.frame = self.bounds;
    self.lable.frame = self.bounds;
}

@end
