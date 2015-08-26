//
//  Location+Addon.m
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import "Location+Addon.h"

@implementation Location (Addon)
+ (Location*)createOrUpdateLocationWithID:(NSString*)ID
                                 latitude:(NSNumber*)latitude
                                longitude:(NSNumber*)longitude
{
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    
    Location *location = [Location fetchLocationWithID:ID];
    if (!location) {
        location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:context];
    }
    location.locationID = ID;
    location.latitude = latitude;
    location.longitude = longitude;
    
    return location;
}

+ (Location*)fetchLocationWithID:(NSString*)ID
{
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    request.predicate = [NSPredicate predicateWithFormat:@"locationID = %%@", ID];
    
    return [[context executeFetchRequest:request error:nil] firstObject];
}
@end
