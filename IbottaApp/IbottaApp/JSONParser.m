//
//  JSONParser.m
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import "JSONParser.h"
#import "CheckSumHandler.h"
#import "Retailer+Addon.h"
#import "Location+Addon.h"
#import "Offer+Addon.h"

@implementation JSONParser


+ (BOOL)parseRetailersAtPathIfNew:(NSString*)path
{
    NSError *error = nil;
    
    NSString *fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    NSData *fileData = [fileContents dataUsingEncoding:NSUTF8StringEncoding];
    
    if(error) {
        NSLog(@"Error reading file: %@", error.localizedDescription);
        return NO;
    }
    
    if ([CheckSumHandler checkChecksumForData:fileData ofType:JSONFile_Retailers]) {
        return YES;
    }
    
    
    // Get JSON objects into initial array
    NSArray *rawRetailers = [[NSJSONSerialization JSONObjectWithData:[fileContents dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL] valueForKey:@"retailers"];
    
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    [context performBlockAndWait:^{

        NSMutableArray *retailIDs = [[Retailer fetchAllRetailerIDs] mutableCopy];
        
        for (NSDictionary *retailerDict in rawRetailers) {
            
            NSString *retailerID = [retailerDict[@"id"] stringValue];
            
            [Retailer createOrUpdateRetailerWithID: retailerID
                                              name:retailerDict[@"name"]];
            [retailIDs removeObject:retailerID];
        }
        
        //Remove all deleted retailers for CoreData
        [Retailer deleteRetailersWithIDs:retailIDs];
        
        [context save:nil];
    }];
    
    [CheckSumHandler saveChecksumForData:fileData ofType:JSONFile_Retailers];
    return YES;
}

+ (BOOL)parseLocationsAtPathIfNew:(NSString*)path
{
    NSError *error = nil;
    
    NSString *fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    if(error) {
        NSLog(@"Error reading file: %@", error.localizedDescription);
        return NO;
    }

    NSData *fileData = [fileContents dataUsingEncoding:NSUTF8StringEncoding];
    
    if ([CheckSumHandler checkChecksumForData:fileData ofType:JSONFile_Locations]) {
        return YES;
    }

    // Get JSON objects into initial array
    NSArray *rawLocations = [[NSJSONSerialization JSONObjectWithData:[fileContents dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL] valueForKey:@"stores"];
    
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    [context performBlockAndWait:^{
        
        NSMutableArray *locationIDs = [[Location fetchAllLocationIDs] mutableCopy];
        
        for (NSDictionary *locationDict in rawLocations) {
            
            NSString *locationID = [locationDict[@"id"] stringValue];
            NSString *retailerID = [locationDict[@"retailer_id"] stringValue];
                
            Location *location = [Location createOrUpdateLocationWithID:locationID
                                                               latitude:locationDict[@"lat"]
                                                              longitude:locationDict[@"long"]];
            [locationIDs removeObject:locationID];
            
            Retailer *retailer = [Retailer fetchRetailerForID:retailerID];
            if (retailer) {
                location.retailer = retailer;
            }
        }
        
        //Delete all old locations from CoreData
        [Location deleteLocationsWithIDs:locationIDs];
        
        [context save:nil];
    }];
    
    [CheckSumHandler saveChecksumForData:fileData ofType:JSONFile_Locations];
    return YES;
}

+ (BOOL)parseOffersAtPathIfNew:(NSString*)path
{
    NSError *error = nil;
    
    NSString *fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    if(error) {
        NSLog(@"Error reading file: %@", error.localizedDescription);
        return NO;
    }
    
    NSData *fileData = [fileContents dataUsingEncoding:NSUTF8StringEncoding];
    
    if ([CheckSumHandler checkChecksumForData:fileData ofType:JSONFile_Offers]) {
        return YES;
    }
    
    // Get JSON objects into initial array
    NSArray *rawOffers = [[NSJSONSerialization JSONObjectWithData:[fileContents dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL] valueForKey:@"offers"];
    
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    [context performBlockAndWait:^{
        
        NSMutableArray *offerIDs = [[Offer fetchAllOfferIDs] mutableCopy];
        
        for (NSDictionary *offerDict in rawOffers) {
            
            NSString *offerID = [offerDict[@"id"] stringValue];
            NSSet *retailerIDs = offerDict[@"retailers"];

            Offer *offer = [Offer createOrUpdateOfferWithID:offerID
                                                       name:offerDict[@"name"]
                                                   imageURL:offerDict[@"url"]
                                                   shareURL:offerDict[@"share_url"]
                                          earningsPotential:offerDict[@"earnings_potential"]];
            
            
            for (NSNumber *retailerID in retailerIDs) {
                Retailer *retailer = [Retailer fetchRetailerForID:[retailerID stringValue]];
                if (retailer) {
                    [offer addRetailersObject:retailer];
                    [retailer incrementUnlikedOffers];
                }
            }
            
            if ([offer.retailers count]) {
                [offerIDs removeObject:offerID];
            }
        }
        
        //Delete all old offers from CoreData
        [Offer deleteOffersWithIDs:offerIDs];
        
        [context save:nil];
    }];
    
    [CheckSumHandler saveChecksumForData:fileData ofType:JSONFile_Offers];
    return YES;
}

@end
