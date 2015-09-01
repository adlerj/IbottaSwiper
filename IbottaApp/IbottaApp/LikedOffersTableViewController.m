//
//  LikedOffersTableViewController.m
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/31/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import "LikedOffersTableViewController.h"
#import "OfferDetailsViewController.h"
#import "Offer+Addon.h"
#import "OfferCell.h"

@interface LikedOffersTableViewController () <UITableViewDataSource>
@property (nonatomic, weak) NSArray *likedOffers;
@end

@implementation LikedOffersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
}

- (NSArray *)likedOffers
{
    if (!_likedOffers) {
        NSManagedObjectContext *context = [AppDelegate sharedDelegate].managedObjectContext;
        [context performBlockAndWait:^{
            _likedOffers = [Offer fetchAllLikedOffers];
        }];
    }
    return _likedOffers;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.likedOffers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OfferCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OfferCell" forIndexPath:indexPath];
    
    Offer *offer = [self.likedOffers objectAtIndex:indexPath.row];
    cell.label.text = offer.displayName;
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"OfferDetailsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        OfferDetailsViewController *destViewController = segue.destinationViewController;
        
        Offer *offer = [self.likedOffers objectAtIndex:[indexPath row]];
        
        destViewController.text = offer.name;
    }
}


@end
