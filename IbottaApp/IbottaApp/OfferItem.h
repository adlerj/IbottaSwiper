//
//  OfferItem.h
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright © 2015 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfferItem : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) double price;
@property (nonatomic) double distance;

- (instancetype)initWithName:(NSString*)name
                       image:(UIImage*)image
                       price:(double)price;

@end
