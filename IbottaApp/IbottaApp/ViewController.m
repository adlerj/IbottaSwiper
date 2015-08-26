//
//  ViewController.m
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/27/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import "ViewController.h"
#import "JADLocationManager.h"
#import "Location+Addon.h"
#import "Retailer+Addon.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationsUpdated:) name:kDistancesUpdatedNotification object:nil];
}

- (void)locationsUpdated:(NSNotification*)note
{
    NSArray *closestLocations = [Location fetchClosestLocations:50 withinRange:20];
    
    if (![closestLocations count]) {
        NSLog(@"Sorry there are no location around you");
    }
    
    for (Location *location in closestLocations) {
        NSLog(@"%@ - Distance: %@ mile(s)", location.retailer.name, location.distance);
    }
}

@end
