//
//  DataManager.m
//  TopGross
//
//  Created by Isaac Schmidt on 9/23/15.
//  Copyright © 2015 Isaac Schmidt. All rights reserved.
//

#import "DataManager.h"
#import "Constants.h"
#import "GrossingApplicationRecord.h"
#import <Mantle/Mantle.h>
#import "NSFileManager+Additions.h"

@interface DataManager ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;

- (NSString *)persistedDataFilePath;

@end

@implementation DataManager

+ (DataManager *)sharedManager
{
    static DataManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[DataManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:TGREndpointURL]];
    }
    
    return self;
}

- (void)fetchTopGrossingApplicationsWithCompletion:(DataManagerOperationResponseBlock)completion
{
    NSString *endpoint = @"us/rss/topgrossingapplications/limit=50/json";
    [[self operationManager] GET:endpoint
                      parameters:[NSDictionary dictionary]
                         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                             
                             NSError *parseError;
                             NSArray *results = [[responseObject objectForKey:@"feed"] objectForKey:@"entry"];
                             
                             NSArray *parsedResults = [MTLJSONAdapter modelsOfClass:[GrossingApplicationRecord class] fromJSONArray:results error:&parseError];
                             if (completion && !parseError) {
                                 
                                 completion(parsedResults, nil);
                                 
                             } else if (parseError) {
                                 
                                 completion(nil, parseError);
                             }
                             
                         } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                             
                             if (completion)
                             {
                                 completion(nil, error);
                             }
                         }];
}

- (NSString *)persistedDataFilePath
{
    return [NSString stringWithFormat:@"%@%@", [NSFileManager documentDirectoryPath], TGRPersistedDataFileName];
}

- (NSArray *)persistedGrossingApplicationRecords
{
    NSArray *persistedRecords = [NSKeyedUnarchiver unarchiveObjectWithFile:[self persistedDataFilePath]];
    if (!persistedRecords)
    {
        persistedRecords = [NSArray array];
    }
    
    return persistedRecords;
}

- (void)persistGrossingApplicationRecord:(GrossingApplicationRecord *)grossingApp
{
    NSArray *previouslyPersisted = [NSKeyedUnarchiver unarchiveObjectWithFile:[self persistedDataFilePath]];
    if (!previouslyPersisted)
    {
        previouslyPersisted = [NSArray array];
    }
    NSMutableArray *newPersisted = [previouslyPersisted mutableCopy];
    [newPersisted addObject:grossingApp];
    [NSKeyedArchiver archiveRootObject:[NSArray arrayWithArray:newPersisted] toFile:[self persistedDataFilePath]];
    
}

@end
