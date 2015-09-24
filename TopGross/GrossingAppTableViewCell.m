//
//  GrossingAppTableViewCell.m
//  TopGross
//
//  Created by Isaac Schmidt on 9/23/15.
//  Copyright © 2015 Isaac Schmidt. All rights reserved.
//

#import "GrossingAppTableViewCell.h"

@implementation GrossingAppTableViewCell

- (void)prepareForReuse
{
    [[self thumbnailImageView] setImage:nil];
    [[self titleLabel] setText:nil];
    [[self descriptionField] setText:nil];
}

@end
