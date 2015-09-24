//
//  DataManager.h
//  TopGross
//
//  Created by Isaac Schmidt on 9/23/15.
//  Copyright © 2015 Isaac Schmidt. All rights reserved.
//

@import Foundation;
#import <AFNetworking/AFNetworking.h>

@class GrossingApplicationRecord;

typedef void (^DataManagerOperationResponseBlock)(id responseObject, NSError *error);

@interface DataManager : NSObject

+ (DataManager *)sharedManager;
- (void)fetchTopGrossingApplicationsWithCompletion:(DataManagerOperationResponseBlock)completion;
- (NSArray *)persistedGrossingApplicationRecords;
- (void)persistGrossingApplicationRecord:(GrossingApplicationRecord *)grossingApp;

@end
