//
//  WSAlbumPVC.m
//  Photo Manager
//
//  Created by Song Xintong on 14-2-12.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "WSAlbumPVC.h"

@interface WSAlbumPVC ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pvc;
@property (nonatomic, strong) NSArray *controllers;

@end

@implementation WSAlbumPVC

- (UIPageViewController *)pvc
{
    if (!_pvc) {
        _pvc = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                             options:nil];
    }
    return _pvc;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[storyboard instantiateViewControllerWithIdentifier:@"Photos"]];
    [array addObject:[storyboard instantiateViewControllerWithIdentifier:@"Albums"]];
    self.controllers = array;
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = [self.controllers count];
    
    self.pvc.delegate = self;
    self.pvc.dataSource = self;
    
    [self.pvc setViewControllers:@[self.controllers[self.pageControl.currentPage]]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:nil];
    [self addChildViewController:self.pvc];
    [self.view insertSubview: self.pvc.view belowSubview:self.pageControl];
    
    self.pvc.view.frame = CGRectMake(0.0, 0.0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    [self.pvc didMoveToParentViewController:self];
    self.view.gestureRecognizers = self.pvc.gestureRecognizers;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{

    NSInteger index = [self.controllers indexOfObject:viewController];
    if (index < [self.controllers count] - 1) {
        return self.controllers[index + 1];
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self.controllers indexOfObject:viewController];
    if (index > 0) {
        return self.controllers[index - 1];
    }
    return nil;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.controllers count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    //pageViewController
    return self.pageControl.currentPage;
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    if (!completed) {
        return;
    }
    self.pageControl.currentPage = [self.controllers indexOfObject:[self.pvc.viewControllers lastObject]];
}

@end
