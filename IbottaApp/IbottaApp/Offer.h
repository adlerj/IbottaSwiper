//
//  Offer.h
//  
//
//  Created by Jeffrey Adler on 9/1/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OfferImage, Retailer;

@interface Offer : NSManagedObject

@property (nonatomic, retain) NSNumber *distance;
@property (nonatomic, retain) NSNumber *earningsPotential;
@property (nonatomic, retain) NSNumber *liked;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *offerID;
@property (nonatomic, retain) NSString *offerURL;
@property (nonatomic, retain) OfferImage *image;
@property (nonatomic, retain) NSSet *retailers;

@end

@interface Offer (CoreDataGeneratedAccessors)

- (void)addRetailersObject:(Retailer *)value;
- (void)removeRetailersObject:(Retailer *)value;
- (void)addRetailers:(NSSet *)values;
- (void)removeRetailers:(NSSet *)values;

@end
