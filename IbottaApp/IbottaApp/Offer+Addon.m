//
//  Offer+Addon.m
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/29/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import "Offer+Addon.h"

@implementation Offer (Addon)

+ (Offer*)createOrUpdateOfferWithID:(NSString*)ID
                                     name:(NSString*)name
                                 imageURL:(NSString*)imageURL
                     earningsPotential:(NSNumber*)earningPotential
{
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    
    Offer *offer = [Offer fetchOfferForID:ID];
    if (!offer) {
        offer = [NSEntityDescription insertNewObjectForEntityForName:@"Offer" inManagedObjectContext:context];
    }
    
    offer.offerID = ID;
    offer.name = name;
    offer.imageURL = imageURL;
    offer.earningsPotential = earningPotential;
    
    return offer;
}


+ (Offer*)fetchOfferForID:(NSString*)ID
{
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Offer"];
    request.predicate = [NSPredicate predicateWithFormat:@"offerID == %@", ID];
    
    return [[context executeFetchRequest:request error:nil] firstObject];
}

+ (NSArray*)fetchAllOfferIDs
{
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Offer"];
    request.resultType = NSDictionaryResultType;
    request.returnsDistinctResults = YES;
    
    [request setPropertiesToFetch:[NSArray arrayWithObject:@"offerID"]];
    
    NSArray *objects = [context executeFetchRequest:request error:nil];
    return [objects valueForKey:@"offerID"];
}

+ (void)deleteOffersWithIDs:(NSArray*)IDs
{
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    
    for (NSString *ID in IDs) {
        Offer *offer = [Offer fetchOfferForID:ID];
        if (offer) {
            [offer removeRetailers:offer.retailers];
            [context deleteObject:offer];
        }
    }
}

- (OfferItem*) toOfferItem
{
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURL]];
    UIImage *image = [UIImage imageWithData:imageData];
    
    return [[OfferItem alloc] initWithName:self.name
                              image:image
                              price:[self.earningsPotential doubleValue]
                           distance:0];
}


@end
