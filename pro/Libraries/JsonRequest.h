//
//  JsonRequest.h
//
//  Created by Mathew Vlandys on 30/04/13.
//  Copyright (c) 2013 Mathew Vlandys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableURLRequest.h"
#import "Helpers.h"

@interface JsonRequest : NSObject
{
    NSURL *url;
    NSMutableURLRequest *request;
    NSDictionary *jsonData;
    UIAlertView *waitAlert;
    NSThread *waitThread;
}

- (id)initWithUrl:(NSString*)urlSrting;
- (id)initWithUrl:(NSString*)urlSrting postData:(NSDictionary*)postDict;
- (id)initWithUrl:(NSString*)urlSrting file:(NSData*)fileData filename:(NSString*)filename;

- (NSDictionary*)sendSynchronousRequest;
- (NSURLConnection*)startConnection:(id)delegate;

- (void)showError;
- (void)showWaitAlert;
- (void)closeWaitAlert;

@end
