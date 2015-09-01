//
//  OfferImage+Addon.h
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/31/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import "OfferImage.h"

@interface OfferImage (Addon)

+ (OfferImage*)offerImageWithURL:(NSString*)url;

+ (NSString*)imageDirectory;

- (void)downloadImage;

- (UIImage*)retrieveImage;

- (BOOL)deleteImageWithError:(NSError *__autoreleasing *)error;

@end
