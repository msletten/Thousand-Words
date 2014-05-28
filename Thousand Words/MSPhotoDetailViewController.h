//
//  MSPhotoDetailViewController.h
//  Thousand Words
//
//  Created by Mat Sletten on 5/27/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo;

@interface MSPhotoDetailViewController : UIViewController

@property (strong, nonatomic) Photo *photo;
@property (strong, nonatomic) IBOutlet UIImageView *photoDetailImageView;

- (IBAction)addFilterButtonPressed:(UIButton *)sender;
- (IBAction)deleteButtonPressed:(UIButton *)sender;
@end
