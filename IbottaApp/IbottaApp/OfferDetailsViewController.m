//
//  OfferDetailsViewController.m
//  IbottaApp
//
//  Created by Jeffrey Adler on 9/1/15.
//  Copyright © 2015 Jeff. All rights reserved.
//

#import "OfferDetailsViewController.h"
#import "OfferImage+Addon.h"

@interface OfferDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic) BOOL usingKVO;
@end

@implementation OfferDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.label.text = self.offer.name;
    self.imageView.image = [self.offer.image retrieveImage];
    
    if (![self.offer.image.isDownloaded boolValue]) {
        self.usingKVO = YES;
        [self.offer.image addObserver:self forKeyPath:@"isDownloaded" options:NSKeyValueObservingOptionNew context:nil];
    } else {
        self.usingKVO = NO;
    }
}


- (IBAction)goToOffer:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.offer.offerURL]];
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
