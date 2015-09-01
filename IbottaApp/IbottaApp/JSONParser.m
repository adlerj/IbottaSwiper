//
//  JSONParser.m
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import "JSONParser.h"
#import "JADCheckSumHandler.h"
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
    
    if ([JADCheckSumHandler checkChecksumForData:fileData ofType:JSONFile_Retailers]) {
        return YES;
    }
    
    
    // Get JSON objects into initial array
    NSArray *rawRetailers = [[NSJSONSerialization JSONObjectWithData:[fileContents dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL] valueForKey:@"retailers"];
    
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    [context performBlockAndWait:^{

        NSMutableArray *retailIDs = [[Retailer fetchAllRetailerIDs] mutableCopy];
        
        for (NSDictionary *retailerDict in rawRetailers) {
            
            NSString *retailerID = [NSString stringWithFormat:@"%d",(int)retailerDict[@"id"]];
            
            [Retailer createOrUpdateRetailerWithID: retailerID
                                            active:retailerDict[@"active"]
                                              name:retailerDict[@"name"]
                                           iconURL:retailerDict[@"icon_url"]
                                          imageURL:retailerDict[@"exclusive_image_url"]];
            [retailIDs removeObject:retailerID];
        }
        
        //Remove all deleted retailers for CoreData
        [Retailer deleteRetailersWithIDs:retailIDs];
        
        [context save:nil];
    }];
    
    [JADCheckSumHandler saveChecksumForData:fileData ofType:JSONFile_Retailers];
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
    
    if ([JADCheckSumHandler checkChecksumForData:fileData ofType:JSONFile_Locations]) {
        return YES;
    }

    // Get JSON objects into initial array
    NSArray *rawLocations = [[NSJSONSerialization JSONObjectWithData:[fileContents dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL] valueForKey:@"stores"];
    
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    [context performBlockAndWait:^{
        
        NSMutableArray *locationIDs = [[Location fetchAllLocationIDs] mutableCopy];
        
        for (NSDictionary *locationDict in rawLocations) {
            
            NSString *locationID = [NSString stringWithFormat:@"%d",(int)locationDict[@"id"]];
            NSString *retailerID = [NSString stringWithFormat:@"%d",(int)locationDict[@"retailer_id"]];
                
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
    
    [JADCheckSumHandler saveChecksumForData:fileData ofType:JSONFile_Locations];
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
    
    if ([JADCheckSumHandler checkChecksumForData:fileData ofType:JSONFile_Offers]) {
        return YES;
    }
    
    // Get JSON objects into initial array
    NSArray *rawOffers = [[NSJSONSerialization JSONObjectWithData:[fileContents dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL] valueForKey:@"offers"];
    
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    [context performBlockAndWait:^{
        
        NSMutableArray *offerIDs = [[Offer fetchAllOfferIDs] mutableCopy];
        
        for (NSDictionary *offerDict in rawOffers) {
            
            NSString *offerID = [NSString stringWithFormat:@"%d",(int)offerDict[@"id"]];
            NSSet *retailerIDs = offerDict[@"retailers"];

            Offer *offer = [Offer createOrUpdateOfferWithID:offerID
                                                       name:offerDict[@"name"]
                                                   imageURL:offerDict[@"url"]
                                                   shareURL:offerDict[@"share_url"]
                                          earningsPotential:offerDict[@"earnings_potential"]];
            
            [offerIDs removeObject:offerID];
            
            for (NSNumber *retailerID in retailerIDs) {
                Retailer *retailer = [Retailer fetchRetailerForID:[retailerID stringValue]];
                if (retailer) {
                    [offer addRetailersObject:retailer];
                    [retailer incrementUnlikedOffers];
                }
            }
            
            if (![offer.retailers count]) {
                [context deleteObject:offer];
            }
        }
        
        //Delete all old locations from CoreData
        [Location deleteLocationsWithIDs:offerIDs];
        
        [context save:nil];
    }];
    
    [JADCheckSumHandler saveChecksumForData:fileData ofType:JSONFile_Offers];
    return YES;
}

@end
