//
//  WSDescriptionView.m
//  Photo Manager
//
//  Created by Tony Song on 14-2-19.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "WSDescriptionView.h"

#define WS_DESCRIPTION_VIEW_MAX_HEIGHT 100
#define WS_DESCRIPTION_VIEW_IMAGE_WIDTH 20
#define WS_DESCRIPTION_VIEW_INSET 2

@interface WSDescriptionView () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIToolbar *blurBackgroundBar;
@property (nonatomic, strong) UIButton *editButton;

@end

@implementation WSDescriptionView

- (void)setTextViewDelegate:(id<UITextViewDelegate>)delegate
{
    self.textView.delegate = delegate;
}

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
        _textView.delegate = self;
        _textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _textView.textColor = [UIColor whiteColor];
        _textView.contentInset = UIEdgeInsetsZero;
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
    [self layoutSubviews];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];

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


    self.textView.frame =
    CGRectMake(viewBounds.origin.x, viewBounds.origin.y,
               viewBounds.size.width - WS_DESCRIPTION_VIEW_IMAGE_WIDTH -  2 * WS_DESCRIPTION_VIEW_INSET,
               viewBounds.size.height);


    CGFloat textHeight = [self.textView.text sizeWithFont:self.textView.font].height;
    /*[[NSString stringWithFormat:@"%@\n",self.textView.text]
                          boundingRectWithSize:CGSizeMake(self.textView.frame.size.width, CGFLOAT_MAX)
                          options:NSStringDrawingUsesLineFragmentOrigin //| NSStringDrawingUsesFontLeading
                          attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.textView.font,NSFontAttributeName, nil]
                          context:nil].size.height
        + self.textView.textContainerInset.top + self.textView.textContainerInset.bottom;
    if (self.textView.allowsEditingTextAttributes) {
        NSLog(@"allow");

    }
    NSLog(@"%@", NSStringFromUIEdgeInsets(self.textView.textContainerInset));*/
    if (textHeight < WS_DESCRIPTION_VIEW_IMAGE_WIDTH +  2 * WS_DESCRIPTION_VIEW_INSET) {
        textHeight = WS_DESCRIPTION_VIEW_IMAGE_WIDTH +  2 * WS_DESCRIPTION_VIEW_INSET;
    }
    if (textHeight > WS_DESCRIPTION_VIEW_MAX_HEIGHT) {
        textHeight = WS_DESCRIPTION_VIEW_MAX_HEIGHT;
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height - textHeight,
                            self.frame.size.width, textHeight);

    viewBounds = self.bounds;
    CGPoint origin = viewBounds.origin;
    CGSize viewSize = viewBounds.size;

    self.blurBackgroundBar.frame = viewBounds;
    self.textView.frame =
    CGRectMake(viewBounds.origin.x, viewBounds.origin.y,
               viewBounds.size.width - WS_DESCRIPTION_VIEW_IMAGE_WIDTH -  2 * WS_DESCRIPTION_VIEW_INSET,
               viewBounds.size.height);
    self.editButton.frame =
    CGRectMake(origin.x + viewSize.width - WS_DESCRIPTION_VIEW_IMAGE_WIDTH - WS_DESCRIPTION_VIEW_INSET,
               origin.y + (viewSize.height - WS_DESCRIPTION_VIEW_IMAGE_WIDTH) * 0.5,
               WS_DESCRIPTION_VIEW_IMAGE_WIDTH, WS_DESCRIPTION_VIEW_IMAGE_WIDTH);
}

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self layoutSubviews];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.textView.editable = NO;
    self.textView.selectable = NO;
    self.editButton.hidden = NO;
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
