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
        }
    }
    
    return YES;
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
    } else {
        image = [UIImage animatedImageNamed:@"loader-" duration:0.03f];
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
