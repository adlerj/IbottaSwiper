//
//  ChooseOfferView.m
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright © 2015 Jeff. All rights reserved.
//

#import "ChooseOfferView.h"
#import "ImageLabelView.h"
#import "OfferImage+Addon.h"


static const CGFloat ChooseOfferViewImageLabelWidth = 42.f;

@interface ChooseOfferView ()
@property (nonatomic, strong) UIView *informationView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) ImageLabelView *savingsImageLabelView;
@property (nonatomic, strong) ImageLabelView *distanceImageLabelView;
@property (nonatomic, weak) Offer *offer;
@end

@implementation ChooseOfferView

#pragma mark - Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
                       offerItem:(Offer *)offer
                      options:(MDCSwipeToChooseViewOptions *)options {
    self = [super initWithFrame:frame options:options];
    if (self) {
        self.offer = offer;
        self.imageView.image = [self retrieveImage];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleBottomMargin;
        self.imageView.autoresizingMask = self.autoresizingMask;
        
        [self constructInformationView];
        
        if (![self.offer.image.isDownloaded boolValue]) {
            [self.offer.image addObserver:self forKeyPath:@"isDownloaded" options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    return self;
}

- (void)dealloc
{
    [self.offer.image removeObserver:self forKeyPath:@"isDownloaded"];
}

#pragma mark - Internal Methods

- (UIImage*)retrieveImage
{
    OfferImage *offerImage = self.offer.image;
    UIImage *image = nil;
    if ([offerImage.isDownloaded boolValue]) {
        NSError *error = nil;
        NSString *imgPath = [[OfferImage imageDirectory] stringByAppendingPathComponent:offerImage.localPath];
        NSData *imageData = [NSData dataWithContentsOfFile:imgPath options:NSDataReadingUncached error:&error];
        if (error) {
            NSLog(@"Error retrieving file: %@", error);
            image = [UIImage imageNamed:@"noImage"];
        } else {
            image = [UIImage imageWithData:imageData];
        }
    } else {
        image = [UIImage imageNamed:@"noImage"];
    }
    
    return image;
}


- (void)constructInformationView {
    CGFloat bottomHeight = 60.f;
    CGRect bottomFrame = CGRectMake(0,
                                    CGRectGetHeight(self.bounds) - bottomHeight,
                                    CGRectGetWidth(self.bounds),
                                    bottomHeight);
    _informationView = [[UIView alloc] initWithFrame:bottomFrame];
    _informationView.backgroundColor = [UIColor whiteColor];
    _informationView.clipsToBounds = YES;
    _informationView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_informationView];
    
    [self constructNameLabel];
    [self constructSavingsImageLabelView];
    [self constructDistanceImageLabelView];
}

- (void)constructNameLabel {
    CGFloat leftPadding = 12.f;
    CGFloat topPadding = 17.f;
    CGRect frame = CGRectMake(leftPadding,
                              topPadding,
                              floorf(CGRectGetWidth(_informationView.frame)/2),
                              CGRectGetHeight(_informationView.frame) - topPadding);
    _nameLabel = [[UILabel alloc] initWithFrame:frame];
    _nameLabel.text = [NSString stringWithFormat:@"%@", self.offer.name];
    _nameLabel.font = [UIFont systemFontOfSize:12.0];
    [_informationView addSubview:_nameLabel];
}

- (void)constructSavingsImageLabelView {
    CGFloat rightPadding = 30.f;
    UIImage *image = [UIImage imageNamed:@"savings"];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *price = [formatter stringFromNumber:self.offer.earningsPotential];
    
    
    NSString *text = [NSString stringWithFormat:@"%@", price];
    
    _savingsImageLabelView = [self buildImageLabelViewLeftOf:CGRectGetWidth(_informationView.bounds) - rightPadding
                                                      image:image
                                                       text:text];
    [_informationView addSubview:_savingsImageLabelView];
}

- (void)constructDistanceImageLabelView {
    CGFloat rightPadding = 30.f;
    UIImage *image = [UIImage imageNamed:@"distance"];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    formatter.maximumFractionDigits = 2;
    
    NSString *distance = [formatter stringFromNumber:self.offer.distance];
    
    NSString *text = [NSString stringWithFormat:@"%@ Mi.", distance];
    
    _distanceImageLabelView = [self buildImageLabelViewLeftOf:CGRectGetMinX(_savingsImageLabelView.frame) - rightPadding
                                                       image:image
                                                        text:text];
    [_informationView addSubview:_distanceImageLabelView];
}

- (ImageLabelView *)buildImageLabelViewLeftOf:(CGFloat)x image:(UIImage *)image text:(NSString *)text {
    CGRect frame = CGRectMake(x - ChooseOfferViewImageLabelWidth,
                              0,
                              ChooseOfferViewImageLabelWidth,
                              CGRectGetHeight(_informationView.bounds));
    ImageLabelView *view = [[ImageLabelView alloc] initWithFrame:frame
                                                           image:image
                                                            text:text];
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    return view;
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    if (object == self.offer.image && [keyPath isEqualToString:@"isDownloaded"]) {
        self.imageView.image = [self retrieveImage];
    }
}

@end
