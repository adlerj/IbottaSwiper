//
//  OfferImage+Addon.m
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/31/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import "OfferImage+Addon.h"

@implementation OfferImage (Addon)

+ (OfferImage*)offerImageWithURL:(NSString*)url
{
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    
    OfferImage *image = [NSEntityDescription insertNewObjectForEntityForName:@"OfferImage" inManagedObjectContext:context];
    image.isDownloaded = @NO;
    image.localPath = @"";
    image.imageURL = url;
    
    return image;
}

+ (NSString*)imageDirectory
{
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [documentsDirectoryPath stringByAppendingPathComponent:@"offerImages"];
}

- (void)downloadImage
{
    if (![self.isDownloaded boolValue]) {
        __weak __typeof(self)weakSelf = self;
        
        NSString *imgName = [self.imageURL lastPathComponent];
        NSString *writablePath = [[OfferImage imageDirectory] stringByAppendingPathComponent:imgName];
        NSError *error = nil;
        
        BOOL success = [weakSelf saveImageInLocalDirectoryToPath:writablePath error:&error];
        
        if (success) {
            NSLog(@"Successfully saved image %@", imgName);
            NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
            [context performBlock:^{
                weakSelf.localPath = imgName;
                weakSelf.isDownloaded = @YES;
                [context save:nil];
            }];
        } else {
            NSLog(@"Downloading image %@ failed with error: %@", imgName, error);
        }
        
    }
}

- (BOOL)saveImageInLocalDirectoryToPath:(NSString*)writablePath error:(NSError *__autoreleasing *)error
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *localError = nil;
    
    if (![fileManager fileExistsAtPath:[OfferImage imageDirectory]]){
        [fileManager createDirectoryAtPath:[OfferImage imageDirectory]
               withIntermediateDirectories:NO
                                attributes:nil
                                     error:&localError];
        if (localError) {
            if (error) {
                *error = localError;
            }
            return NO;
        }
    }
    
    
    if(![fileManager fileExistsAtPath:writablePath]){
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURL]];
        if (data) {
            [data writeToFile:writablePath options:NSAtomicWrite error:&localError];
            
            if (localError) {
                if (error) {
                    *error = localError;
                }
                return NO;
            }
        } else {
            if (error) {
                
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Failed to download file at URL: %@", self.imageURL]};
                
                *error = [NSError errorWithDomain:@"com.jadler.nodownload" code:-1 userInfo:userInfo];
            }
            return NO;
        }
    }
    
    return YES;
}

- (UIImage*)retrieveImageSizedToFrame:(CGRect)frame
{
    UIImage *image = [self retrieveImage];
    if (image) {
        float heightDif = image.size.height - frame.size.height;
        float widthDif = image.size.width - frame.size.width;
        
        if (heightDif > widthDif) {
            return [OfferImage image:image scaledToHeight:frame.size.height];
        } else {
            return [OfferImage image:image scaledToWidth:frame.size.width];
        }
    }
    
    return image;
}

+ (UIImage*)image:(UIImage*)image scaledToWidth:(float)width
{
    
    float oldWidth = image.size.width;
    float scaleFactor = width / oldWidth;
    
    float newHeight = image.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [image drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage*)image:(UIImage*)image scaledToHeight:(float)height
{
    float oldHeight = image.size.height;
    float scaleFactor = height / oldHeight;

    float newWidth = image.size.width * scaleFactor;
    float newHeight = oldHeight * scaleFactor;

    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [image drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)retrieveImage
{
    UIImage *image = nil;
    if ([self.isDownloaded boolValue]) {
        NSError *error = nil;
        NSString *imgPath = [[OfferImage imageDirectory] stringByAppendingPathComponent:self.localPath];
        NSData *imageData = [NSData dataWithContentsOfFile:imgPath options:NSDataReadingUncached error:&error];
        if (error) {
            NSLog(@"Error retrieving file: %@", error);
            image = [UIImage imageNamed:@"noImage"];
        } else {
            image = [UIImage imageWithData:imageData];
        }
    }
    return image;
}

- (BOOL)deleteImageWithError:(NSError *__autoreleasing *)error
{
    if ([self.isDownloaded boolValue]) {
        NSString *imgName = [self.imageURL lastPathComponent];
        NSString *imagePath = [[OfferImage imageDirectory] stringByAppendingPathComponent:imgName];
        NSError *localError = nil;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:imagePath error:&localError];
        
        if (localError) {
            if (error) {
                *error = localError;
            }
            return NO;
        }
        self.isDownloaded = @NO;
    }
    return YES;
}

@end
