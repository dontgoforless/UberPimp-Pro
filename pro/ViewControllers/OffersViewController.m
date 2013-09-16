//
//  OffersViewController.m
//  pro
//
//  Created by Mathew Vlandys on 12/09/13.
//  Copyright (c) 2013 Mathew Vlandys. All rights reserved.
//

#import "OffersViewController.h"

@interface OffersViewController ()

@end

@implementation OffersViewController

- (void)refreshOffers
{
    jRequest = [[JsonRequest alloc] initWithUrl:@"http://service.uberpimp.net/myoffers"];

    [jRequest startConnection:self];
}

#pragma mark -
#pragma mark IB Actions

- (IBAction)editProfile:(id)sender
{
    [self performSegueWithIdentifier:@"editProfile" sender:nil];
}

- (IBAction)logout:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:@"login"];
    [defaults removeObjectForKey:@"profileImages"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSError         *error;
    NSDictionary    *jsonData  = [[NSJSONSerialization JSONObjectWithData:data options:0 error:&error] objectForKey:@"data"];
    
    if ([error code]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey]
                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    } else {
        NSMutableArray *jsonArray = [[NSMutableArray alloc] init];
        if ([jsonData count] > 0) {
            for (NSString *row in [jsonData allKeys]) {
                [jsonArray addObject:[jsonData objectForKey:row]];
            }
            
            tableData = [[NSArray alloc] initWithArray:jsonArray];
            [offersTable reloadData];
        }
        [tableViewController.refreshControl endRefreshing];
    }
}

#pragma mark -
#pragma mark UIView Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOffers) name:@"notificationReceived" object:nil];
    
    lu = [[LocationUpdate alloc] init];
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:lu
                                   selector:@selector(updateLocation)
                                   userInfo:nil
                                    repeats:YES];

    
    tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = offersTable;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshOffers) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = refreshControl;
    
    [self refreshOffers];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    NSString *seeker_name = [[tableData objectAtIndex:[indexPath row]] objectForKey:@"name"];
    NSString *offer       = [NSString stringWithFormat:@"$%@",[[tableData objectAtIndex:[indexPath row]] objectForKey:@"offer"]];
    
    [cell.textLabel setText:seeker_name];
    [cell.detailTextLabel setText:offer];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"chat" sender:[tableData objectAtIndex:[indexPath row]]];
}

#pragma mark -
#pragma mark UIStoryboardSegue Delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"chat"]) {
        ChatViewController *cvc = segue.destinationViewController;
        cvc.offerData = sender;
    }
    
    
}

@end
