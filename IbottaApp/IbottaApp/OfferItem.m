//
//  OfferItem.m
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright © 2015 Jeff. All rights reserved.
//

#import "OfferItem.h"

@implementation OfferItem

- (instancetype)initWithName:(NSString*)name
                       image:(UIImage*)image
                       price:(double)price
{
    self = [super init];
    
    if (self) {
        _name = name;
        _image = image;
        _price = price;
    }

    return self;
}

@end
