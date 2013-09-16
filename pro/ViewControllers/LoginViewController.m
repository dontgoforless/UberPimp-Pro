//
//  LoginViewController.m
//
//  Created by Mathew Vlandys on 11/09/13.
//  Copyright (c) 2013 Mathew Vlandys. All rights reserved.
//

#import "LoginViewController.h"
#import "Helpers.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (BOOL)validateForm
{
    UIAlertView *alert;
    
    if ([txtUsername.text isEqualToString:@""] || txtUsername.text == NULL) {
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a value for the Name field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return FALSE;
    }
    
    if ([txtPassword.text isEqualToString:@""] || txtPassword.text == NULL) {
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a value for the Password field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return FALSE;
    }
    
    return TRUE;
}

- (void)loginWithUsername:(NSString*)username password:(NSString*)password
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
    if (token == nil) {
        token = @"";
    }
    
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:username, password, token , nil]
                                                            forKeys:[NSArray arrayWithObjects:@"username", @"password", @"iphone", nil]];
    
    JsonRequest  *jRequest = [[JsonRequest alloc] initWithUrl:@"http://service.uberpimp.net/login" postData:postData];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [jRequest showWaitAlert];
        });
        
        NSDictionary *json = [jRequest sendSynchronousRequest];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [jRequest closeWaitAlert];
        });
        
        if (json == NULL) {
            return;
        }
        
        if ([[json objectForKey:@"error"] intValue] > 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[json objectForKey:@"error_msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            NSDictionary *jsonData = [json objectForKey:@"data"];
            
            [postData setObject:[jsonData objectForKey:@"user_id"] forKey:@"id"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:postData forKey:@"login"];
            [defaults synchronize];
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self performSegueWithIdentifier:@"myOffers" sender:nil];
            });
        }
    });
}

#pragma mark -
#pragma mark ViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"login"]) {
        NSDictionary *loginData = [defaults objectForKey:@"login"];
        [self loginWithUsername:[loginData objectForKey:@"username"] password:[loginData objectForKey:@"password"]];
    }

}

#pragma mark -
#pragma mark IB Actions

- (IBAction)login:(id)sender
{
    if ([self validateForm]) {
        [self loginWithUsername:txtUsername.text password:txtPassword.text];
    }
}

@end
