//
//  NSString+Extensions.m
//  WAAD-Test
//
//  Created by Chris Risner on 9/11/13.
//  Copyright (c) 2013 cmr. All rights reserved.
//

#import "NSString+Extensions.h"
#import "NSData+Base64.h"


@implementation NSString (Extensions)

// application/x-form-urlencode encoding
- (NSString *)URLFormEncode {
    // Two step encode: first percent escape everything except spaces, then convert spaces to +
    CFStringRef escapedString = CFURLCreateStringByAddingPercentEscapes( NULL,     // Allocator
        (__bridge CFStringRef)self,            // Original string
            CFSTR(" "),                   // Characters to leave unescaped
            CFSTR("!#$&'()*+,/:;=?@[]%"), // Legal Characters to be escaped
            kCFStringEncodingUTF8 );      // Encoding
    // Replace spaces with +
    CFMutableStringRef encodedString = CFStringCreateMutableCopy( NULL, 0, escapedString );
    CFStringFindAndReplace( encodedString, CFSTR(" "), CFSTR("+"), CFRangeMake( 0, CFStringGetLength( encodedString ) ), kCFCompareCaseInsensitive );
    CFRelease( escapedString );    
    return CFBridgingRelease( encodedString );
}


@end
