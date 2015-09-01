//
//  OfferImage.h
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/31/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Offer;

@interface OfferImage : NSManagedObject

@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * localPath;
@property (nonatomic, retain) NSNumber * isDownloaded;
@property (nonatomic, retain) Offer *offer;

@end
