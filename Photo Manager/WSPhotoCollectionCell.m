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

- (void)setAsset:(ALAsset *)asset
{
    _asset = asset;
    self.imageView.image = [UIImage imageWithCGImage:_asset.thumbnail];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
