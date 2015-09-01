//
//  LikedOffersTableViewController.m
//  IbottaApp
//
//  Created by Jeffrey Adler on 8/31/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

#import "LikedOffersTableViewController.h"
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
