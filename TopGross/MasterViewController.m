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
#import "GrossingApplicationRecord.h"
#import "GrossingAppTableViewCell.h"
#import <PINRemoteImage/UIImageView+PINRemoteImage.h>

NSString *const GrossingAppCellIdentifier = @"GrossingAppCell";
NSString *const DetailSegueIdentifier = @"DetailSegue";

typedef NS_ENUM(NSInteger, MasterListRecordSource) {
    
    MasterListRecordSourceAppleiTunesAPI,
    MasterListRecordSourceUserSaved
};

@interface MasterViewController ()

@property (nonatomic, strong) NSArray *objects;
@property (nonatomic, assign) MasterListRecordSource recordSource;
@property (nonatomic, weak) UIButton *recordSourceButton;

@end

@implementation MasterViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self tableView] setRowHeight:UITableViewAutomaticDimension];
    [[self tableView] setEstimatedRowHeight:100.00];
    [self setupNavigation];
    
    [self setRecordSource:MasterListRecordSourceAppleiTunesAPI];
    [self loadData];
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)setupNavigation
{
    UIButton *recordSourceButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 44.0f)];
    [recordSourceButton setTitle:@"Saved" forState:UIControlStateNormal];
    [recordSourceButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [recordSourceButton addTarget:self action:@selector(didPressChangeRecordSourceButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sourceButtonItem = [[UIBarButtonItem alloc] initWithCustomView:recordSourceButton];
    [[self navigationItem] setRightBarButtonItem:sourceButtonItem];
    [self setRecordSourceButton:recordSourceButton];
    
    [[self navigationItem] setTitle:@"Top Grossing Apps"];
}

#pragma mark - Mechanics

- (void)loadData
{
    if (self.recordSource == MasterListRecordSourceAppleiTunesAPI)
    {
        __weak MasterViewController *weakSelf = self;
        [[DataManager sharedManager] fetchTopGrossingApplicationsWithCompletion:^(id responseObject, NSError *error) {
           
            if (weakSelf)
            {
                 MasterViewController *strongSelf = weakSelf;
                if (!error)
                {
                    [strongSelf setObjects:responseObject];
                    [[strongSelf tableView] reloadData];
                }
                else
                {
                    [strongSelf handleLoadingError:error];
                }
            }
        }];
    }
    else
    {
        NSArray *saved = [[DataManager sharedManager] persistedGrossingApplicationRecords];
        [self setObjects:saved];
        [[self tableView] reloadData];
    }
}

- (void)handleLoadingError:(NSError *)error
{
    UIAlertController *alertController = [[UIAlertController alloc] init];
    [alertController setTitle:@"Error Loading Content"];
    [alertController setMessage:[error localizedDescription]];
    __weak MasterViewController *weakSelf = self;
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:DetailSegueIdentifier])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        GrossingApplicationRecord *selectedApp = [[self objects] objectAtIndex:[indexPath row]];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setGrossingApplication:selectedApp];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Action

- (void)didPressChangeRecordSourceButton:(id)sender
{
    MasterListRecordSource newSource = (self.recordSource == MasterListRecordSourceAppleiTunesAPI) ? MasterListRecordSourceUserSaved : MasterListRecordSourceAppleiTunesAPI;
    NSString *buttonTitle = (newSource == MasterListRecordSourceAppleiTunesAPI) ? @"Saved" : @"Live";
    [[self recordSourceButton] setTitle:buttonTitle forState:UIControlStateNormal];
    NSString *navigationTitle = (newSource == MasterListRecordSourceAppleiTunesAPI) ? @"Top Grossing" : @"Saved";
    [[self navigationItem] setTitle:navigationTitle];
    _recordSource = newSource;
    [self loadData];
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
    GrossingApplicationRecord *app = [[self objects] objectAtIndex:[indexPath row]];
    [self configureCell:cell forGrossingApp:app];
    return cell;
}

- (void)configureCell:(GrossingAppTableViewCell *)cell forGrossingApp:(GrossingApplicationRecord *)app
{
    [[cell thumbnailImageView] pin_setImageFromURL:[app thumbnailImageURL]];
    [[cell titleLabel] setText:[app appName]];
    [[cell descriptionField] setText:[app appDescription]];
}

@end
