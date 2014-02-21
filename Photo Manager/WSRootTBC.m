//
//  WSRootTBC.m
//  Photo Manager
//
//  Created by Song Xintong on 14-2-19.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "WSRootTBC.h"

@interface WSRootTBC () <UITabBarControllerDelegate>

@end

@implementation WSRootTBC

- (void)viewDidLoad // Override
{
    [super viewDidLoad];
    self.delegate = self;
	// Do any additional setup after loading the view.
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController // Override
shouldSelectViewController:(UIViewController *)viewController
{
    return ![tabBarController.selectedViewController isEqual:viewController];
}

@end
