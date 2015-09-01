//
//  Retailer+Addon.h
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import "Retailer.h"

@interface Retailer (Addon)

/**
 * @param ID the retailerID
 * @param active whether or not this retailer is active
 * @param name the name of this retailer
 * @param iconURL the url pointing to an ico for this retailer
 * @param imageURL the url pointing to an image of this retailer
 *
 * @return If a retailer with the same retailerID as the one given exists,
 *         it will be reused and updated with the given parameters, otherwise
 *         a new one will be generated.
 */
+ (Retailer*)createOrUpdateRetailerWithID:(NSString*)ID
                                   active:(NSNumber*)active
                                     name:(NSString*)name
                                  iconURL:(NSString*)iconURL
                                 imageURL:(NSString*)imageURL;

/**
 * @param ID the retailerID we are looking up
 * @return a Retailer that has the retailerID given as input
 */
+ (Retailer*)fetchRetailerForID:(NSString*)ID;

/**
 * @return An array of all unique retailerIDs
 */
+ (NSArray*)fetchAllRetailerIDs;

/**
 * @param IDs specifies which retailers are to be deleted
 */
+ (void)deleteRetailersWithIDs:(NSArray*)IDs;

///Adds one to the unlikedOffers count
- (void)incrementUnlikedOffers;

///Subtracts one from the unlikedOffers count
- (void)decrementUnlikedOffers;
@end
