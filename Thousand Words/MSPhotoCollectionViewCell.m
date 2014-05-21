//
//  MSPhotoCollectionViewCell.m
//  Thousand Words
//
//  Created by Mat Sletten on 5/21/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import "MSPhotoCollectionViewCell.h"
#define IMAGEVIEW_BORDER_LENGTH 5

@implementation MSPhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //Initialization code
        [self setup];
    }
    return self;
}
//this is called by our storyboard. We initialize our superclass initWithCoder
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

//It is necessary to call the setup method from both initWithFrame and initWithCoder. This way, no matter whether our UICollectionView cell was alloc/inited or loaded from a storyboard, our setup code is called.What is our setup code? Well, it is alloc/initing our imageView and sizing it just a bit smaller than our cell. This will give our cells a nice white border. Don’t forget to navigate to the storyboard and update the UICollectViewCell’s class in the identity inspector. ContentView is the view where we can add additional items on; it's a property of CollectionViewCell.
-(void)setup
{
    self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, IMAGEVIEW_BORDER_LENGTH, IMAGEVIEW_BORDER_LENGTH)];
    [self.contentView addSubview:self.photoImageView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
