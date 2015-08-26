//
//  JSONParser.h
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParser : NSObject
+ (BOOL)parseRetailersAtPathIfNew:(NSString*)path;
+ (BOOL)parseLocationsAtPathIfNew:(NSString*)path;
@end
