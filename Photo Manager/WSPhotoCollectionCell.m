//
//  WSPhotoCollectionCell.m
//  Photo Manager
//
//  Created by Song Xintong on 14-2-14.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "WSPhotoCollectionCell.h"

@interface WSPhotoCollectionCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation WSPhotoCollectionCell

#pragma mark - Access properties

- (void)setAsset:(ALAsset *)asset
{
    _asset = asset;
    // set image to thumbnail of asset
    self.imageView.image = [UIImage imageWithCGImage:_asset.thumbnail];
}

@end
