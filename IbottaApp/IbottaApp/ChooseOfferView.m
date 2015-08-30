//
//  ChooseOfferView.m
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright © 2015 Jeff. All rights reserved.
//

#import "ChooseOfferView.h"
#import "ImageLabelView.h"

static const CGFloat ChooseOfferViewImageLabelWidth = 42.f;

@interface ChooseOfferView ()
@property (nonatomic, strong) UIView *informationView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) ImageLabelView *savingsImageLabelView;
@property (nonatomic, strong) ImageLabelView *distanceImageLabelView;
@end

@implementation ChooseOfferView

#pragma mark - Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
                       offerItem:(OfferItem *)offerItem
                      options:(MDCSwipeToChooseViewOptions *)options {
    self = [super initWithFrame:frame options:options];
    if (self) {
        _offerItem = offerItem;
        self.imageView.image = _offerItem.image;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleBottomMargin;
        self.imageView.autoresizingMask = self.autoresizingMask;
        
        [self constructInformationView];
    }
    return self;
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
    _nameLabel.text = [NSString stringWithFormat:@"%@", _offerItem.name];
    _nameLabel.font = [UIFont systemFontOfSize:12.0];
    [_informationView addSubview:_nameLabel];
}

- (void)constructSavingsImageLabelView {
    CGFloat rightPadding = 30.f;
    UIImage *image = [UIImage imageNamed:@"savings"];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *price = [formatter stringFromNumber:[NSNumber numberWithDouble:self.offerItem.price ]];
    
    
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
    
    NSString *distance = [formatter stringFromNumber:[NSNumber numberWithDouble:self.offerItem.distance ]];
    
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

@end
