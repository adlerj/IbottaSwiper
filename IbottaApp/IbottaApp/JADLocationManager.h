//
//  JADLocationManager.h
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kDistancesUpdatedNotification;

@interface JADLocationManager : NSObject
/**
 * @param miles distance traveled before recalculation
 * initializes a CLLocation manager with a distanceFilter set to miles
 */
- (instancetype)initWithDistanceFilter:(int)miles;
@end
