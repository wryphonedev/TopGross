//
//  DetailViewController.m
//  TopGross
//
//  Created by Isaac Schmidt on 9/23/15.
//  Copyright © 2015 Isaac Schmidt. All rights reserved.
//

#import "DetailViewController.h"
#import "GrossingApplication.h"
#import <PINRemoteImage/UIImageView+PINRemoteImage.h>
#import "FormattingUtility.h"
#import <TFGRelativeDateFormatter/TFGRelativeDateFormatter.h>

@interface DetailViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *appIconImageView;
@property (nonatomic, weak) IBOutlet UILabel *appNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *publisherLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UITextView *descriptionTextView;

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
    [self populateContent];
}

- (void)setupNavigation
{
    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(didPressShareButton:)];
    [[self navigationItem] setRightBarButtonItem:shareButtonItem];
}

#pragma mark - Properties

- (void)setGrossingApplication:(GrossingApplication *)newGrossingApplication
{
    if (_grossingApplication != newGrossingApplication)
    {
        _grossingApplication = newGrossingApplication;
        [self populateContent];
    }
}

#pragma mark - Content

- (void)populateContent
{
    if ([self grossingApplication])
    {
        GrossingApplication *app = [self grossingApplication];
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
    
}

- (IBAction)didPressSaveButton:(id)sender
{
    
}

- (IBAction)didPressViewInAppStoreButton:(id)sender
{
    
}

@end
