//
//  OfferDetailsViewController.h
//  IbottaApp
//
//  Created by Jeffrey Adler on 9/1/15.
//  Copyright © 2015 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Offer.h"

@interface OfferDetailsViewController : UIViewController

///@warning Must be set before displaying the view
@property (nonatomic, weak) Offer *offer;
@end
