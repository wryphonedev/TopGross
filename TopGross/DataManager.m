//
//  DataManager.m
//  TopGross
//
//  Created by Isaac Schmidt on 9/23/15.
//  Copyright © 2015 Isaac Schmidt. All rights reserved.
//

#import "DataManager.h"
#import "Constants.h"

@implementation DataManager

- (DataManager *)sharedManager
{
    static DataManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[DataManager alloc] init];
        
    });
    
    return manager;
}

- (void)fetchTopGrossingApplicationsWithCompletion:(DataManagerOperationResponseBlock)completion
{
    
    
}

@end
