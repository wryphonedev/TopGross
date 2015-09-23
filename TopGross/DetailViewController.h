//
//  DetailViewController.h
//  TopGross
//
//  Created by Isaac Schmidt on 9/23/15.
//  Copyright © 2015 Isaac Schmidt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

