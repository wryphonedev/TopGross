//
//  FormattingUtility.m
//  TopGross
//
//  Created by Isaac Schmidt on 9/23/15.
//  Copyright © 2015 Isaac Schmidt. All rights reserved.
//

#import "FormattingUtility.h"
#import <TFGRelativeDateFormatter/TFGRelativeDateFormatter.h>

@implementation FormattingUtility

+ (FormattingUtility *)sharedUtility
{
    static FormattingUtility *utility;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        utility = [[FormattingUtility alloc] init];
        
    });
    
    return utility;
}

- (NSNumberFormatter *)priceFormatter
{
    if (!_priceFormatter)
    {
        _priceFormatter = [[NSNumberFormatter alloc] init];
        [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    
    return _priceFormatter;
}

- (TFGRelativeDateFormatter *)relativeDateFormatter
{
    if (!_relativeDateFormatter)
    {
        _relativeDateFormatter = [[TFGRelativeDateFormatter alloc] init];
    }
    
    return _relativeDateFormatter;
}

- (NSDateFormatter *)JSONDateFormatter
{
    if (!_JSONDateFormatter)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // Date format vended by Apple: http://unicode.org/reports/tr35/tr35-4.html#Date_Format_Patterns
        // eg, 2012-08-02T01:24:58-07:00
        [formatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ssZ"];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        _JSONDateFormatter = formatter;
    }
    
    return _JSONDateFormatter;
}


@end
