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

@implementation JSONParser


+ (BOOL)parseRetailersAtPathIfNew:(NSString*)path
{
    NSError *error = nil;
    
    NSString *fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    NSData *fileData = [fileContents dataUsingEncoding:NSUTF8StringEncoding];
    
    if ([JADCheckSumHandler checkChecksumForData:fileData ofType:JSONFile_Retailers]) {
        return YES;
    }
    
    if(error) {
        NSLog(@"Error reading file: %@", error.localizedDescription);
        return NO;
    }
    
    
    
    // Get JSON objects into initial array
    NSArray *rawRetailers = [[NSJSONSerialization JSONObjectWithData:[fileContents dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL] valueForKey:@"retailers"];
    
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    [context performBlockAndWait:^{
        for (NSDictionary *retailer in rawRetailers) {
            
            [Retailer createOrUpdateRetailerWithID:[NSString stringWithFormat:@"%d",(int)retailer[@"id"]]
                                            active:retailer[@"active"]
                                              name:retailer[@"name"]
                                           iconURL:retailer[@"icon_url"]
                                          imageURL:retailer[@"exclusive_image_url"]];
        }
        
        [context save:nil];
    }];
    
    [JADCheckSumHandler saveChecksumForData:fileData ofType:JSONFile_Retailers];
    return YES;
}





@end
