//
//  WSAllAlbumsTVC.m
//  Photo Manager
//
//  Created by Song Xintong on 14-2-12.
//  Copyright (c) 2014年 WeeSteps. All rights reserved.
//


#import "WSAllAlbumsTVC.h"

#import "Photo+BasicOperations.h"
#import "Album+BasicOperations.h"

#import "WSAppDelegate.h"
#import "WSFinishLoadingDelegate.h"

#import "WSAlbumTableCell.h"
#import "WSPhotosCVC.h"
#import "WSAlbumPVC.h"

#import "DisplayString.h"
#import "UIIdentifierString.h"

@interface WSAllAlbumsTVC () <WSFinishLoadingDelegate>

@property (nonatomic, strong) NSManagedObjectContext *context; // to access Core Data.

@end

@implementation WSAllAlbumsTVC

#pragma mark - Access properties

- (NSManagedObjectContext *)context
{
    if (!_context) {
        WSAppDelegate *delegate = [UIApplication sharedApplication].delegate;
        _context = delegate.managedObjectContext;
    }
    return _context;
}

#pragma mark - Lifecycle

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
    
    // Listenning for WSAppDelegate to finish importing photos
    WSAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (!delegate.loadFinished) {
        [delegate addFinishLoadingDelegate:self];
    }
    
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

#pragma mark - Finish loading delegate

- (void)loadingFinished:(id)sender
{
    [self.tableView reloadData];
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

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier;
    WSAlbumTableCell *cell;

    if (indexPath.row == 0) { // all photos
        cell = [tableView dequeueReusableCellWithIdentifier:IS_PHOTOS_ONLY_CELL
                                               forIndexPath:indexPath];
        cell.albumId = ALBUM_ID_ALL_PHOTOS;
        cell.titleLabel.text = DS_ALL_PHOTOS;
        cell.photos = [Photo allPhotosInManagedObjectContext:self.context];
    } else {
#warning Incomplete for other cells.
        if (indexPath.row % 2) {
            cellIdentifier = IS_PHOTOS_AND_ALBUMS_CELL;
        } else {
            cellIdentifier = IS_PHOTOS_ONLY_CELL;
        }
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        // Configure the cell...
        
    }
    return cell;
}

// This is optional for table view data source, but required for this app to use WSAlbumTableCell.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WS_ALBUM_TABLE_CELL_HEIGHT;
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier compare:IS_SEGUE_TO_PHOTOS] == NSOrderedSame) {
        WSAlbumTableCell *cell = sender;
        WSPhotosCVC *destination = segue.destinationViewController;
        destination.title = cell.titleLabel.text;
        destination.photos = cell.photos;
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
