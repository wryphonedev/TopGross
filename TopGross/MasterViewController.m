//
//  MasterViewController.m
//  TopGross
//
//  Created by Isaac Schmidt on 9/23/15.
//  Copyright © 2015 Isaac Schmidt. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "DataManager.h"
#import "GrossingApplication.h"
#import "GrossingAppTableViewCell.h"
#import <PINRemoteImage/UIImageView+PINRemoteImage.h>

NSString *const GrossingAppCellIdentifier = @"GrossingAppCell";

@interface MasterViewController ()

@property NSMutableArray *objects;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[DataManager sharedManager] fetchTopGrossingApplicationsWithCompletion:^(id responseObject, NSError *error) {
        
        [self setObjects:responseObject];
        [[self tableView] reloadData];
    }];
    

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GrossingAppTableViewCell *cell = (GrossingAppTableViewCell *)[tableView dequeueReusableCellWithIdentifier:GrossingAppCellIdentifier forIndexPath:indexPath];
    GrossingApplication *app = [[self objects] objectAtIndex:[indexPath row]];
    [self configureCell:cell forGrossingApp:app];
    return cell;
}


- (void)configureCell:(GrossingAppTableViewCell *)cell forGrossingApp:(GrossingApplication *)app
{
    [[cell thumbnailImageView] pin_setImageFromURL:[app thumbnailImageURL]];
    [[cell titleLabel] setText:[app appName]];
    [[cell descriptionField] setText:[app appDescription]];
}

@end
