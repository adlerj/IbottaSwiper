//
//  Offer+Addon.h
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/29/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import "Offer.h"
#import "OfferItem.h"

@interface Offer (Addon)

+ (Offer*)createOrUpdateOfferWithID:(NSString*)ID
                               name:(NSString*)name
                           imageURL:(NSString*)imageURL
                  earningsPotential:(NSNumber*)earningPotential;

+ (Offer*)fetchOfferForID:(NSString*)ID;
+ (NSArray*)fetchAllOfferIDs;
+ (void)deleteOffersWithIDs:(NSArray*)IDs;

- (OfferItem*) toOfferItem;

@end
