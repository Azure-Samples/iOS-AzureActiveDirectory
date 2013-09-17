//
//  NSDictionary+Extensions.m
//  WAAD-Test
//
//  Created by Chris Risner on 9/11/13.
//  Copyright (c) 2013 cmr. All rights reserved.
//

#import "NSDictionary+Extensions.h"
#import "NSString+Extensions.h"

@implementation NSDictionary (Extensions)

// Encodes a dictionary consisting of a set of name/values pairs that are strings to www-form-urlencoded
// Returns nil if the dictionary is empty, otherwise the encoded value
- (NSString *)URLFormEncode
{
    __block NSString *parameters = nil;
    
    [self enumerateKeysAndObjectsUsingBlock: ^(id key, id value, BOOL *stop) {
         *stop = NO;
         if ( parameters == nil ) {
             parameters = [NSString stringWithFormat:@"%@=%@",
                           [[((NSString *)key) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] URLFormEncode],
                           [[((NSString *)value) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] URLFormEncode]];
         }
         else {
             parameters = [NSString stringWithFormat:@"%@&%@=%@",
                           parameters,
                           [[((NSString *)key) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] URLFormEncode],
                           [[((NSString *)value) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] URLFormEncode]];
         }
     }];    
    return parameters;
}


@end
