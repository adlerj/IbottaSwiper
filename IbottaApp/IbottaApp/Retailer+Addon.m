//
//  Retailer+Addon.m
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import "Retailer+Addon.h"

@implementation Retailer (Addon)

+ (Retailer*)createOrUpdateRetailerWithID:(NSString*)ID
                              active:(NSNumber*)active
                                name:(NSString*)name
                             iconURL:(NSString*)iconURL
                            imageURL:(NSString*)imageURL
{
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    
    Retailer *retailer = [Retailer fetchRetailerForID:ID];
    if (!retailer) {
        retailer = [NSEntityDescription insertNewObjectForEntityForName:@"Retailer" inManagedObjectContext:context];
    }
    
    retailer.retailerID = ID;
    retailer.active = active;
    retailer.name = name;
    retailer.iconURL = iconURL;
    retailer.exclusiveImageURL = imageURL;
    
    return retailer;
}


+ (Retailer*)fetchRetailerForID:(NSString*)ID
{
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Retailer"];
    request.predicate = [NSPredicate predicateWithFormat:@"active == 1"];
    
    return [[context executeFetchRequest:request error:nil] firstObject];
}


@end
