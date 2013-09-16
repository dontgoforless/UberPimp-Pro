//
//  JsonRequest.m
//
//  Created by Mathew Vlandys on 30/04/13.
//  Copyright (c) 2013 Mathew Vlandys. All rights reserved.
//

#import "JsonRequest.h"

@implementation JsonRequest

- (id)initWithUrl:(NSString*)urlSrting
{
    self = [super init];
    
    if (self) {
        url     = [[NSURL alloc] initWithString:urlSrting];
        request = [[NSMutableURLRequest alloc] initWithURL:url];
        
        [request setAllHTTPHeaderFields:[self getSessionCookies]];
        [request setTimeoutInterval:30];
    }
    
    return self;
}

- (id)initWithUrl:(NSString*)urlSrting postData:(NSDictionary*)postDict
{
    self = [self initWithUrl:urlSrting];
    
    NSString *post       = [NSMutableURLRequest encodeFormPostParameters:postDict];
    NSData   *postData   = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    return self;
}

- (id)initWithUrl:(NSString*)urlSrting file:(NSData*)fileData filename:(NSString*)filename
{
    self = [self initWithUrl:urlSrting];
    
    NSString *boundary      = @"---------------------------14737809831466499882746641449";
    NSString *contentType   = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    NSMutableData *postbody = [NSMutableData data];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[NSData dataWithData:fileData]];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:postbody];
    
    return self;
}

- (NSDictionary*)getSessionCookies
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"service.uberpimp.net", NSHTTPCookieDomain,
                                @"\\", NSHTTPCookiePath,  // IMPORTANT!
                                @"PHPSESSID", NSHTTPCookieName,
                                [defaults objectForKey:@"session_id"], NSHTTPCookieValue,
                                nil];
    
    NSHTTPCookie *cookie  = [NSHTTPCookie cookieWithProperties:properties];
    NSArray      *cookies = [NSArray arrayWithObjects:cookie, nil];
    
    return [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
}

- (NSDictionary*)sendSynchronousRequest
{
    NSDictionary *returnData;

        NSError           *error;
        NSHTTPURLResponse *response;
        NSData   *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

        if (data == NULL) {
            error = [[NSError alloc] initWithDomain:@"UberPimp" code:1 userInfo:[NSDictionary dictionaryWithObject:@"Error Connecting To URL" forKey:@"msg"]];
            [self showError:error];
            return nil;
        }
        
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; NSLog(@"%@",json);
        returnData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if ([error code] > 0) {
            [self showError:error];
        }
    
    return returnData;
}


- (NSURLConnection*)startConnection:(id)delegate
{
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
    [connection start];
    
    return connection;
}

- (void)showError
{    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error"
                          message:[jsonData objectForKey:@"error_msg"]
                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
}

- (void)showError:(NSError*)error
{
    NSString *errorString;
    if ([[error userInfo] objectForKey:NSLocalizedDescriptionKey]) {
        errorString = [[error userInfo] objectForKey:NSLocalizedDescriptionKey];
    } else {
        errorString = @"Connection Error";
        NSLog(@"%@", [error userInfo]);
    }
    
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error"
                          message:errorString
                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
}

- (void)showWaitAlert
{
    waitAlert = [[UIAlertView alloc] initWithTitle:@"Please Wait...."
                                           message:nil
                                          delegate:nil
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];
    [waitAlert show];
    
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    indicator.center = CGPointMake(140, waitAlert.bounds.size.height - 40);
    [indicator startAnimating];
    [waitAlert addSubview:indicator];
}

- (void)closeWaitAlert
{
    [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
}

@end
