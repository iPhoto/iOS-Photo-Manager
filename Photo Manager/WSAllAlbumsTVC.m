//
//  WSAllAlbumsTVC.m
//  Photo Manager
//
//  Created by Song Xintong on 14-2-12.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//

#import "WSAllAlbumsTVC.h"
#import "WSAlbumPVC.h"
#import "WSAlbumTableCell.h"
#import "WSPhotosCVC.h"
#import "Photo+BasicOperations.h"
#import "WSAppDelegate.h"

@interface WSAllAlbumsTVC ()

@property (nonatomic, strong)NSManagedObjectContext *context;

@end

@implementation WSAllAlbumsTVC

- (NSManagedObjectContext *)context
{
    if (!_context) {
        _context = ((WSAppDelegate *)([UIApplication sharedApplication].delegate)).managedObjectContext;
    }
    return _context;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier;
    WSAlbumTableCell *cell;

    if (indexPath.row == 0) { // all photos
        cell = [tableView dequeueReusableCellWithIdentifier:@"PhotosOnlyCell"
                                               forIndexPath:indexPath];
        cell.titleLabel.text = @"所有照片";
        cell.detailLabel.text = @"描述文字";
        cell.thumbnailImageView.image = [UIImage imageNamed:@"photos"];
#warning magic words
        cell.albumId = @"ALL_PHOTOS";
        return cell;
    }

    if (indexPath.row % 2) {
        cellIdentifier = @"PhotosOnlyCell";
    } else {
        cellIdentifier = @"PhotosAndAlbumsCell";
    }

    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96.0;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier compare:@"ToPhotos"] == NSOrderedSame) {
        WSAlbumTableCell *cell = sender;
        WSPhotosCVC *destination = segue.destinationViewController;
        destination.title = cell.titleLabel.text;

        if ([cell.albumId compare:@"ALL_PHOTOS"] == NSOrderedSame) {
            destination.photos = [Photo allPhotosInManagedObjectContext:self.context];
        }
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
