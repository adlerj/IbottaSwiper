//
//  JADLocationManager.m
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import "JADLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "Location+Addon.h"

NSString * const kDistancesUpdatedNotification = @"com.jadler.distancesUpdated";
double const metersInAMile = 1609.34;

@interface JADLocationManager () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) int miles;
@end

@implementation JADLocationManager

- (instancetype)initWithDistanceFilter:(int)miles
{
    self = [super init];
    
    if (self) {
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
            self.miles = miles;
        }
        
        [self.locationManager startUpdatingLocation];
    }
    
    return self;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = self.miles * metersInAMile;
    }
    
    return _locationManager;
}

- (void)recalculateDistances:(CLLocation*)currentLocation
{
    
//Maybe one day I won't have to fake being in Denver ;)
    
//    if (currentLocation) {
//        currentLocation = [[CLLocation alloc] initWithLatitude:39.7392
//                                                     longitude:-104.9903];
//    }
    
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    
    [context performBlockAndWait:^{
        NSArray *locationObjects = [Location fetchAllLocations];
        for (Location *locationObject in locationObjects) {
            CLLocation *location = [[CLLocation alloc] initWithLatitude:[locationObject.latitude doubleValue]
                                                                  longitude:[locationObject.longitude doubleValue]];
            
            CLLocationDistance distance = [location distanceFromLocation: currentLocation]/metersInAMile;
            locationObject.distance = [NSNumber numberWithDouble:distance];
        }
        
        [context save:nil];
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kDistancesUpdatedNotification object:nil];
}


#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = (CLLocation*)[locations firstObject];
    [self recalculateDistances:location];
}

@end
