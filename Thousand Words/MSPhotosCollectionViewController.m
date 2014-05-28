//
//  MSPhotosCollectionViewController.m
//  Thousand Words
//
//  Created by Mat Sletten on 5/21/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import "MSPhotosCollectionViewController.h"
#import "MSPhotoCollectionViewCell.h"
#import "Photo.h"
#import "MSPictureDataTransformer.h"
#import "MSCoreDataHelper.h"
#import "MSPhotoDetailViewController.h"

@interface MSPhotosCollectionViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
//UIImagePickerController inherets from UINavigationController

@property (strong, nonatomic) NSMutableArray *photos; //of UIImages

@end

@implementation MSPhotosCollectionViewController

- (NSMutableArray *)photos
{
    if (!_photos) _photos = [[NSMutableArray alloc] init];
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
    
}
//We need to query core data to get back all the photos for a specific album. The photos will be in an unordered NSSet, then we will order the photos in an array according to their date. The photo appears even though it has been deleted from core data. The discrepancy comes from where we are performing our fetchrequest in our TWPhotosCollectionViewController. We perform our fetch on viewDidLoad, but remember, our viewcontroller is always in memory when we push new view controllers on the stack! A more apt place would be viewWillAppear!
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSSet *unorderedPhotos = self.album.photos;
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    NSArray *sortedPhotos = [unorderedPhotos sortedArrayUsingDescriptors:@[dateDescriptor]];
    self.photos = [sortedPhotos mutableCopy];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailSegue"])
    {
        if ([segue.destinationViewController isKindOfClass:[MSPhotoDetailViewController class]])
        {
            MSPhotoDetailViewController *targetViewController = segue.destinationViewController;
            NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
            Photo *selectedPhoto = self.photos[indexPath.row];
            targetViewController.photo = selectedPhoto;
        }
    }
}

//First, we allocate and initialize an UIImagePickerController programmatically. Remember that the UIImagePickerController view object did not come from the storyboard! Next, we set the delegate property to self so that this ViewController will be able to receive messages from the UIImagePickerController delegate. After we check what type of image picker is available. If we are using a phone the camera will be available so we will select that. If we are testing on our simulator we will use the Photo Album to select our photo. The last line is how we present a ViewController modally. Modally means that it will take over the full screen.
- (IBAction)cameraBarButtonPressed:(UIBarButtonItem *)sender
{
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        photoPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    [self presentViewController:photoPicker animated:YES completion:nil];
}

#pragma mark - Helper Methods

- (Photo *)photoFromImage:(UIImage *)image
{
    Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[MSCoreDataHelper managedObjectContext]];
    photo.image = image;
    photo.date = [NSDate date];
    photo.albumBook = self.album;
    NSError *error = nil;
    if (![[photo managedObjectContext] save:&error])
    {
        //take care of the error
    }
    return photo;
}


#pragma mark - UICollectionViewDataSource
//Display the photos stored in the photo's array. The collection view delegate method is implemented to use our Photo model instead of raw images.
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Cell";
    MSPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    Photo *photo = self.photos[indexPath.row];
    cell.backgroundColor = [UIColor colorWithRed:102/255.0f green:205/255.0f blue:170/255.0f alpha:1/1.0f];
    cell.photoImageView.image = photo.image;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}

#pragma mark - UIImagePickerControllerDelegate
//That dictionary parameter named info contains not only images but also metadata. We can use the key UIImagePickerControllerEditedImage to get an edited image if we allow editing and the user takes advantage of this feature.

//So we call our new method to save the photo, add the new photo to an array, and reload our collection view so the photo is shown. Don't forget to dismiss the camera view controller at the end so we can move back to the collection view!
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickedImage = info[UIImagePickerControllerEditedImage];
    if (!pickedImage) pickedImage = info[UIImagePickerControllerOriginalImage];
    [self.photos addObject:[self photoFromImage:pickedImage]];
    [self.collectionView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"Cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
