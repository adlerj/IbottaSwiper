//
//  WelcomeViewController.m
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/31/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.text = @"Welcome to the Ibotta Swiper!\n\n"
                         @"This app will ask to use your location, "
                         @"then find offers at retailers that have "
                         @"locations within 20 miles of you!  Feel free "
                         @"swipe right if you like an offer, and left "
                         @"if you don't care for it.  At any time you "
                         @"can view offers that you have liked by "
                         @"clicking the liked offers button! Have fun!";
    
    self.textView.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:15];
    self.textView.textColor = [UIColor whiteColor];
}

@end
