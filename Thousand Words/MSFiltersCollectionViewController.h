//
//  MSFiltersCollectionViewController.h
//  Thousand Words
//
//  Created by Mat Sletten on 5/27/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo;

@interface MSFiltersCollectionViewController : UICollectionViewController

@property (strong, nonatomic) Photo *filteredPhoto;

@end
