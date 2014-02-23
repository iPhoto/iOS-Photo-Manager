//
//  WSPhotoBrowserPVC.m
//  Photo Manager
//
//  Created by Tony Song on 14-2-15.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "WSPhotoBrowserPVC.h"

#define WS_PHOTO_BROWSER_PVC_NAVIGATIONBAR_BOTTOM_LANDSCAPE 52
#define WS_PHOTO_BROWSER_PVC_NAVIGATIONBAR_BOTTOM_PORTRAIT 64

@interface WSPhotoBrowserPVC()

@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UIViewController *parentAlbumsController;
@property (nonatomic) BOOL parentAlbumsShown;

@end

@implementation WSPhotoBrowserPVC

#pragma mark - Access properties

- (UIButton *)titleButton
{
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_titleButton setTitle:@"相册⇳" forState:UIControlStateNormal];
        [_titleButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [_titleButton addTarget:self action:@selector(titleClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}

- (UIViewController *)parentAlbumsController
{
    if (!_parentAlbumsController) {
        _parentAlbumsController = [[UIViewController alloc] init];
        _parentAlbumsController.view.frame = CGRectZero;
        _parentAlbumsController.view.backgroundColor = [UIColor blueColor];
        _parentAlbumsController.view.autoresizingMask = UIViewAutoresizingNone;
    }
    return _parentAlbumsController;
}

#pragma mark - Lifecycle

- (void)viewDidLoad // Override
{
#warning Need to set actions for bar items
    // set navigation bar
    self.navigationItem.titleView = self.titleButton;
    
    // bottom tool bar
    UIBarButtonItem *actionItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                target:nil
                                                                                action:nil];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil];
    UIBarButtonItem *archiveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                                 target:nil
                                                                                 action:nil];
    [self setToolbarItems:@[actionItem, space, archiveItem] animated:NO];
    
    // prepare parent albums controller
    [self addChildViewController:self.parentAlbumsController ];
    [self.view addSubview:self.parentAlbumsController.view];
    [self.parentAlbumsController didMoveToParentViewController:self];
    self.parentAlbumsShown = NO;
}

- (void)viewWillDisappear:(BOOL)animated // Override
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)viewWillAppear:(BOOL)animated // Override
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:animated];
}

#pragma mark - Status bar

- (BOOL)prefersStatusBarHidden // Override
{
    return self.navigationController.navigationBarHidden;
}

#pragma mark -

- (void)titleClicked
{
    CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
    CGFloat navigationBarBottom = navigationBarFrame.origin.y + navigationBarFrame.size.height;
    
    if (self.parentAlbumsShown) {
        // hide parent albums view controller
        [UIView animateWithDuration:0.2 animations:^{
            self.parentAlbumsController.view.frame = CGRectMake(0, self.parentAlbumsController.view.frame.origin.y,
                                                                self.view.bounds.size.width, 0);
        }];
        
        self.parentAlbumsShown = NO;
    } else {
        // get parent albums information from current page
        
        // show parent albums view controller
        CGRect frame = CGRectMake(0, navigationBarBottom, self.view.bounds.size.width, 0);
        self.parentAlbumsController.view.frame = frame;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.parentAlbumsController.view.frame = CGRectMake(0, navigationBarBottom, self.view.bounds.size.width, 50);
        }];
        
        self.parentAlbumsShown = YES;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    if (self.parentAlbumsShown) {
#warning Using fixed numbers. This is because navigation bar bottom is not known before rotation.
        CGFloat navigationBarBottom = UIInterfaceOrientationIsLandscape(toInterfaceOrientation) ?
        WS_PHOTO_BROWSER_PVC_NAVIGATIONBAR_BOTTOM_LANDSCAPE : WS_PHOTO_BROWSER_PVC_NAVIGATIONBAR_BOTTOM_PORTRAIT;
        
        [UIView animateWithDuration:duration animations:^{
            self.parentAlbumsController.view.frame = CGRectMake(0, navigationBarBottom, self.view.bounds.size.height, 50);
        }];
        
    }
}

@end
