//
//  MSPhotosCollectionViewController.h
//  Thousand Words
//
//  Created by Mat Sletten on 5/21/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"

@interface MSPhotosCollectionViewController : UICollectionViewController

@property (strong, nonatomic) Album *album;

- (IBAction)cameraBarButtonPressed:(UIBarButtonItem *)sender;

@end
