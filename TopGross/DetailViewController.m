//
//  DetailViewController.m
//  TopGross
//
//  Created by Isaac Schmidt on 9/23/15.
//  Copyright © 2015 Isaac Schmidt. All rights reserved.
//

#import "DetailViewController.h"
#import "GrossingApplicationRecord.h"
#import <PINRemoteImage/UIImageView+PINRemoteImage.h>
#import "FormattingUtility.h"
#import <TFGRelativeDateFormatter/TFGRelativeDateFormatter.h>
#import "DataManager.h"

@interface DetailViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *appIconImageView;
@property (nonatomic, weak) IBOutlet UILabel *appNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *publisherLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, weak) IBOutlet UIButton *saveButton;

- (void)populateContent;
- (void)didPressShareButton:(id)sender;
- (IBAction)didPressSaveButton:(id)sender;
- (IBAction)didPressViewInAppStoreButton:(id)sender;

@end

@implementation DetailViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigation];
    [self populateContent];
}

- (void)setupNavigation
{
    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(didPressShareButton:)];
    [[self navigationItem] setRightBarButtonItem:shareButtonItem];
}

#pragma mark - Properties

- (void)setGrossingApplication:(GrossingApplicationRecord *)newGrossingApplication
{
    if (_grossingApplication != newGrossingApplication)
    {
        _grossingApplication = newGrossingApplication;
        [self populateContent];
        [[self saveButton] setEnabled:YES];
    }
}

#pragma mark - Content

- (void)populateContent
{
    if ([self grossingApplication])
    {
        GrossingApplicationRecord *app = [self grossingApplication];
        NSString *title = [app appName];
        [[self navigationItem] setTitle:title];
        [[self appNameLabel] setText:title];
        [[self publisherLabel] setText:[app publisher]];
        [[self descriptionTextView] setText:[app appDescription]];
        [[self appIconImageView] pin_setImageFromURL:[app fullSizeImageURL]];
        
        NSString *dateString = [[[FormattingUtility sharedUtility] relativeDateFormatter] stringForDate:[app releaseDate]];
        [[self dateLabel] setText:dateString];

        double priceDouble = [[app displayPrice] doubleValue];
        if (priceDouble == 0)
        {
            [[self priceLabel] setText:@"Free"];
        }
        else
        {
            NSString *priceString = [[[FormattingUtility sharedUtility] priceFormatter] stringFromNumber:[NSNumber numberWithDouble:priceDouble]];
            [[self priceLabel] setText:priceString];
        }
    }
}

#pragma mark - Actions

- (void)didPressShareButton:(id)sender
{
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[[self grossingAppSummaryForExport]]
                                                                                     applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (IBAction)didPressSaveButton:(id)sender
{
    if ([self grossingApplication])
    {
        [[DataManager sharedManager] persistGrossingApplicationRecord:[self grossingApplication]];
        [[self saveButton] setTitle:@"Saved!" forState:UIControlStateDisabled];
        [[self saveButton] setEnabled:NO];
    }
}

- (IBAction)didPressViewInAppStoreButton:(id)sender
{
    if ([self grossingApplication])
    {
        // TODO: Not sure why it isn't taking this url. Most likely an https thing.
      [[UIApplication sharedApplication] openURL:[[[self grossingApplication] purchaseURL] absoluteURL]];
    }
}

#pragma mark - Sharing

- (NSString *)grossingAppSummaryForExport
{
    GrossingApplicationRecord *app = [self grossingApplication];
    NSString *exportString = [NSString stringWithFormat:@"%@\n%@", [app appName], [app purchaseURL]];
    return exportString;
}

@end
