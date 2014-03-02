//
//  WSPhotoBrowserPVC.m
//  Photo Manager
//
//  Created by Tony Song on 14-2-15.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "WSPhotoBrowserPVC.h"
#import "WSImageViewController.h"

@interface WSPhotoBrowserPVC()

@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UIViewController *parentAlbumsController;
@property (nonatomic, strong) UITapGestureRecognizer *tapNavigationBarRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapToolBarRecognizer;

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

- (UITapGestureRecognizer *)tapNavigationBarRecognizer
{
    if (!_tapNavigationBarRecognizer) {
        _tapNavigationBarRecognizer = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(navigationBarSingleTapped)];
        _tapNavigationBarRecognizer.numberOfTapsRequired = 1;
        _tapNavigationBarRecognizer.cancelsTouchesInView = NO;
    }
    return _tapNavigationBarRecognizer;
}

- (UITapGestureRecognizer *)tapToolBarRecognizer
{
    if (!_tapToolBarRecognizer) {
        _tapToolBarRecognizer = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(toolBarSingleTapped)];
        _tapToolBarRecognizer.numberOfTapsRequired = 1;
        _tapToolBarRecognizer.cancelsTouchesInView = NO;
    }
    return _tapToolBarRecognizer;
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
    
    // gestures
    [self.navigationController.navigationBar addGestureRecognizer:self.tapNavigationBarRecognizer];
    [self.navigationController.toolbar addGestureRecognizer:self.tapToolBarRecognizer];
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

#pragma mark - Parent albums view

- (void)titleClicked
{
    CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
    CGFloat navigationBarBottom = navigationBarFrame.origin.y + navigationBarFrame.size.height;
    
    WSImageViewController *currentPage = [[self viewControllers] lastObject];
    if (currentPage.keyboardOn) {
        [currentPage dismissKeyboard];
    }
    
    if (self.parentAlbumsShown) {
        // hide parent albums view controller
        [self hideParentAlbums];
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

- (void)hideParentAlbums // public
{
    [UIView animateWithDuration:0.2 animations:^{
        self.parentAlbumsController.view.frame = CGRectMake(0, self.parentAlbumsController.view.frame.origin.y,
                                                            self.view.bounds.size.width, 0);
    }];
    
    self.parentAlbumsShown = NO;
}

#pragma mark - Gestures

- (void)navigationBarSingleTapped
{
    WSImageViewController *currentPage = [[self viewControllers] lastObject];
    if (currentPage.keyboardOn) {
        [currentPage dismissKeyboard];
    }
    
    if (self.parentAlbumsShown) {
        [self hideParentAlbums];
    }
}

- (void)toolBarSingleTapped
{
    if (self.parentAlbumsShown) {
        [self hideParentAlbums];
    }
}

#pragma mark - Rotation

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
