//
//  WSAlbumTableCell.m
//  Photo Manager
//
//  Created by Song Xintong on 14-2-14.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//


#import <AssetsLibrary/AssetsLibrary.h>

#import "WSAlbumTableCell.h"
#import "Photo+BasicOperations.h"
#import "DisplayString.h"


@implementation WSAlbumTableCell

#pragma mark - Access properties

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    // set UIs that are relied on photos
    self.detailLabel.text = [NSString stringWithFormat:DS_ALBUM_DESCRIPTION_FORMAT, [_photos count]];
    Photo * firstPhoto = [_photos firstObject];
    if (firstPhoto) {
        ALAssetsLibrary *libaray = [[ALAssetsLibrary alloc] init];
        [libaray assetForURL:[NSURL URLWithString:firstPhoto.id]
                 resultBlock:^(ALAsset *asset) {
                     self.thumbnailImageView.image = [UIImage imageWithCGImage:asset.thumbnail];
                 }
                failureBlock:^(NSError *error) {
                    NSLog(@"WSAlbumTableCell.setPhotos:");
                    NSLog(@"Fetch asset error: %@", error);
                }];
    }
}

@end
