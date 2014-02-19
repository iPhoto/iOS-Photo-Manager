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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController
shouldSelectViewController:(UIViewController *)viewController
{
    return ![tabBarController.selectedViewController isEqual:viewController];
}

@end
