//
//  EditProfileViewController.h
//  pro
//
//  Created by Mathew Vlandys on 12/09/13.
//  Copyright (c) 2013 Mathew Vlandys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsonRequest.h"

@interface EditProfileViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImagePickerController *imagePickController;
    IBOutlet UIScrollView *scrollView;
    UIAlertView *waitAlert;
}

- (IBAction)addImage:(id)sender;
- (IBAction)cancel:(id)sender;

@end
