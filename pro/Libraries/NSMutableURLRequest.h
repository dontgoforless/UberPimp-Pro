//
//  NSMutableURLRequest.h
//
//  Created by Mathew Vlandys on 2/04/13.
//  Copyright (c) 2013 Mathew Vlandys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSMutableURLRequest (WebServiceClient)

+ (NSString *) encodeFormPostParameters: (NSDictionary *) parameters;
- (void) setFormPostParameters: (NSDictionary *) parameters;

@end