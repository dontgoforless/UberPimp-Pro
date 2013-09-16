//
//  RegisterViewController.m
//  pro
//
//  Created by Mathew Vlandys on 11/09/13.
//  Copyright (c) 2013 Mathew Vlandys. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (BOOL)validateForm
{
    UIAlertView *alert;
    
    if ([name.text isEqualToString:@""] || name.text == nil) {
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a value for the Name field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return FALSE;
    }
    
    if ([username.text isEqualToString:@""] || username.text == nil) {
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a value for the Username field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return FALSE;
    }
    
    if ([password.text isEqualToString:@""] || password.text == nil) {
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a value for the Password field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return FALSE;
    }
    
    if ([email.text isEqualToString:@""] || email.text == nil) {
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a value for the Email field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return FALSE;
    }
    
    if ([age.text isEqualToString:@""] || age.text == nil) {
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a value for the Age field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return FALSE;
    }
    
    if ([about.text isEqualToString:@""] || about.text == nil) {
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a value for the About You field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return FALSE;
    }
    
    if ([sexValue isEqualToString:@""] || sexValue == nil) {
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select a Sex" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return FALSE;
    }
    
    if ([sexualityValue isEqualToString:@""] || sexualityValue == nil) {
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select a Sexuality" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return FALSE;
    }
    
    return TRUE;
}

#pragma mark -
#pragma mark ViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [scrollView setContentSize:CGSizeMake(320, 504)];
    
    sexPickerData = [[NSMutableArray alloc] initWithObjects:
                     [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1", @"Male", nil]   forKeys:[NSArray arrayWithObjects:@"value", @"key", nil]],
                     [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"2", @"Female", nil] forKeys:[NSArray arrayWithObjects:@"value", @"key", nil]],
                     [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"3", @"Transexual", nil] forKeys:[NSArray arrayWithObjects:@"value", @"key", nil]],
                     nil];
    [sexPicker reloadAllComponents];
    
    sexualityPickerData = [[NSMutableArray alloc] initWithObjects:
                           [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1", @"Straight", nil] forKeys:[NSArray arrayWithObjects:@"value", @"key", nil]],
                           [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"2", @"Homosexual", nil] forKeys:[NSArray arrayWithObjects:@"value", @"key", nil]],
                           [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"2", @"Bisexual", nil] forKeys:[NSArray arrayWithObjects:@"value", @"key", nil]],
                           nil];
    [sexualityPicker reloadAllComponents];
}

#pragma mark -
#pragma mark IB Actions

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submitRegistration:(id)sender
{
    if ([self validateForm]) {
        NSDictionary  *postData = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:name.text, username.text, password.text, email.text, age.text, about.text, sexValue, sexualityValue, nil]
                                                                forKeys:[NSArray arrayWithObjects:@"name", @"username", @"password", @"email", @"age", @"about", @"sex", @"sexuality", nil]];
        
        JsonRequest  *jRequest = [[JsonRequest alloc] initWithUrl:@"http://service.uberpimp.net/register" postData:postData];
        NSDictionary *json = [jRequest sendSynchronousRequest];
        
        NSString *error =  [NSString stringWithFormat:@"%@",[json objectForKey:@"error"]];
        
        if (![error isEqualToString:@"0"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[json objectForKey:@"error_msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Please log in with your username and password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (IBAction)selectSex:(id)sender
{
    for (id view in [scrollView subviews]) {
        if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]]) {
            [view resignFirstResponder];
        }
    }
    
    [scrollView setContentOffset:CGPointMake(0, 0)];
    
    [UIView animateWithDuration:0.3 animations:^{
        [dimView setAlpha:0.8];
        [sexPicker setAlpha:1.0];
    }];
    
    [scrollView setScrollEnabled:FALSE];
}

- (IBAction)selectSexuality:(id)sender
{
    for (id view in [scrollView subviews]) {
        if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]]) {
            [view resignFirstResponder];
        }
    }
    
    [scrollView setContentOffset:CGPointMake(0, 0)];
    
    [UIView animateWithDuration:0.3 animations:^{
        [dimView setAlpha:0.8];
        [sexualityPicker setAlpha:1.0];
    }];
    
    [scrollView setScrollEnabled:FALSE];

}

#pragma mark -
#pragma mark UIPickerView Datasource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == sexPicker) {
        return [sexPickerData count];
    }
    
    if (pickerView == sexualityPicker) {
        return [sexualityPickerData count];
    }
    
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == sexPicker) {
        return [[sexPickerData objectAtIndex:row] objectForKey:@"key"];
    }
    
    if (pickerView == sexualityPicker) {
        return [[sexualityPickerData objectAtIndex:row] objectForKey:@"key"];
    }
    
    return nil;
}

#pragma mark -
#pragma mark UIPickerView Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == sexPicker) {
        sexValue = [[sexPickerData objectAtIndex:row] objectForKey:@"value"];
        [UIView animateWithDuration:0.3 animations:^{
            [dimView setAlpha:0];
            [sexPicker setAlpha:0];
        }];
        [scrollView setScrollEnabled:TRUE];
    }
    
    if (pickerView == sexualityPicker) {
        sexualityValue = [[sexualityPickerData objectAtIndex:row] objectForKey:@"value"];
        [UIView animateWithDuration:0.3 animations:^{
            [dimView setAlpha:0];
            [sexualityPicker setAlpha:0];
        }];
        [scrollView setScrollEnabled:TRUE];
    }
}

#pragma mark -
#pragma mark UITextView Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
