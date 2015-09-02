//
//  Retailer+Addon.m
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import "Retailer+Addon.h"
#import "Location.h"

@implementation Retailer (Addon)

+ (Retailer*)createOrUpdateRetailerWithID:(NSString*)ID
                                name:(NSString*)name
{
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    
    Retailer *retailer = [Retailer fetchRetailerForID:ID];
    if (!retailer) {
        retailer = [NSEntityDescription insertNewObjectForEntityForName:@"Retailer" inManagedObjectContext:context];
    }
    
    retailer.retailerID = ID;
    retailer.name = name;
    
    return retailer;
}


+ (Retailer*)fetchRetailerForID:(NSString*)ID
{
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Retailer"];
    request.predicate = [NSPredicate predicateWithFormat:@"retailerID == %@", ID];
    
    return [[context executeFetchRequest:request error:nil] firstObject];
}

+ (NSArray*)fetchAllRetailerIDs
{
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Retailer"];
    request.resultType = NSDictionaryResultType;
    request.returnsDistinctResults = YES;
    
    [request setPropertiesToFetch:[NSArray arrayWithObject:@"retailerID"]];
    
    NSArray *objects = [context executeFetchRequest:request error:nil];
    return [objects valueForKey:@"retailerID"];
}

+ (void)deleteRetailersWithIDs:(NSArray*)IDs
{
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;

    for (NSString *ID in IDs) {
        Retailer *retailer = [Retailer fetchRetailerForID:ID];
        if (retailer) {
            [retailer removeLocations:retailer.locations];
            [retailer removeOffers:retailer.offers];
            [context deleteObject:retailer];
        }
    }
}

- (double)closestLocationDistance
{
    __block double closest = -1;
    
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    [context performBlockAndWait:^{
        NSMutableArray *distances = [[[self.locations valueForKey:@"distance"] allObjects] mutableCopy];
        distances = [[distances sortedArrayUsingComparator:^NSComparisonResult(NSNumber *d1, NSNumber *d2) {
            if ([d1 doubleValue] < [d2 doubleValue]) {
                return NSOrderedAscending;
            } else if ([d1 doubleValue] > [d2 doubleValue]) {
                return NSOrderedDescending;
            }
            return NSOrderedSame;
        }] mutableCopy];
        
        [distances removeObject:[NSNumber numberWithDouble:0]];
        closest = [[distances firstObject] doubleValue];
    }];
    
    return closest;
}

- (void)incrementUnlikedOffers
{
    int sum = [self.unlikedOffers intValue] + 1;
    self.unlikedOffers = [NSNumber numberWithInt:sum];
}

- (void)decrementUnlikedOffers
{
    int difference = [self.unlikedOffers intValue] - 1;
    self.unlikedOffers = [NSNumber numberWithInt:difference];
}


@end
