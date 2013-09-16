//
//  LoginViewController.h
//
//  Created by Mathew Vlandys on 11/09/13.
//  Copyright (c) 2013 Mathew Vlandys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsonRequest.h"

@interface LoginViewController : UIViewController
{
    IBOutlet UITextField *txtUsername, *txtPassword;
    
    UIAlertView *waitAlert;
}

- (IBAction)login:(id)sender;

@end
