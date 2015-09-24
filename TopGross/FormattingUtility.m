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

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _dateFormatter = [[TFGRelativeDateFormatter alloc] init];
        _priceFormatter = [[NSNumberFormatter alloc] init];
        [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    
    return self;
}


@end
