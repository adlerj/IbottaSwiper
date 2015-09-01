//
//  ChooseOfferViewController.m
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/26/15.
//  Copyright © 2015 Jeff. All rights reserved.
//

#import "ChooseOfferViewController.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "Location+Addon.h"
#import "Retailer+Addon.h"
#import "Offer+Addon.h"
#import "JADLocationManager.h"

static const CGFloat ChooseOfferButtonHorizontalPadding = 80.f;
static const CGFloat ChooseOfferButtonVerticalPadding = 20.f;

@interface ChooseOfferViewController ()
@property (nonatomic, strong) NSMutableArray *offerItems;
@property (nonatomic, strong) NSOperationQueue *imgDownloadOperationQueue;
@end

@implementation ChooseOfferViewController

#pragma mark - Object Lifecycle

- (NSMutableArray *)offerItems
{
    if (!_offerItems) {
        _offerItems = [NSMutableArray array];
    }
    
    return _offerItems;
}

#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchMoreOffers];
    
    // Display the first ChoosePersonView in front. Users can swipe to indicate
    // whether they like or dislike the person displayed.
    self.frontCardView = [self popOfferViewWithFrame:[self frontCardViewFrame]];
    [self.view addSubview:self.frontCardView];
    
    // Display the second ChoosePersonView in back. This view controller uses
    // the MDCSwipeToChooseDelegate protocol methods to update the front and
    // back views after each user swipe.
    self.backCardView = [self popOfferViewWithFrame:[self backCardViewFrame]];
    [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
    
    // Add buttons to programmatically swipe the view left or right.
    // See the `nopeFrontCardView` and `likeFrontCardView` methods.
    [self constructNopeButton];
    [self constructLikedButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationsUpdated:) name:kDistancesUpdatedNotification object:nil];
}

- (NSOperationQueue *)imgDownloadOperationQueue
{
    if (!_imgDownloadOperationQueue) {
        self.imgDownloadOperationQueue = [[NSOperationQueue alloc] init];
        self.imgDownloadOperationQueue.maxConcurrentOperationCount = 5;
    }
    
    return _imgDownloadOperationQueue;
}

- (void)fetchMoreOffers
{
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    
    [context performBlockAndWait:^{
        NSArray *closestLocations = [Location fetchClosestLocationsWithUnlikedOffers:10 withinRange:20];
        
        if ([closestLocations count]) {
            
            for (Location *location in closestLocations) {
                NSSet *offers = location.offers;
                
                for (Offer *offer in offers) {
                    if (offer.likedStatus != kLikedStatus_None) {
                        continue;
                    }
                    
                    offer.distance = location.distance;
                    [self.imgDownloadOperationQueue addOperation:[offer createDownloadOperation]];
                    [self.offerItems addObject:offer];
                }
                [context save:nil];
            }
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Nearby Offers"
                                                                           message:@"There are no offers near your location."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)locationsUpdated:(NSNotification*)note
{
    [self fetchMoreOffers];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - MDCSwipeToChooseDelegate Protocol Methods

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"You couldn't decide on %@.", self.currentOffer.displayName);
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
    // and "LIKED" on swipes to the right.
    
    NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
    [context performBlockAndWait:^{
        LikedStatus status = kLikedStatus_None;
        if (direction == MDCSwipeDirectionLeft) {
            status = kLikedStatus_Disliked;
        } else {
            status = kLikedStatus_Liked;
        }
        
        for (Retailer *retailer in self.currentOffer.retailers) {
            [retailer decrementUnlikedOffers];
        }
        
        [self.currentOffer setLikedStatus:status];
        [context save:nil];
    }];
    
    // MDCSwipeToChooseView removes the view from the view hierarchy
    // after it is swiped (this behavior can be customized via the
    // MDCSwipeOptions class). Since the front card view is gone, we
    // move the back card to the front, and create a new back card.
    self.frontCardView = self.backCardView;
    if ((self.backCardView = [self popOfferViewWithFrame:[self backCardViewFrame]])) {
        // Fade the back card into view.
        self.backCardView.alpha = 0.f;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backCardView.alpha = 1.f;
                         } completion:nil];
    }
}

#pragma mark - Internal Methods

- (void)setFrontCardView:(ChooseOfferView *)frontCardView {
    // Keep track of the person currently being chosen.
    // Quick and dirty, just for the purposes of this sample app.
    _frontCardView = frontCardView;
    self.currentOffer = frontCardView.offer;
}

- (ChooseOfferView *)popOfferViewWithFrame:(CGRect)frame {
    if ([self.offerItems count] == 0) {
        return nil;
    }
    
    // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
    // Each take an "options" argument. Here, we specify the view controller as
    // a delegate, and provide a custom callback that moves the back card view
    // based on how far the user has panned the front card view.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 160.f;
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y - (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
    };
    
    // Create a personView with the top person in the people array, then pop
    // that person off the stack.
    ChooseOfferView *offerView = [[ChooseOfferView alloc] initWithFrame:frame
                                                                    offerItem:self.offerItems[0]
                                                                   options:options];
    [self.offerItems removeObjectAtIndex:0];
    
    if ([self.offerItems count] < 10) {
        [self fetchMoreOffers];
    }
    
    return offerView;
}

#pragma mark View Contruction

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 60.f;
    CGFloat bottomPadding = 200.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.view.frame) - bottomPadding);
}

- (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y + 10.f,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}

// Create and add the "nope" button.
- (void)constructNopeButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"nope"];
    button.frame = CGRectMake(ChooseOfferButtonHorizontalPadding,
                              CGRectGetMaxY(self.backCardView.frame) + ChooseOfferButtonVerticalPadding,
                              image.size.width,
                              image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithRed:247.f/255.f
                                         green:91.f/255.f
                                          blue:37.f/255.f
                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(nopeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

// Create and add the "like" button.
- (void)constructLikedButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"liked"];
    button.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - image.size.width - ChooseOfferButtonHorizontalPadding,
                              CGRectGetMaxY(self.backCardView.frame) + ChooseOfferButtonVerticalPadding,
                              image.size.width,
                              image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithRed:29.f/255.f
                                         green:245.f/255.f
                                          blue:106.f/255.f
                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(likeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark Control Events

// Programmatically "nopes" the front card view.
- (void)nopeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
}

// Programmatically "likes" the front card view.
- (void)likeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
}

@end
