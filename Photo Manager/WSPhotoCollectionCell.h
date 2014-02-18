//
//  WSPhotoCollectionCell.h
//  Photo Manager
//
//  Created by Song Xintong on 14-2-14.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

// UICollectionViewCell that presents a photo.
@interface WSPhotoCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *selectedView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedSymbolView;

@property (strong, nonatomic) ALAsset *asset; // of photo
@property (strong, nonatomic) NSIndexPath *indexpath; // position in parent collection view


@end
