//
//  Location+Addon.h
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import "Location.h"

@interface Location (Addon)
+ (Location*)createOrUpdateLocationWithID:(NSString*)ID
                                 latitude:(NSNumber*)latitude
                                longitude:(NSNumber*)longitude;

+ (Location*)fetchLocationWithID:(NSString*)ID;
+ (NSArray*)fetchAllLocations;
+ (NSArray*)fetchAllLocationIDs;

+ (NSArray*)fetchClosestLocationsWithUnlikedOffers:(int)numberOfLocations withinRange:(double)miles;

+ (void)deleteLocationsWithIDs:(NSArray*)IDs;

- (NSSet*)offers;

@end
