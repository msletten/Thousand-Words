//
//  MSPictureDataTransformer.m
//  Thousand Words
//
//  Created by Mat Sletten on 5/21/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import "MSPictureDataTransformer.h"

@implementation MSPictureDataTransformer

//How do we store our images in our database? Well, we are using an NSValueTransformer subclass which is in charge of taking our UIImages and storing them as NSData. It will also be responsible for taking our data and transforming it back to Images. NSValueTransformer is an abstract class, meaning that it’s default implementation does nothing. It is up to us to subclass it and add its functionality. Abstract classes must be subclassed and we add fucntionality to make what we call “concrete” classes.

+(Class)transformedValueClass
{
    return [NSData class];
}

+(BOOL)allowsReverseTransformation
{
    return YES;
}

-(id)transformedValue:(id)value
{
    return UIImagePNGRepresentation(value);
}

-(id)reverseTransformedValue:(id)value
{
    UIImage *transformedImage = [UIImage imageWithData:value];
    return transformedImage;
}

@end
