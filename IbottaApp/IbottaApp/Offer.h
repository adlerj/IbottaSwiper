//
//  Offer.h
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/31/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OfferImage, Retailer;

@interface Offer : NSManagedObject

@property (nonatomic, retain) NSNumber * earningsPotential;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * offerID;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * liked;
@property (nonatomic, retain) NSSet *retailers;
@property (nonatomic, retain) OfferImage *image;
@end

@interface Offer (CoreDataGeneratedAccessors)

- (void)addRetailersObject:(Retailer *)value;
- (void)removeRetailersObject:(Retailer *)value;
- (void)addRetailers:(NSSet *)values;
- (void)removeRetailers:(NSSet *)values;

@end
