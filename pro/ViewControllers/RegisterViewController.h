//
//  RegisterViewController.h
//  pro
//
//  Created by Mathew Vlandys on 11/09/13.
//  Copyright (c) 2013 Mathew Vlandys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsonRequest.h"

@interface RegisterViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField  *name, *username, *password, *email, *age;
    IBOutlet UITextView   *about;
    IBOutlet UIView       *dimView;
    IBOutlet UIPickerView *sexPicker, *sexualityPicker;
    
    NSMutableArray *sexPickerData, *sexualityPickerData;
    NSString *sexValue, *sexualityValue;
}

- (IBAction)close:(id)sender;
- (IBAction)submitRegistration:(id)sender;
- (IBAction)selectSex:(id)sender;
- (IBAction)selectSexuality:(id)sender;

@end
