//
//  ChatViewController.h
//  pro
//
//  Created by Mathew Vlandys on 16/09/13.
//  Copyright (c) 2013 Mathew Vlandys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsonRequest.h"

@interface ChatViewController : UIViewController
{
    IBOutlet UINavigationBar *navBar;
    IBOutlet UITableView *chatTable;
    IBOutlet UITextField *txtChatEntry;
    IBOutlet UIButton *btnSend;
    
    NSArray *chatData;
}

@property NSDictionary *offerData;

- (IBAction)cancel:(id)sender;
- (IBAction)send:(id)sender;

@end
