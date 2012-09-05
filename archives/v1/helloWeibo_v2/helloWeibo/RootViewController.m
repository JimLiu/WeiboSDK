//
//  RootViewController.m
//  helloWeibo
//
//  Created by junmin liu on 11-4-12.
//  Copyright 2011年 Openlab. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

- (void)viewDidLoad
{
    statuses = [[NSMutableArray alloc] init];
    cellReceivers = [[NSMutableDictionary alloc] init];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSURL *url = [NSURL URLWithString:@"http://api.t.sina.com.cn/statuses/public_timeline.json?source=1829189136&count=500"];
    ASIHTTPRequest *request = [[ASIHTTPRequest requestWithURL:url] retain];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)backgroundProcessData:(NSData *)responseData {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSObject *obj = [[CJSONDeserializer deserializer] deserialize:responseData
															error:nil];
    Status *lastStatus = nil;
    if (statuses.count > 0) {
        lastStatus = [statuses objectAtIndex:0];
    }
    ImageDownloader *imageDownloader = [ImageDownloader downloaderWithName:@"profileImages"];
    
    NSArray *arr = (NSArray *)obj;
    for (int i = arr.count - 1;i > -1;i--) {
        id item = [arr objectAtIndex:i];
        if (item && [item isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)item;
            Status *sts = [Status statusWithJsonDictionary:dic];   
            if (sts && sts.statusId > lastStatus.statusId) {
                [statuses addObject:sts];
                [imageDownloader queueImage:sts.user.profileImageUrl delegate:nil]; //load all images
            }
        }
    }
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [pool release];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    //NSLog(@"response data: %@", [request responseString]);
    NSLog(@"response data!");
    // Use when fetching binary data
    NSData *responseData = [request responseData];
    
    [self performSelectorInBackground:@selector(backgroundProcessData:) withObject:responseData];
    

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    //NSError *error = [request error];
}

- (void)startImageDownload:(Status *)sts forIndexPath:(NSIndexPath *)indexPath
{
    ImageDownloader *imageDownloader = [ImageDownloader downloaderWithName:@"profileImages"];
    TableCellDownloadReceiver *receiver = [[TableCellDownloadReceiver alloc] init];
    receiver.tableView = self.tableView;
    receiver.indexPath = indexPath;
    [cellReceivers setObject:receiver forKey:indexPath];
    [receiver release];
    [imageDownloader activeRequest:sts.user.profileImageUrl delegate:receiver];
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([statuses count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (int i = visiblePaths.count - 1; i >= 0 ; i--)
        {
            NSIndexPath *indexPath = [visiblePaths objectAtIndex:i];       
            Status *sts = [statuses objectAtIndex:indexPath.row];
            [self startImageDownload:sts forIndexPath:indexPath];            
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return statuses.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Status *sts = [statuses objectAtIndex:indexPath.row];
    CGSize size = [sts.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(240, 99999)];
    
    CGFloat height = size.height;
    if (height < 80) {
        height = 80;
    }
    
    return height;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Status *sts = [statuses objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = sts.text;
    cell.imageView.image = [UIImage imageNamed:@"profile_avatar_highlighted_frame.png"];
    
    [self startImageDownload:sts forIndexPath:indexPath];     
    // Configure the cell.
    
    return cell;
}

/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    Status *sts = [statuses objectAtIndex:indexPath.row];
    ImageDownloader *imageDownloader = [ImageDownloader downloaderWithName:@"profileImages"];
    TableCellDownloadReceiver *receiver = [[TableCellDownloadReceiver alloc] init];
    receiver.cell = cell;
    [cellReceivers setObject:receiver forKey:indexPath];
    [receiver release];
    [imageDownloader activeRequest:sts.user.profileImageUrl delegate:receiver];
    
    NSLog(@"indexPath:%d url:%@", indexPath.row, sts.user.profileImageUrl);
}
 */

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
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
	*/
}


#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [statuses release];
    [cellReceivers release];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [super dealloc];
}

@end
