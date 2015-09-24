//
//  GrossingApplication.m
//  TopGross
//
//  Created by Isaac Schmidt on 9/23/15.
//  Copyright © 2015 Isaac Schmidt. All rights reserved.
//

#import "GrossingApplicationRecord.h"
#import "FormattingUtility.h"

@implementation GrossingApplicationRecord

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"appName": @"im:name.label",
             @"thumbnailImageURL": @"im:image",
             @"fullSizeImageURL": @"im:image",
             @"appDescription": @"summary.label",
             @"purchaseURL" : @"link.attributes.href",
             @"displayPrice": @"im:price.attributes.amount",
             @"publisher": @"im:artist.label",
             @"releaseDate" : @"im:releaseDate.label"
             };
}

+ (NSValueTransformer *)thumbnailImageURLJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        
        // 1 is the index of the medium-sized image returned by Apple.
        return [GrossingApplicationRecord URLStringForImageAtIndex:1 fromValueArray:value];
    }];
}

+ (NSValueTransformer *)fullSizeImageURLJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        
        // 2 is the index of the largest image returned by Apple
        return [GrossingApplicationRecord URLStringForImageAtIndex:2 fromValueArray:value];
    }];
}

+ (NSURL *)URLStringForImageAtIndex:(NSUInteger)index fromValueArray:(id)value
{
    NSURL *imageURL = nil;
    if ([value respondsToSelector:@selector(count)])
    {
        NSArray *valueArray = (NSArray *)value;
        if ([valueArray count] >= index)
        {
            NSDictionary *imageDict = [valueArray objectAtIndex:index];
            NSString *urlString = [imageDict objectForKey:@"label"];
            imageURL = [NSURL URLWithString:urlString];
        }
    }
 
    return imageURL;
}

+ (NSValueTransformer *)purchaseURLJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
       
        NSURL *url = [NSURL URLWithString:value];
        return url;
    }];
}

+ (NSValueTransformer *)releaseDateJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        
        NSDate *date = [[[FormattingUtility sharedUtility] JSONDateFormatter] dateFromString:value];
        return date;
        
    }];
}

@end
