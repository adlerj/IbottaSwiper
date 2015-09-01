//
//  JADCheckSumHandler.h
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JSONFile) {
    JSONFile_Offers = 0,
    JSONFile_Retailers = 1,
    JSONFile_Locations = 2
};

@interface JADCheckSumHandler : NSObject

/**
 * @param data file being checked
 * @param fileType which file we are checking
 * @return Returns YES if the checksum matches
 */
+ (BOOL)checkChecksumForData:(NSData*)data ofType:(JSONFile)fileType;

/**
 * @param data the files whos checksum is being saved
 * @param fileType which file we are saving a checksum for
 */
+ (void)saveChecksumForData:(NSData*)data ofType:(JSONFile)fileType;
@end
