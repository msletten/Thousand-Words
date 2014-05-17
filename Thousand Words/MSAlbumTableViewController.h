//
//  MSAlbumTableViewController.h
//  Thousand Words
//
//  Created by Mat Sletten on 5/16/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSAlbumTableViewController : UITableViewController 

@property (strong, nonatomic) NSMutableArray *photoAlbums;

- (IBAction)addAlbumBarButtonPressed:(UIBarButtonItem *)sender;


@end
