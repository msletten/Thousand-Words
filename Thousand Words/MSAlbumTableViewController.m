//
//  MSAlbumTableViewController.m
//  Thousand Words
//
//  Created by Mat Sletten on 5/16/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import "MSAlbumTableViewController.h"
#import "Album.h"
#import "MSCoreDataHelper.h"
#import "MSPhotosCollectionViewController.h"
//conforming to the UIAlertViewDelegate 
@interface MSAlbumTableViewController () <UIAlertViewDelegate>

@end

@implementation MSAlbumTableViewController
//lazy instantiation
- (NSMutableArray *)photoAlbums
{
    if (!_photoAlbums) _photoAlbums = [[NSMutableArray alloc] init];
    return _photoAlbums;
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

//How do we get back the information stored in Core Data. First, we call our super classes viewWillAppear method so that any functionality declared in our superclass gets called. Next we create an NSFetchRequest object. This is used as search criteria for NSMangedObjects in our persistent store or database. We simply pass in the entity that we want to grab from our database. In this case the entity is Album, so it grabs any entity named Album. Notice that the fetch request takes one more parameter, a context or scratchpad used to find the objects. Remember that we get the context from our App Delegate. Remember that calling mutableCopy on an array, makes that NSArray into an NSMutableArray.
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    NSError *error = nil;
    NSArray *fetchedAlbums = [[MSCoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    self.photoAlbums = [fetchedAlbums mutableCopy];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)addAlbumBarButtonPressed:(UIBarButtonItem *)sender
{
    //Notice that we did set a delegate in the AlertView below to self so that the view recognizes which button is being pressed in the AlertView
    UIAlertView *newAlbumAlertView = [[UIAlertView alloc] initWithTitle:@"Enter New Album Name" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [newAlbumAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [newAlbumAlertView show];
}

#pragma mark - Helper Methods
//In this method we access our apps delegate and from that get our NSManagedObjectContext. Each NSManagedObject belongs to only one NSManagedObjectContext. Below that we create and album object and use the entities that we set up in the Album.h as properties of the NSManagedObject. This method saves the object to Core Data.
-(Album *)albumWtihName:(NSString *)albumName
{
    NSManagedObjectContext *context = [MSCoreDataHelper managedObjectContext];
    Album *album = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:context];
    album.name = albumName;
    album.date = [NSDate date];
    
    NSError *error = nil;
    if (![context save:&error])
    {
        //we have an error
        NSLog(@"%@", error);
    }
    return album;
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString *alertText = [alertView textFieldAtIndex:0].text;
        [self.photoAlbums addObject:[self albumWtihName:alertText]];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.photoAlbums count]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        //used literals above to replace the initilized Album method below to make a bit cleaner code.
        //Album *newAlbum = [self albumWtihName:alertText];
        //[self.photoAlbums addObject:newAlbum];
        //[self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.photoAlbums count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Album *selectedAlbum = self.photoAlbums[indexPath.row];
    cell.textLabel.text = selectedAlbum.name;
    return cell;
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


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Album Chosen"])
    {
        if ([segue.destinationViewController isKindOfClass:[MSPhotosCollectionViewController class]])
        {
            NSIndexPath *albumPath = [self.tableView indexPathForSelectedRow];
            MSPhotosCollectionViewController *targetViewController = segue.destinationViewController;
            targetViewController.album = self.photoAlbums[albumPath.row];
        }
    }
}

@end
