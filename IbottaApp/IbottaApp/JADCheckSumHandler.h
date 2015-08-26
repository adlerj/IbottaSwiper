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
- (BOOL)checkChecksumForData:(NSData*)data ofType:(JSONFile)fileType;
- (void)saveChecksumForData:(NSData*)data ofType:(JSONFile)fileType;
@end
