//
//  OffersViewController.h
//  pro
//
//  Created by Mathew Vlandys on 12/09/13.
//  Copyright (c) 2013 Mathew Vlandys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsonRequest.h"
#import "LocationUpdate.h"
#import "ChatViewController.h"
#import "EditProfileViewController.h"

@interface OffersViewController : UIViewController
{
    IBOutlet UITableView *offersTable;
    LocationUpdate *lu;
    JsonRequest *jRequest;
    UITableViewController *tableViewController;
    NSArray *tableData;
}

- (IBAction)logout:(id)sender;

@end
