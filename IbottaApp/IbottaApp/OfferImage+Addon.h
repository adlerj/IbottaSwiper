//
//  OfferImage+Addon.h
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/31/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import "OfferImage.h"

@interface OfferImage (Addon)

/**
 * @param url location of the image
 * @return A new offerImage with the supplied url
 */
+ (OfferImage*)offerImageWithURL:(NSString*)url;

/**
 * @return The local directory of images, if it does not exist it will be created
 */
+ (NSString*)imageDirectory;

/**
 * If the image has not been downloaded yet, it will be downloaded from the
 * url to imageDirectory
 *
 * @note note isDownloaded will be set to YES if download is successful
 */
- (void)downloadImage;

/**
 * @return If the image is present in the local directory it will be returned
 *         if it cannot be found, a not found image will be returned in its place
 *         if it isn't downloaded yet we can assume it is being downloaded in 
 *         the background so we will return an animating loaded image for now
 */
- (UIImage*)retrieveImage;

/**
 * @param frame the frame the image needs to fit in
 * @return the image retrieved by retrieveImage with the same aspect ratio but
 *         new size to fit in the frame;
 */
- (UIImage*)retrieveImageSizedToFrame:(CGRect)frame;

/**
 * Deletes the local image and changes the downloaded state to NO
 * @return Success
 */
- (BOOL)deleteImageWithError:(NSError *__autoreleasing *)error;

@end
