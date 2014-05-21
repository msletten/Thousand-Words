//
//  MSCoreDataHelper.m
//  Thousand Words
//
//  Created by Mat Sletten on 5/19/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import "MSCoreDataHelper.h"

@implementation MSCoreDataHelper

//We add some introspection to check if our app delegate implements the method managedObjectContext. If we moved this code to a different application, one that did not start with the Core Data template, chances are that the application would crash as our app delegate. Other then that we are accessing our NSManagedObjectContext instance from the App Delegate the same way. However, having this class method will save us from having to retype the code to access this property over and over.
+(NSManagedObjectContext *)managedObjectContext;

{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    
    if ([delegate performSelector:@selector(managedObjectContext)])
    {
        context = [delegate managedObjectContext];
    }
    
    return context;
}

@end
