//
//  ChooseOfferView.h
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright © 2015 Jeff. All rights reserved.
//

#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "OfferItem.h"

@interface ChooseOfferView : MDCSwipeToChooseView
@property (nonatomic, strong, readonly) OfferItem *offerItem;

- (instancetype)initWithFrame:(CGRect)frame
                       offerItem:(OfferItem *)offerItem
                      options:(MDCSwipeToChooseViewOptions *)options;
@end
