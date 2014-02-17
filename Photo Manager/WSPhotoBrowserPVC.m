//
//  WSPhotoBrowserPVC.m
//  Photo Manager
//
//  Created by Tony Song on 14-2-15.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "WSPhotoBrowserPVC.h"

@interface WSPhotoBrowserPVC ()

@end

@implementation WSPhotoBrowserPVC

- (BOOL)prefersStatusBarHidden
{
    return self.navigationController.navigationBarHidden;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbarHidden = NO;
    [super viewWillAppear:animated];
}

@end
