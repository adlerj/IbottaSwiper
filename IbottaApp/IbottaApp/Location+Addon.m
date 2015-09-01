//
//  Location+Addon.m
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import "Location+Addon.h"
#import "Offer+Addon.h"
#import "Retailer.h"

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

+ (NSArray*)fetchAllLocations
{
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    return [context executeFetchRequest:request error:nil];

}

+ (Location*)fetchLocationWithID:(NSString*)ID
{
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    request.predicate = [NSPredicate predicateWithFormat:@"locationID = %@", ID];
    
    return [[context executeFetchRequest:request error:nil] firstObject];
}

+ (NSArray*)fetchAllLocationIDs
{
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    request.resultType = NSDictionaryResultType;
    request.returnsDistinctResults = YES;
    
    [request setPropertiesToFetch:[NSArray arrayWithObject:@"locationID"]];
    
    NSArray *objects = [context executeFetchRequest:request error:nil];
    return [objects valueForKey:@"locationID"];
}

+ (NSArray*)fetchClosestLocationsWithUnlikedOffers:(int)numberOfLocations withinRange:(double)miles
{
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    NSPredicate *distancePredicate = [NSPredicate predicateWithFormat:@"distance =< %f AND distance > 0", miles];
    NSPredicate *offersPredicate = [NSPredicate predicateWithFormat:@"retailer.unlikedOffers > 0"];

    request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[distancePredicate, offersPredicate]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES]];
    request.fetchLimit = numberOfLocations;
    
    return [context executeFetchRequest:request error:nil];
}

+ (void)deleteLocationsWithIDs:(NSArray*)IDs
{
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    
    for (NSString *ID in IDs) {
        Location *location = [Location fetchLocationWithID:ID];
        if (location) {
            location.retailer = nil;
            [context deleteObject:location];
        }
    }
}

- (NSSet*)offers
{
    return self.retailer.offers;
}

@end
