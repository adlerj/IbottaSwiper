//
//  NSData+Addon.h
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (Addon)

///@return the md5 hash for this data
- (NSString *)md5String;

@end
