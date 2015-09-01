//
//  ChooseOfferView.h
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright © 2015 Jeff. All rights reserved.
//

#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "Offer+Addon.h"

@interface ChooseOfferView : MDCSwipeToChooseView
@property (nonatomic, weak, readonly) Offer *offer;

- (instancetype)initWithFrame:(CGRect)frame
                       offerItem:(Offer *)offer
                      options:(MDCSwipeToChooseViewOptions *)options;
@end
