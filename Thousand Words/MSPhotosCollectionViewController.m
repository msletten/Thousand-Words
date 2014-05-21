//
//  MSPhotosCollectionViewController.m
//  Thousand Words
//
//  Created by Mat Sletten on 5/21/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import "MSPhotosCollectionViewController.h"
#import "MSPhotoCollectionViewCell.h"

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - UICollectionViewDataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Cell";
    MSPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:102/255.0f green:205/255.0f blue:170/255.0f alpha:1/1.0f];
    cell.photoImageView.image = self.photos[indexPath.row];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}

#pragma mark - UIImagePickerControllerDelegate
//That dictionary parameter named info contains not only images but also metadata. We can use the key UIImagePickerControllerEditedImage to get an edited image if we allow editing and the user takes advantage of this feature.
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickedImage = info[UIImagePickerControllerEditedImage];
    if (!pickedImage) pickedImage = info[UIImagePickerControllerOriginalImage];
    [self.photos addObject:pickedImage];
    [self.collectionView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"Cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
