//
//  Location.h
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Retailer;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * locationID;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) Retailer *retailer;

@end
