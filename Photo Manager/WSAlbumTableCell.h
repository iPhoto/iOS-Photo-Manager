//
//  WSAlbumTableCell.h
//  Photo Manager
//
//  Created by Song Xintong on 14-2-14.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WS_ALBUM_TABLE_CELL_HEIGHT 96.0 // height of cell defined in Main.storyboard

// UITableViewCell that presents an album or a group of photo.
@interface WSAlbumTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;

@property (strong, nonatomic) NSString *albumId; // ID of the album represented by this cell.
@property (strong, nonatomic) NSArray *photos; // Photos of the album represented by this cell.

@end
