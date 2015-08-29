//
//  Retailer.h
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/29/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location, Offer, RedemptionData;

@interface Retailer : NSManagedObject

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSNumber * anyBrand;
@property (nonatomic, retain) NSString * anyBrandFullURL;
@property (nonatomic, retain) NSString * anyBrandIconURL;
@property (nonatomic, retain) NSNumber * barcode;
@property (nonatomic, retain) NSString * cardSignupURL;
@property (nonatomic, retain) NSString * exclusiveImageURL;
@property (nonatomic, retain) NSNumber * featured;
@property (nonatomic, retain) NSString * iconURL;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * retailerID;
@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) NSNumber * verificationType;
@property (nonatomic, retain) NSSet *locations;
@property (nonatomic, retain) RedemptionData *redemptionData;
@property (nonatomic, retain) NSSet *offers;
@end

@interface Retailer (CoreDataGeneratedAccessors)

- (void)addLocationsObject:(Location *)value;
- (void)removeLocationsObject:(Location *)value;
- (void)addLocations:(NSSet *)values;
- (void)removeLocations:(NSSet *)values;

- (void)addOffersObject:(Offer *)value;
- (void)removeOffersObject:(Offer *)value;
- (void)addOffers:(NSSet *)values;
- (void)removeOffers:(NSSet *)values;

@end
