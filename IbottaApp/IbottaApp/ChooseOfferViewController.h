//
//  ChooseOfferViewController.h
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright © 2015 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseOfferView.h"

@interface ChooseOfferViewController : UIViewController <MDCSwipeToChooseDelegate>

@property (nonatomic, strong) OfferItem *currentOffer;
@property (nonatomic, strong) ChooseOfferView *frontCardView;
@property (nonatomic, strong) ChooseOfferView *backCardView;

@end
