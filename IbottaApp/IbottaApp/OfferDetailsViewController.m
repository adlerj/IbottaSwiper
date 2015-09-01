//
//  OfferDetailsViewController.m
//  IbottaApp
//
//  Created by Jeffrey Adler on 9/1/15.
//  Copyright © 2015 Jeff. All rights reserved.
//

#import "OfferDetailsViewController.h"
#import "OfferImage+Addon.h"
#import "Offer+Addon.h"

@interface OfferDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *openSiteButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) NSString *offerURL;
@property (weak, nonatomic) IBOutlet UIButton *viewOfferButton;
@property (nonatomic) BOOL usingKVO;
@end

@implementation OfferDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.infoLabel.text = [self prepareInfo];
    self.imageView.image = [self.offer.image retrieveImage];
    self.offerURL = self.offer.offerURL;
    
    if (![self.offer.image.isDownloaded boolValue]) {
        self.usingKVO = YES;
        [self.offer.image addObserver:self forKeyPath:@"isDownloaded" options:NSKeyValueObservingOptionNew context:nil];
    } else {
        self.usingKVO = NO;
    }
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"ibotta-app://"]]) {
        [self.viewOfferButton setTitle:@"Get Ibotta App" forState:UIControlStateNormal];
    }
    
    [self.openSiteButton setImage:[[UIImage imageNamed:@"safari-icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

- (IBAction)openOfferInWeb:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.offerURL]];
}

- (IBAction)goToOffer:(UIButton *)sender {
    
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    
    __block NSString *appURL = @"";
    NSString *appStoreURL = @"itms-apps://itunes.apple.com/us/app/ibotta/id559887125?mt=8";
    [context performBlockAndWait:^{
        appURL = [@"ibotta-app://retailer/any/offer/" stringByAppendingPathComponent:self.offer.offerID];
    }];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appURL]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appURL]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreURL]];
    }
    
}

- (NSString*)prepareInfo
{
    NSString *distance = [self.offer displayDistance];
    NSString *earnings = [self.offer displayPotentialEarnings];
    
    NSString *info = [NSString stringWithFormat:@"%@  - %@" ,distance ,earnings];
    return info;
}

- (void)dealloc
{
    if (self.usingKVO) {
        [self.offer.image removeObserver:self forKeyPath:@"isDownloaded"];
    }
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    if (object == self.offer.image && [keyPath isEqualToString:@"isDownloaded"]) {
        self.imageView.image = [self.offer.image retrieveImage];
        [self.offer.image removeObserver:self forKeyPath:@"isDownloaded"];
        self.usingKVO = NO;
    }
}

@end
