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
@property (strong, nonatomic) CIContext *context;

@end

@implementation MSFiltersCollectionViewController

- (NSMutableArray *)filters
{
    if (!_filters) _filters = [[NSMutableArray alloc] init];
    return _filters;
}

- (CIContext *)context
{
    if (!_context) _context = [CIContext contextWithOptions:nil];
    return _context;
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
    self.filters = [[[self class] photoFilters] mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers
//photo filters predefined by apple, taking a string with the exact name of the filter along with NSDictionary keys and values determined by the parameters available for that specific filter and which are defined by apple. Notice the CIFilter class method (that returns a CIFilter) takes a string corresponding to the exact name of the filter as well as a dictionary with some attributes about the filters, such as intensity. There is one more value, the input image, that is required for all filters but because that is necessary for all, we will set that later.
+(NSArray *)photoFilters
{
    CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: nil];
    CIFilter *blur = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputRadiusKey, @1, nil];
    CIFilter *colorClamp = [CIFilter filterWithName:@"CIColorClamp" keysAndValues:@"inputMaxComponents", [CIVector vectorWithX:0.9 Y:0.9 Z:0.9 W:0.9], @"inputMinComponents", [CIVector vectorWithX:0.2 Y:0.2 Z:0.2 W:0.2], nil];
    CIFilter *instant = [CIFilter filterWithName:@"CIPhotoEffectInstant" keysAndValues: nil];
    CIFilter *noir = [CIFilter filterWithName:@"CIPhotoEffectNoir" keysAndValues: nil];
    CIFilter *vignette = [CIFilter filterWithName:@"CIVignetteEffect" keysAndValues: nil];
    CIFilter *colorControls = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputSaturationKey, @0.5, nil];
    CIFilter *transfer = [CIFilter filterWithName:@"CIPhotoEffectTransfer" keysAndValues: nil];
    CIFilter *unsharpen = [CIFilter filterWithName:@"CIUnsharpMask" keysAndValues: nil];
    CIFilter *monochrome = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues: nil];
    CIFilter *toneCurveLinear = [CIFilter filterWithName:@"CISRGBToneCurveToLinear" keysAndValues: nil];
    NSArray *allFilters = @[sepia, blur, colorClamp, instant, noir, vignette, colorControls, transfer, unsharpen, monochrome, toneCurveLinear];
    return allFilters;
}
//Remember that this context is responsible for rendering our CIImage, and allows us to create a CGImage from it. And the method does all the work.
- (UIImage *)filteredImageFromImage:(UIImage *)image andFilter:(CIFilter *)filter
{
    CIImage *unfilteredImage = [[CIImage alloc] initWithCGImage:image.CGImage];
    [filter setValue:unfilteredImage forKey:kCIInputImageKey];
    CIImage *filteredImage = [filter outputImage];
    CGRect extent = [filteredImage extent];
    CGImageRef cgImage = [self.context createCGImage:filteredImage fromRect:extent];
    UIImage *finalImage = [UIImage imageWithCGImage:cgImage];
    return finalImage;
}

#pragma mark - UICollectionView DataSource
//notice that I was able to import the photocollectionviewcell class here and reuse it for this new collection view. This is a perfect example of modular uses of classes in an application. 
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Cell";
    MSPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:218/255.0f green:165/255.0f blue:32/255.0f alpha:1/1.0f];
    //In our example, we are running all of our filter logic on another thread and then updating our imageview on the main thread. This allows the viewController to display much faster than if we were to perform all the logic on the filters before allowing the view controller to display. In this case the method filteredImageFromImageandFilters are pushed to another thread while the main thread handles the UI.
    dispatch_queue_t filterQueue = dispatch_queue_create("filter queue", NULL);
    dispatch_async(filterQueue, ^{
        UIImage *filterImage = [self filteredImageFromImage:self.filteredPhoto.image andFilter:self.filters[indexPath.row]];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.photoImageView.image = filterImage;
        });
    });
    //We replaced below with the above. Below all the filter processes had to complete before loading the view controller. Above, we set up a grand central dispatch to do the work asynchronously.
    //cell.photoImageView.image = [self filteredImageFromImage:self.filteredPhoto.image andFilter:self.filters[indexPath.row]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.filters count];
}

#pragma mark - UICollectionViewDelegate
//Now we want to save the new filtered image and dismiss the filter view controller.
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSPhotoCollectionViewCell *selectedCell = (MSPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.filteredPhoto.image = selectedCell.photoImageView.image;
    if (self.filteredPhoto.image)
    {
        NSError *error = nil;
        if (![[self.filteredPhoto managedObjectContext] save:&error])
        {
            //handle error
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
