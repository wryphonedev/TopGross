//
//  GrossingApplication.h
//  TopGross
//
//  Created by Isaac Schmidt on 9/23/15.
//  Copyright © 2015 Isaac Schmidt. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GrossingApplication : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSURL *thumbnailImageURL;
@property (nonatomic, copy) NSURL *fullSizeImageURL;
@property (nonatomic, copy) NSString *appDescription;
@property (nonatomic, copy) NSURL *purchaseURL;
@property (nonatomic, copy) NSString *displayPrice;
@property (nonatomic, copy) NSString *publisher;
@property (nonatomic, copy) NSDate *releaseDate;

@end
