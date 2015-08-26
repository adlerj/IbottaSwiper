//
//  JADCheckSumHandler.m
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import "JADCheckSumHandler.h"
#import "NSData+Addon.h"

NSString * const kChecksumsLocation = @"com.jadler.checksumsLocation";

NSString * const kOffers = @"kOffers";
NSString * const kRetailers = @"kRetailers";
NSString * const kStoreLocation = @"kStoreLocation";

@implementation JADCheckSumHandler

+ (void)saveChecksumForData:(NSData*)data ofType:(JSONFile)fileType
{
    NSString *MD5 = [data md5String];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *checksums = [[ud dictionaryForKey:kChecksumsLocation] mutableCopy];
    
    if (!checksums) {
        checksums = [@{} mutableCopy];
    }
    
    NSString *key = [self keyForFileType:fileType];
    checksums[key] = MD5;
    
    [ud setValue:checksums forKey:kChecksumsLocation];
    [ud synchronize];
}

+ (BOOL)checkChecksumForData:(NSData*)data ofType:(JSONFile)fileType
{
    NSString *MD5 = [data md5String];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *checksums = [[ud dictionaryForKey:kChecksumsLocation] mutableCopy];
    
    if (!checksums) {
        return NO;
    }
    
    NSString *key = [self keyForFileType:fileType];
    return [checksums[key] isEqualToString:MD5];

}

+ (NSString*)keyForFileType:(JSONFile)fileType
{
    NSString* out = @"";
    
    switch (fileType) {
        case JSONFile_Locations:
            out = kStoreLocation;
            break;
        case JSONFile_Retailers:
            out = kRetailers;
            break;
        case JSONFile_Offers:
            out = kRetailers;
            break;
            
        default:
            break;
    }
    
    return out;
}

@end
