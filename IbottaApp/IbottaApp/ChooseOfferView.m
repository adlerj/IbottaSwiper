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
@property (nonatomic) BOOL usingKVO;
@end

@implementation ChooseOfferView

#pragma mark - Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
                       offerItem:(Offer *)offer
                      options:(MDCSwipeToChooseViewOptions *)options {
    self = [super initWithFrame:frame options:options];
    if (self) {
        self.offer = offer;
        CGRect frame = self.imageView.frame;
        frame.size.height -= 60.f;
        self.imageView.frame = frame;
        self.imageView.backgroundColor = [UIColor blackColor];
        self.imageView.contentMode = UIViewContentModeCenter;
        
        UIImage *image = [self.offer.image retrieveImageSizedToFrame:frame];
        if (image) {
            self.imageView.image = image;
        } else {
            self.imageView.image = [UIImage animatedImageNamed:@"loading-" duration:2.0f];
        }
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleBottomMargin;
        self.imageView.autoresizingMask = self.autoresizingMask;
        
        [self constructInformationView];
        
        if (![self.offer.image.isDownloaded boolValue]) {
            self.usingKVO = YES;
            [self.offer.image addObserver:self forKeyPath:@"isDownloaded" options:NSKeyValueObservingOptionNew context:nil];
        } else {
            self.usingKVO = NO;
        }
    }
    return self;
}

- (void)dealloc
{
    if (self.usingKVO) {
        [self.offer.image removeObserver:self forKeyPath:@"isDownloaded"];
    }
}

#pragma mark - Internal Methods

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
    
    [self constructSavingsImageLabelView];
    [self constructDistanceImageLabelView];
}

- (void)constructSavingsImageLabelView {
    CGFloat rightPadding = 50.f;
    UIImage *image = [UIImage imageNamed:@"savings"];
    
    NSString *text = [self.offer displayPotentialEarnings];
    
    _savingsImageLabelView = [self buildImageLabelViewLeftOf:CGRectGetWidth(_informationView.bounds) - rightPadding
                                                      image:image
                                                       text:text];
    [_informationView addSubview:_savingsImageLabelView];
}

- (void)constructDistanceImageLabelView {
    CGFloat leftPadding = 50.f;
    UIImage *image = [UIImage imageNamed:@"distance"];
    
    NSString *text = [self.offer displayDistance];
    
    _distanceImageLabelView = [self buildImageLabelViewRightOf:leftPadding
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

- (ImageLabelView *)buildImageLabelViewRightOf:(CGFloat)x image:(UIImage *)image text:(NSString *)text {
    CGRect frame = CGRectMake(x,
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
        self.imageView.image = [self.offer.image retrieveImageSizedToFrame:self.imageView.frame];
        [self.offer.image removeObserver:self forKeyPath:@"isDownloaded"];
        self.usingKVO = NO;
    }
}

@end
