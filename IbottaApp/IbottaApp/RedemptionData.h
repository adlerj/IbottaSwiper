//
//  RedemptionData.h
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Retailer;

@interface RedemptionData : NSManagedObject

@property (nonatomic, retain) NSData * additionalIntructions;
@property (nonatomic, retain) NSNumber * maxAge;
@property (nonatomic, retain) NSString * receiptName;
@property (nonatomic, retain) NSString * redeemString;
@property (nonatomic, retain) Retailer *retailer;

@end
