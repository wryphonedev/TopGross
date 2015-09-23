//
//  GrossingApplication.h
//  TopGross
//
//  Created by Isaac Schmidt on 9/23/15.
//  Copyright © 2015 Isaac Schmidt. All rights reserved.
//

#import "MTLModel.h"

@interface GrossingApplication : MTLModel

@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *appDescription;
@property (nonatomic, copy) NSURL *purchaseURL;
@property (nonatomic, copy) NSString *displayPrice;
@property (nonatomic, copy) NSString *publisher;
@property (nonatomic, copy) NSDate *releaseDate;

@end
