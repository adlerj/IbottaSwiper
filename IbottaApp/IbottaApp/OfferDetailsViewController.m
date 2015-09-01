//
//  OfferDetailsViewController.m
//  IbottaApp
//
//  Created by Jeffrey Adler on 9/1/15.
//  Copyright © 2015 Jeff. All rights reserved.
//

#import "OfferDetailsViewController.h"

@interface OfferDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation OfferDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.label.text = self.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
