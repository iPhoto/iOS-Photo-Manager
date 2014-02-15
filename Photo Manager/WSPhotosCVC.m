//
//  WSPhotosCVC.m
//  Photo Manager
//
//  Created by Tony Song on 14-2-14.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "WSPhotosCVC.h"
#import "WSPhotoCollectionCell.h"
#import "Photo+BasicOperations.h"
#import "WSImageViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface WSPhotosCVC () <UICollectionViewDataSource>

@property (nonatomic, strong)ALAssetsLibrary *library;

@end

@implementation WSPhotosCVC

- (ALAssetsLibrary *)library
{
    if (!_library) {
        _library = [[ALAssetsLibrary alloc] init];
    }
    return _library;
}

- (NSArray *)photos
{
    if (!_photos) {
        _photos = [[NSArray alloc] init];
    }
    return _photos;
}

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
	// Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WSPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"
                                                                            forIndexPath:indexPath];
    Photo *photo = [self.photos objectAtIndex:indexPath.row];
    [self.library assetForURL:[NSURL URLWithString:photo.id]
                  resultBlock:^(ALAsset *asset) {
                      cell.asset = asset;
                  }
                 failureBlock:^(NSError *error) {
                     NSLog(@"WSPhotosCVC.collectionView:cellForItemAtIndexPath:");
                     NSLog(@"Fetch asset failure error: %@", error);
                 }];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier compare:@"ShowPhoto"] == NSOrderedSame) {
        WSPhotoCollectionCell *cell = sender;
        WSImageViewController *destination = segue.destinationViewController;
        destination.image = [UIImage imageWithCGImage:cell.asset.defaultRepresentation.fullResolutionImage];
        //segue
    }
}

@end
