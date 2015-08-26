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
NSString * const kLastCalculatedLocation = @"com.jadler.lastCalculatedLocation";
double const distanceToRecalculate = 1; //Miles
double const metersInAMile = 1609.34;

@interface JADLocationManager () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation JADLocationManager

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
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
        _locationManager.distanceFilter = 1 * metersInAMile;
    }
    
    return _locationManager;
}

- (BOOL)shouldRecalculateDistances:(CLLocation*)currentLocation
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *data = [ud valueForKey:kLastCalculatedLocation];
    
    
    if (data) {
        CLLocation *lastCalculatedLocation = (CLLocation*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
        CLLocationDistance distance = [lastCalculatedLocation distanceFromLocation:currentLocation] / metersInAMile;
        
        return (distance > distanceToRecalculate);
    }
    
    return YES;
}

- (void)recalculateDistances:(CLLocation*)currentLocation
{
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
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:currentLocation];

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:data forKey:kLastCalculatedLocation];
    [ud synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kDistancesUpdatedNotification object:nil];
}


#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = (CLLocation*)[locations firstObject];
    
    if ([self shouldRecalculateDistances:location]) {
        [self recalculateDistances:location];
    }
}

@end
