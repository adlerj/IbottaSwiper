//
//  Offer+Addon.h
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/29/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import "Offer.h"

typedef enum {
    kLikedStatus_None = 0,
    kLikedStatus_Liked = 1,
    kLikedStatus_Disliked = 2
} LikedStatus;

@interface Offer (Addon)

/**
 * @param ID the offerID
 * @param name the name of this offer
 * @param imageURL the url pointing to an image of this offer
 * @param shareURL the url pointing to this offer's webpage
 * @param earningsPotential how much money can be earned with this offer
 *
 * @return If an offer with the same offerID as the one given exists,
 *         it will be reused and updated with the given parameters, otherwise
 *         a new one will be generated.
 */
+ (Offer*)createOrUpdateOfferWithID:(NSString*)ID
                               name:(NSString*)name
                           imageURL:(NSString*)imageURL
                           shareURL:(NSString*)shareURL
                  earningsPotential:(NSNumber*)earningPotential;

/**
 * @param ID the offerID we are looking up
 * @return an offer that has the offerID given as input
 */
+ (Offer*)fetchOfferForID:(NSString*)ID;

///@return An array of all offerIDs
+ (NSArray*)fetchAllOfferIDs;

///@return An array of all liked offers
+ (NSArray*)fetchAllLikedOffers;

///@param IDs the offerIDs for offers to be deleted
+ (void)deleteOffersWithIDs:(NSArray*)IDs;

//@return the offer name with minor formatting to remove ugly characters
- (NSString*)displayName;

///@param status The likedStatus this offer is being set to
- (void)setLikedStatus:(LikedStatus)status;

///@return The liked status for this offer
- (LikedStatus)likedStatus;

///@return An NSOperation for downloading this offer's image
- (NSOperation*)createDownloadOperation;

@end
