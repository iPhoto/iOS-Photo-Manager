//
//  WSDescriptionView.m
//  Photo Manager
//
//  Created by Tony Song on 14-2-19.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "WSDescriptionView.h"

#import "DisplayString.h"

#define WS_DESCRIPTION_VIEW_MAX_HEIGHT 100
#define WS_DESCRIPTION_VIEW_IMAGE_SIDE_LENGTH 20
#define WS_DESCRIPTION_VIEW_BLUR_BACKGROUND_ALPHA 0.3
#define WS_DESCRIPTION_VIEW_BACKGROUND_COLOR_ALPHA 0.8

@interface WSDescriptionView () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextView *hintView;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIToolbar *blurBackgroundBar;

@end

@implementation WSDescriptionView

#pragma mark - Access properties

- (NSString *)descriptionText
{
    return self.textView.text;
}

- (void)setDescriptionText:(NSString *)descriptionText
{
    self.textView.text = descriptionText;
    self.hintView.hidden = descriptionText.length ? YES : NO;
    [self layoutIfNeeded];
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        
        _textView.backgroundColor = nil;
        
        _textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _textView.textColor = [UIColor whiteColor];
        
        _textView.editable = NO;
        _textView.selectable = NO;
        
        _textView.delegate = self;
        
        
    }
    return _textView;
}

- (UITextView *)hintView
{
    if (!_hintView) {
        _hintView = [[UITextView alloc] init];
        
        _hintView.backgroundColor = nil;
        
        _hintView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _hintView.textColor = [UIColor lightGrayColor];
        _hintView.text = DS_NO_DESCRIPTION;
        
        _hintView.editable = NO;
        _hintView.selectable = NO;
    }
    return _hintView;
}

- (UIButton *)editButton
{
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    }
    return _editButton;
}

- (UIToolbar *)blurBackgroundBar
{
    if (!_blurBackgroundBar) {
        _blurBackgroundBar = [[UIToolbar alloc] initWithFrame:self.bounds];
        [_blurBackgroundBar setAlpha:WS_DESCRIPTION_VIEW_BLUR_BACKGROUND_ALPHA];
    }
    return _blurBackgroundBar;
}

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame // Override
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor]
                                colorWithAlphaComponent:WS_DESCRIPTION_VIEW_BACKGROUND_COLOR_ALPHA];

        [self.layer insertSublayer:[self.blurBackgroundBar layer] atIndex:0];
        [self addSubview:self.textView];
        [self addSubview:self.editButton];
        [self addSubview:self.hintView];
        
        [self.editButton addTarget:self
                            action:@selector(editButtonClicked)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - Layout

- (void)fitBoundsToTextLength
{
    CGRect origViewBounds = self.bounds;
    
    // get text view's width
    CGFloat textViewWidth = origViewBounds.size.width - WS_DESCRIPTION_VIEW_IMAGE_SIDE_LENGTH;
    
    // get full text's height with constraint of text view width
#warning The result text height is sometimes not right. Seems I didn't get text view's width or font right.
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.textView.font,NSFontAttributeName, nil];
    CGFloat fullTextHeight = [self.textView.text boundingRectWithSize:CGSizeMake(textViewWidth, CGFLOAT_MAX)
                                                              options:options
                                                           attributes:attributes
                                                              context:nil].size.height;
    
    // get the description view's new height
    UIEdgeInsets textContainerInset = self.textView.textContainerInset;
    CGFloat newViewHeight = fullTextHeight + textContainerInset.top + textContainerInset.bottom;
    if (newViewHeight < WS_DESCRIPTION_VIEW_IMAGE_SIDE_LENGTH) {
        newViewHeight = WS_DESCRIPTION_VIEW_IMAGE_SIDE_LENGTH;
    }
    if (newViewHeight > WS_DESCRIPTION_VIEW_MAX_HEIGHT) {
        newViewHeight = WS_DESCRIPTION_VIEW_MAX_HEIGHT;
    }
    
    // reset the description view's bounds size if needed
    if (self.bounds.size.height != newViewHeight) {
        self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, newViewHeight);
    }
}

- (void)layoutSubviews // Override
{
    // fit the description view's bounds size to text length
    [self fitBoundsToTextLength];
    
    // layout subviews
    CGRect newViewBounds = self.bounds;
    self.blurBackgroundBar.frame = newViewBounds;
    self.textView.frame = CGRectMake(newViewBounds.origin.x,
                                     newViewBounds.origin.y,
                                     newViewBounds.size.width - WS_DESCRIPTION_VIEW_IMAGE_SIDE_LENGTH,
                                     newViewBounds.size.height);
    self.editButton.frame = CGRectMake(newViewBounds.origin.x + newViewBounds.size.width - WS_DESCRIPTION_VIEW_IMAGE_SIDE_LENGTH,
                                       newViewBounds.origin.y + (newViewBounds.size.height - WS_DESCRIPTION_VIEW_IMAGE_SIDE_LENGTH) * 0.5,
                                       WS_DESCRIPTION_VIEW_IMAGE_SIDE_LENGTH,
                                       WS_DESCRIPTION_VIEW_IMAGE_SIDE_LENGTH);
    self.hintView.frame = self.textView.frame;
}

#pragma mark - Editing and keyboard

- (void)editButtonClicked
{
    self.textView.editable = YES; // to show keyboard, text view need to be editble
    if ([self.textView becomeFirstResponder]) {
        self.textView.editable = YES;
        self.textView.selectable = YES;
        self.editButton.hidden = YES;
        self.hintView.hidden = YES;
    } else {
        self.textView.editable = NO;
    }
}

- (void)dismissKeyboard // public
{
    [self.textView resignFirstResponder];
}

#pragma mark - Text view delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self fitBoundsToTextLength];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.textView.editable = NO;
    self.textView.selectable = NO;
    self.editButton.hidden = NO;
    self.hintView.hidden = self.descriptionText.length ? YES : NO;
}

@end
