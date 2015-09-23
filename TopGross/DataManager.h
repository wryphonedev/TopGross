//
//  DataManager.h
//  TopGross
//
//  Created by Isaac Schmidt on 9/23/15.
//  Copyright © 2015 Isaac Schmidt. All rights reserved.
//

@import Foundation;
#import <AFNetworking/AFNetworking.h>

typedef void (^DataManagerOperationResponseBlock)(id responseObject, NSError *error);

@interface DataManager : NSObject

+ (DataManager *)sharedManager;
- (void)fetchTopGrossingApplicationsWithCompletion:(DataManagerOperationResponseBlock)completion;

@end
