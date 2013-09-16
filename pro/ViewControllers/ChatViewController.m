//
//  ChatViewController.m
//  pro
//
//  Created by Mathew Vlandys on 16/09/13.
//  Copyright (c) 2013 Mathew Vlandys. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

@synthesize offerData;

- (void)refreshChat
{
    JsonRequest  *jRequest = [[JsonRequest alloc] initWithUrl:[NSString stringWithFormat:@"http://service.uberpimp.net/chat/%@", [offerData objectForKey:@"id"]]];
                              
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [jRequest showWaitAlert];
        });
        
        NSDictionary *json = [jRequest sendSynchronousRequest];NSLog(@"%@",json);
        
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
            NSMutableArray *chatArray = [[NSMutableArray alloc] init];
            
            for (NSString *row in jsonData) {
                [chatArray addObject:[jsonData objectForKey:row]];
            }
            
            chatData = chatArray;
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [txtChatEntry setText:@""];
                [chatTable reloadData];
            });
        }
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshChat) name:@"chatReceived" object:nil];
    
    navBar.topItem.title = [offerData objectForKey:@"name"];
    
    [self refreshChat];
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)send:(id)sender
{
    NSDictionary *postData = [[NSDictionary alloc] initWithObjects:@[txtChatEntry.text, [offerData objectForKey:@"id"]]
                                                           forKeys:@[@"chat", @"offer_id"]];
    
    JsonRequest  *jRequest = [[JsonRequest alloc] initWithUrl:@"http://service.uberpimp.net/prochat" postData:postData];
    
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
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [txtChatEntry setText:@""];
                [self refreshChat];
            });
        }
    });

}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [chatData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    NSString *name;
    
    if ([[[chatData objectAtIndex:[indexPath row]] objectForKey:@"user_type"] isEqualToString:@"1"]) {
        name = @"Me";
    } else {
        name = [offerData objectForKey:@"name"];
    }
    
    [cell.textLabel setText:name];
    [cell.detailTextLabel setText:[[chatData objectAtIndex:[indexPath row]] objectForKey:@"chat"]];
    cell.detailTextLabel.numberOfLines = 0;
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -
#pragma mark UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![txtChatEntry.text isEqualToString:@""]) {
        //[self send:self];
    }
    
    //[txtChatEntry setText:@""];
    [textField resignFirstResponder];
    [self viewDown];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	txtChatEntry.frame = CGRectMake(txtChatEntry.frame.origin.x, (txtChatEntry.frame.origin.y - 200.0), txtChatEntry.frame.size.width, txtChatEntry.frame.size.height);
    btnSend.frame = CGRectMake(btnSend.frame.origin.x, (btnSend.frame.origin.y - 200.0), btnSend.frame.size.width, btnSend.frame.size.height);
	[UIView commitAnimations];
}

- (void)viewDown
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	txtChatEntry.frame = CGRectMake(txtChatEntry.frame.origin.x, (txtChatEntry.frame.origin.y + 200.0), txtChatEntry.frame.size.width, txtChatEntry.frame.size.height);
    btnSend.frame = CGRectMake(btnSend.frame.origin.x, (btnSend.frame.origin.y + 200.0), btnSend.frame.size.width, btnSend.frame.size.height);
	[UIView commitAnimations];
    
}

@end
