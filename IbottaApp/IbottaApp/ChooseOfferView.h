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
///@warning Must be set before displaying the view
@property (nonatomic, weak, readonly) Offer *offer;

/**
 * @param frame the frame for this view
 * @param offer the offer for this view
 * @param options for the MDCSwipeToChoose framework
 * @return ChooseOfferView
 */
- (instancetype)initWithFrame:(CGRect)frame
                       offerItem:(Offer *)offer
                      options:(MDCSwipeToChooseViewOptions *)options;
@end
