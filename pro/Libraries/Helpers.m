//
//  Helpers.m
//  pro
//
//  Created by Mathew Vlandys on 13/09/13.
//  Copyright (c) 2013 Mathew Vlandys. All rights reserved.
//

#import "Helpers.h"

void showWaitAlert()
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

void closeWaitAlert()
{
    [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
}