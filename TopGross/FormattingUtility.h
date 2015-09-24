//
//  FormattingUtility.h
//  TopGross
//
//  Created by Isaac Schmidt on 9/23/15.
//  Copyright © 2015 Isaac Schmidt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFGRelativeDateFormatter;

@interface FormattingUtility : NSObject

@property (nonatomic, strong) NSDateFormatter *JSONDateFormatter;
@property (nonatomic, strong) TFGRelativeDateFormatter *relativeDateFormatter;
@property (nonatomic, strong) NSNumberFormatter *priceFormatter;

+ (FormattingUtility *)sharedUtility;

@end
