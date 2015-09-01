//
//  Location+Addon.h
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import "Location.h"

@interface Location (Addon)

/**
 * @param ID the locationID
 * @param latitude the location's latitude
 * @param longitude the location's longitude
 *
 * @return If a Location with the same locationID as the one given exists,
 *         it will be reused and updated with the given parameters, otherwise
 *         a new one will be generated.
 */
+ (Location*)createOrUpdateLocationWithID:(NSString*)ID
                                 latitude:(NSNumber*)latitude
                                longitude:(NSNumber*)longitude;

/**
 * @param ID the locationID we are looking up
 * @return a Location that has the locationID given as input
 */
+ (Location*)fetchLocationWithID:(NSString*)ID;

///@return An array of all Locations
+ (NSArray*)fetchAllLocations;

///@return An array of all locationIDs
+ (NSArray*)fetchAllLocationIDs;

/**
 * @param numberOfLocations the max number of locations to return
 * @param miles max distance the locations can be from our last calculated location
 * @return Array of locations meeting requirements
 * @note note locations with a distance of 0 are ignored because we can assume 
 *            their distances have never been calculated
 */
+ (NSArray*)fetchClosestLocationsWithUnlikedOffers:(int)numberOfLocations withinRange:(double)miles;


///@param IDs the locationIDs for locations to be deleted
+ (void)deleteLocationsWithIDs:(NSArray*)IDs;

///@return Set of Offers at this location
- (NSSet*)offers;

@end
