//
//  MSPhotoDetailViewController.m
//  Thousand Words
//
//  Created by Mat Sletten on 5/27/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import "MSPhotoDetailViewController.h"
#import "Photo.h"
#import "MSFiltersCollectionViewController.h"

@interface MSPhotoDetailViewController ()

@end

@implementation MSPhotoDetailViewController

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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.photoDetailImageView.image = self.photo.image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//The add filter button on our detailed view controller is going to be used for filtering our image. Create the TWFiltersCollectionViewController and segue to it.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Filter Segue"])
    {
        if ([segue.destinationViewController isKindOfClass:[MSFiltersCollectionViewController class]])
        {
            MSFiltersCollectionViewController *targetViewController = segue.destinationViewController;
            targetViewController.filteredPhoto = self.photo;
        }
    }
}

- (IBAction)addFilterButtonPressed:(UIButton *)sender
{
    
}

//The UI is ready and your delete button should be connected to the deleteButtonPressed: method. That's where we'll add the code to delete the photo from core data.
- (IBAction)deleteButtonPressed:(UIButton *)sender
{
    [[self.photo managedObjectContext] deleteObject:self.photo];
    NSError *error = nil;
    [[self.photo managedObjectContext] save:&error];
    if (error)
    {
        NSLog(@"error");
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
