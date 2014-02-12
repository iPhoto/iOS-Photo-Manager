//
//  WSAlbumPVC.m
//  Photo Manager
//
//  Created by Song Xintong on 14-2-12.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "WSAlbumPVC.h"

@interface WSAlbumPVC ()

@property (nonatomic) NSInteger index;
@property (nonatomic, strong) NSArray *controllers;

@end

@implementation WSAlbumPVC

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
    self.dataSource = self;
    [self setViewControllers:@[self.controllers[self.index]]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:nil];
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
        return self.controllers[self.index + 1];
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self.controllers indexOfObject:viewController];
    if (index > 0) {
        return self.controllers[self.index - 1];
    }
    return nil;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.controllers count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
