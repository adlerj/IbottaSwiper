//
//  Offer+CoreDataProperties.h
//  
//
//  Created by Jeffrey Adler on 9/1/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Offer.h"

NS_ASSUME_NONNULL_BEGIN

@interface Offer (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *distance;
@property (nullable, nonatomic, retain) NSNumber *earningsPotential;
@property (nullable, nonatomic, retain) NSNumber *liked;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *offerID;
@property (nullable, nonatomic, retain) NSString *offerURL;
@property (nullable, nonatomic, retain) OfferImage *image;
@property (nullable, nonatomic, retain) NSSet<Retailer *> *retailers;

@end

@interface Offer (CoreDataGeneratedAccessors)

- (void)addRetailersObject:(Retailer *)value;
- (void)removeRetailersObject:(Retailer *)value;
- (void)addRetailers:(NSSet<Retailer *> *)values;
- (void)removeRetailers:(NSSet<Retailer *> *)values;

@end

NS_ASSUME_NONNULL_END
