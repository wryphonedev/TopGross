//
//  MasterViewController.h
//  TopGross
//
//  Created by Isaac Schmidt on 9/23/15.
//  Copyright © 2015 Isaac Schmidt. All rights reserved.
//

@import UIKit;
#import <PINRemoteImage/UIImageView+PINRemoteImage.h>

@class DetailViewController;

typedef NS_ENUM(NSInteger, MasterListRecordSource) {
    
    MasterListRecordSourceAppleiTunesAPI,
    MasterListRecordSourceUserSaved
};

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end

