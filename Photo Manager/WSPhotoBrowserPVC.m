//
//  WSPhotoBrowserPVC.m
//  Photo Manager
//
//  Created by Tony Song on 14-2-15.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "WSPhotoBrowserPVC.h"

@implementation WSPhotoBrowserPVC

- (BOOL)prefersStatusBarHidden // Override
{
    return self.navigationController.navigationBarHidden;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:animated];
}

@end
