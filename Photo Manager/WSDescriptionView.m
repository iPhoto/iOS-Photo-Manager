//
//  WSDescriptionView.m
//  Photo Manager
//
//  Created by Tony Song on 14-2-19.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "WSDescriptionView.h"

#define WS_DESCRIPTION_VIEW_IMAGE_WIDTH 20
#define WS_DESCRIPTION_VIEW_INSET 2

@interface WSDescriptionView ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIToolbar *blurBackgroundBar;
@property (nonatomic, strong) UIButton *editButton;

@end

@implementation WSDescriptionView

- (UIButton *)editButton
{
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        _editButton.enabled = YES;
    }
    return _editButton;
}

- (UIToolbar *)blurBackgroundBar
{
    if (!_blurBackgroundBar) {
        _blurBackgroundBar = [[UIToolbar alloc] initWithFrame:self.bounds];
        [_blurBackgroundBar setAlpha:0.3];
    }
    return _blurBackgroundBar;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.editable = NO;
        _textView.selectable = NO;
        _textView.backgroundColor = nil;
    }
    return _textView;
}

- (NSString *)descriptionText
{
    return self.textView.text;
}

- (void)setDescriptionText:(NSString *)descriptionText
{
    self.textView.text = descriptionText;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer insertSublayer:[self.blurBackgroundBar layer] atIndex:0];
        [self addSubview:self.textView];
        [self addSubview:self.editButton];
        [self.editButton addTarget:self
                            action:@selector(editButtonClicked)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)editButtonClicked
{
    if (!self.textView.editable) {
        self.textView.editable = YES;
        if ([self.textView becomeFirstResponder]) {
            self.textView.editable = YES;
            self.textView.selectable = YES;
            self.editButton.hidden = YES;
        } else {
            self.textView.editable = NO;
        }
    }
}

- (void)layoutSubviews
{
    CGRect viewBounds = self.bounds;
    CGPoint original = viewBounds.origin;
    CGSize viewSize = viewBounds.size;
    self.blurBackgroundBar.frame = viewBounds;
    self.textView.frame =
    CGRectMake(viewBounds.origin.x, viewBounds.origin.y,
               viewBounds.size.width - WS_DESCRIPTION_VIEW_IMAGE_WIDTH -  2 * WS_DESCRIPTION_VIEW_INSET,
               viewBounds.size.height);
    self.editButton.frame =
    CGRectMake(original.x + viewSize.width - WS_DESCRIPTION_VIEW_IMAGE_WIDTH - WS_DESCRIPTION_VIEW_INSET,
               original.y + (viewSize.height - WS_DESCRIPTION_VIEW_IMAGE_WIDTH) * 0.5,
               WS_DESCRIPTION_VIEW_IMAGE_WIDTH, WS_DESCRIPTION_VIEW_IMAGE_WIDTH);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
