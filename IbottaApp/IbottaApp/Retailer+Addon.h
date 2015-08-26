//
//  Retailer+Addon.h
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import "Retailer.h"

@interface Retailer (Addon)
+ (Retailer*)createOrUpdateRetailerWithID:(NSString*)ID
                                   active:(NSNumber*)active
                                     name:(NSString*)name
                                  iconURL:(NSString*)iconURL
                                 imageURL:(NSString*)imageURL;

+ (Retailer*)fetchRetailerForID:(NSString*)ID;
@end
