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

+ (Offer*)createOrUpdateOfferWithID:(NSString*)ID
                               name:(NSString*)name
                           imageURL:(NSString*)imageURL
                           shareURL:(NSString*)shareURL
                  earningsPotential:(NSNumber*)earningPotential;

+ (Offer*)fetchOfferForID:(NSString*)ID;
+ (NSArray*)fetchAllOfferIDs;
+ (NSArray*)fetchAllLikedOffers;
+ (void)deleteOffersWithIDs:(NSArray*)IDs;

- (NSString*)displayName;

- (void)setLikedStatus:(LikedStatus)status;
- (LikedStatus)likedStatus;

- (NSOperation*)createDownloadOperation;

@end
