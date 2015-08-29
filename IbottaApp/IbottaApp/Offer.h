//
//  Offer.h
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/29/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Retailer;

@interface Offer : NSManagedObject

@property (nonatomic, retain) NSString * offerID;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * earningsPotential;
@property (nonatomic, retain) NSSet *retailers;
@end

@interface Offer (CoreDataGeneratedAccessors)

- (void)addRetailersObject:(Retailer *)value;
- (void)removeRetailersObject:(Retailer *)value;
- (void)addRetailers:(NSSet *)values;
- (void)removeRetailers:(NSSet *)values;

@end
