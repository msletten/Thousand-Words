//
//  MSFiltersCollectionViewController.m
//  Thousand Words
//
//  Created by Mat Sletten on 5/27/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import "MSFiltersCollectionViewController.h"
#import "MSPhotoCollectionViewCell.h"
#import "Photo.h"

@interface MSFiltersCollectionViewController ()

@property (strong, nonatomic) NSMutableArray *filters;

@end

@implementation MSFiltersCollectionViewController

- (NSMutableArray *)filters
{
    if (!_filters) _filters = [[NSMutableArray alloc] init];
    return _filters;
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

#pragma mark - UICollectionViewDataSource
//notice that I was able to import the photocollectionviewcell class here and reuse it for this new collection view. This is a perfect example of modular uses of classes in an application. 
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Cell";
    MSPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:218/255.0f green:165/255.0f blue:32/255.0f alpha:1/1.0f];
    cell.photoImageView.image = self.filteredPhoto.image;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.filters count];
}

@end
