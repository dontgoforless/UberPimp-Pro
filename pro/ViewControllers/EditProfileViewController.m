//
//  EditProfileViewController.m
//  pro
//
//  Created by Mathew Vlandys on 12/09/13.
//  Copyright (c) 2013 Mathew Vlandys. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

- (void)loadImages
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"profileImages"]) {        
        NSData  *arrayData = [[NSUserDefaults standardUserDefaults] objectForKey:@"profileImages"];
        NSArray *images    = [NSKeyedUnarchiver unarchiveObjectWithData:arrayData];
        
        int x = 125;
        
        for (UIImage *img in images) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 10, 100, 100)];
            [imgView setImage:img];
            x += 125;
            if (x == 375) {
                [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width + 40, 100)];
            } else if (x > 375) {
                [scrollView setContentSize:CGSizeMake(x, 100)];
            }
            [scrollView addSubview:imgView];
        }
    } else {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            JsonRequest   *jRequest  = [[JsonRequest alloc] initWithUrl:[NSString stringWithFormat:@"http://service.uberpimp.net/prodetails/%@", [[defaults objectForKey:@"login"] objectForKey:@"id"]]];
            NSDictionary   *jsonData = [[jRequest sendSynchronousRequest] objectForKey:@"data"];
            NSMutableArray *images   = [[NSMutableArray alloc] init];
            
            if ([[jsonData objectForKey:@"images"] count] > 0) {
                for (NSDictionary *image in [jsonData objectForKey:@"images"]) {
                    NSString *url   = [[NSString alloc] initWithFormat:@"http://service.uberpimp.net/pro_images/%@", [image objectForKey:@"filename"]];NSLog(@"URL = %@",url);
                    UIImage  *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
                    
                    [images addObject:image];
                }
                
                [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:images] forKey:@"profileImages"];
                [defaults synchronize];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self loadImages];
                });
            }
        });
    }
}

#pragma mark -
#pragma mark UIView Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [scrollView setContentSize:CGSizeMake(320, 100)];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            });

    
    [self loadImages];
}

#pragma mark -
#pragma mark IB Actions

- (IBAction)addImage:(id)sender
{
    imagePickController = [[UIImagePickerController alloc] init];
    imagePickController.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickController.delegate      = self;
    imagePickController.allowsEditing = YES;

    [self presentViewController:imagePickController animated:YES completion:nil];
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        UIImage     *img      = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        JsonRequest *jRequest = [[JsonRequest alloc] initWithUrl:@"http://service.uberpimp.net/proimage" file:UIImagePNGRepresentation(img) filename:@"image.png"];

        dispatch_async(dispatch_get_main_queue(), ^(void){
            [jRequest showWaitAlert];
        });
        
        NSLog(@"%@", info);
                NSLog(@"uploading image");
        [jRequest sendSynchronousRequest];
        NSLog(@"finished uploading");
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *profileImages;
        
        if (![defaults objectForKey:@"profileImages"]) {
            NSArray *images = [[NSArray alloc] initWithObjects:img, nil];
            profileImages = [NSKeyedArchiver archivedDataWithRootObject:images];
        } else {
            NSData  *arrayData = [[NSUserDefaults standardUserDefaults] objectForKey:@"profileImages"];
            NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:arrayData];
            NSMutableArray *images = [[NSMutableArray alloc] initWithArray:array];
            [images addObject:img];
            profileImages = [NSKeyedArchiver archivedDataWithRootObject:images];
        }
        
        [defaults setObject:profileImages forKey:@"profileImages"];
        [defaults synchronize];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [jRequest closeWaitAlert];
            [imagePickController dismissViewControllerAnimated:YES completion:nil];
            [self loadImages];
        });
    });
}

@end
