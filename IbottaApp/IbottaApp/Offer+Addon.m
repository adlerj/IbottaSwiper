//
//  Offer+Addon.m
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/29/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import "Offer+Addon.h"
#import "OfferImage+Addon.h"
#import "Retailer+Addon.h"

@implementation Offer (Addon)

+ (Offer*)createOrUpdateOfferWithID:(NSString*)ID
                               name:(NSString*)name
                           imageURL:(NSString*)imageURL
                           shareURL:(NSString*)shareURL
                  earningsPotential:(NSNumber*)earningPotential
{
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    
    Offer *offer = [Offer fetchOfferForID:ID];
    if (!offer) {
        offer = [NSEntityDescription insertNewObjectForEntityForName:@"Offer" inManagedObjectContext:context];
    }
    
    offer.offerID = ID;
    offer.name = name;
    
    if (![offer.image.imageURL isEqualToString:imageURL]) {
        NSError *error = nil;
        
        [offer.image deleteImageWithError:&error];
        
        if (error) {
            NSLog(@"Error deleting image: %@", error);
        }
        
        offer.image.imageURL = imageURL;
    }
    
    offer.image = [OfferImage offerImageWithURL:imageURL];
    offer.offerURL = shareURL;
    
    int oldEarnings = [offer.earningsPotential intValue];
    int newEarnings = [earningPotential intValue];

    if (oldEarnings && newEarnings > oldEarnings && offer.likedStatus == kLikedStatus_Disliked) {
        //If this offer is being updated and the earnings potential has
        //increased, lets show the offer again if it was disliked
        [offer setLikedStatus:kLikedStatus_None];
    }
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
            
            NSError *error = nil;
            
            [offer.image deleteImageWithError:&error];
            
            if (error) {
                NSLog(@"Error deleting image: %@", error);
            }
            
            [context deleteObject:offer.image];
            [context deleteObject:offer];
        }
    }
}

- (NSString*)displayName
{
    return [self.name stringByReplacingOccurrencesOfString:@"Â®" withString:@" -"];
}

- (NSString*)displayDistance
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    formatter.maximumFractionDigits = 2;
    
    NSNumber *closestDistance = [NSNumber numberWithDouble:[self shortestDistanceToOffer]];
    NSString *distance = [formatter stringFromNumber:closestDistance];
    
    NSString *text = [NSString stringWithFormat:@"%@ Mi.", distance];
    
    return text;
}

- (double)shortestDistanceToOffer
{
    __block double closest = -1;
    
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    [context performBlockAndWait:^{
        
        NSAssert([[self.retailers anyObject] respondsToSelector:@selector(closestLocationDistance)],
                 @"Retailers have to respond to closestLocationDistance");
        
        NSMutableArray *distances = [[[self.retailers valueForKey:@"closestLocationDistance"] allObjects] mutableCopy];
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

- (NSString*)displayPotentialEarnings
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *price = [formatter stringFromNumber:self.earningsPotential];
    
    
    NSString *text = [NSString stringWithFormat:@"%@", price];
    return text;
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
