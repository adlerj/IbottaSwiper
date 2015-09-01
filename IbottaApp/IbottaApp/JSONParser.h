//
//  JSONParser.h
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParser : NSObject

/**
 * If this file is different from the last Retailers.json we parsed, it will be 
 * parsed.  Any retailers removed between the previous Retailers.json and this 
 * one get removed from the database.  All others will get added or updated.
 *
 * @param path the location of the Retailers.json file
 * @return Success
 */
+ (BOOL)parseRetailersAtPathIfNew:(NSString*)path;

/**
 * If this file is different from the last Locations.json we parsed, it will be
 * parsed.  Any locations removed between the previous Locations.json and this
 * one get removed from the database.  All others will get added or updated.
 *
 * @param path the location of the Locations.json file
 * @return Success
 */
+ (BOOL)parseLocationsAtPathIfNew:(NSString*)path;

/**
 * If this file is different from the last Offers.json we parsed, it will be
 * parsed.  Any offers removed between the previous Offers.json and this
 * one get removed from the database.  All others will get added of updated.
 *
 * @param path the location of the Offers.json file
 * @return Success
 */
+ (BOOL)parseOffersAtPathIfNew:(NSString*)path;
@end
