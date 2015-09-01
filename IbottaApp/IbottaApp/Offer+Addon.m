//
//  Offer+Addon.m
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/29/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import "Offer+Addon.h"
#import "OfferImage+Addon.h"

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
    offer.earningsPotential = earningPotential;
    offer.image = [OfferImage offerImageWithURL:imageURL];
    
    return offer;
}


+ (Offer*)fetchOfferForID:(NSString*)ID
{
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Offer"];
    request.predicate = [NSPredicate predicateWithFormat:@"offerID == %@", ID];
    
    return [[context executeFetchRequest:request error:nil] firstObject];
}

+ (NSArray*)fetchAllLikedOffers
{
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Offer"];
    request.predicate = [NSPredicate predicateWithFormat:@"liked == %@", [NSNumber numberWithInt:kLikedStatus_Liked]];
    
    return [context executeFetchRequest:request error:nil];
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

- (NSString*)displayName
{
    return [self.name stringByReplacingOccurrencesOfString:@"Â®" withString:@" -"];
}

- (void)setLikedStatus:(LikedStatus)status
{
    self.liked = [NSNumber numberWithInt:status];
    if (status == kLikedStatus_Disliked) {
        NSError *error = nil;
        [self.image deleteImageWithError:&error];
        
        if (error) {
            NSLog(@"Error deleting image: %@", error);
        }
    }
}

- (LikedStatus)likedStatus
{
    return (LikedStatus)[self.liked intValue];
}

- (NSOperation*)createDownloadOperation
{
    NSInvocationOperation* operation = [[NSInvocationOperation alloc] initWithTarget:self.image
                                                                            selector:@selector(downloadImage) object:nil];
    
    return operation;
}

@end
