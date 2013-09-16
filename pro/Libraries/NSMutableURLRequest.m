//
//  NSMutableURLRequest.m
//
//  Created by Mathew Vlandys on 2/04/13.
//  Copyright (c) 2013 Mathew Vlandys. All rights reserved.
//

#import "NSMutableURLRequest.h"

@implementation NSMutableURLRequest (WebServiceClient)

+ (NSString *) encodeFormPostParameters: (NSDictionary *) parameters {
    NSMutableString *formPostParams = [[NSMutableString alloc] init];
    
    NSEnumerator *keys = [parameters keyEnumerator];
    
    NSString *name = [keys nextObject];
    NSMutableString *encodedValue;
    
    while (nil != name) {        
        if ([[parameters objectForKey:name] isKindOfClass:[NSArray class]]) {
            encodedValue = [[NSMutableString alloc] initWithString:@"["];
            for (NSString *item in [parameters objectForKey:name]) {
                [encodedValue appendString:[NSString stringWithFormat:@"%@,",item]];
            }
            encodedValue = [NSMutableString stringWithString:[encodedValue substringToIndex:[encodedValue length]-1]];
            [encodedValue appendString:@"]"];
            
            [formPostParams appendString: [NSString stringWithFormat:@"%@", name]];
            [formPostParams appendString: @"="];
            [formPostParams appendString: encodedValue];
            //[formPostParams appendString: [NSString stringWithFormat:@"}"]];
        } else {
            encodedValue = (NSMutableString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[parameters objectForKey:name], NULL, CFSTR("=/:"), kCFStringEncodingUTF8));
            //NSString *encodedValue = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(encoding));
            [formPostParams appendString: name];
            [formPostParams appendString: @"="];
            [formPostParams appendString: encodedValue];
        }        
        
        name = [keys nextObject];
        
        if (nil != name) {
            [formPostParams appendString: @"&"];
        }
    }
    
    //NSLog(@"URL: %@",formPostParams);
    
    return formPostParams;
}

- (void) setFormPostParameters: (NSDictionary *) parameters {
    NSString *formPostParams = [NSMutableURLRequest encodeFormPostParameters: parameters];
    
    [self setHTTPBody: [formPostParams dataUsingEncoding: NSUTF8StringEncoding]];
    [self setValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
}

@end