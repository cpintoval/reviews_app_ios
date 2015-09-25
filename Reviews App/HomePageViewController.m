//
//  HomePageViewController.m
//  Reviews App
//
//  Created by Carlos Pinto on 7/23/15.
//  Copyright (c) 2015 cs2680. All rights reserved.
//

#import "HomePageViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PFUser* user = [PFUser currentUser];
    self.usernameLabel.text = [user username];
    self.emailLabel.text = [user email];
    
    PFFile* profileImage = user[@"profileImage"];
    [profileImage getDataInBackgroundWithBlock:^(NSData* imageData, NSError* error)
    {
        if (!error)
        {
            UIImage* image = [[UIImage alloc] initWithData:imageData];
            self.userImageView.image = image;
            self.userImageView.layer.cornerRadius = image.size.width / 2;
            self.userImageView.layer.masksToBounds = true;
        }
    }];
    
    PFQuery* query = [PFQuery queryWithClassName:@"Review"];
    [query whereKey:@"user" equalTo:[user username]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            self.reviewsLabel.text = [NSString stringWithFormat:@"%d", objects.count];
        }
        else
        {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void) reloadView
{
    PFUser* user = [PFUser currentUser];
    self.usernameLabel.text = [user username];
    self.emailLabel.text = [user email];
    
    PFFile* profileImage = user[@"profileImage"];
    [profileImage getDataInBackgroundWithBlock:^(NSData* imageData, NSError* error)
     {
         if (!error)
         {
             UIImage* image = [[UIImage alloc] initWithData:imageData];
             self.userImageView.image = image;
         }
     }];
    
    PFQuery* query = [PFQuery queryWithClassName:@"Review"];
    [query whereKey:@"user" equalTo:[user username]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             self.reviewsLabel.text = [NSString stringWithFormat:@"%d", objects.count];
         }
         else
         {
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)settingsTapped:(UIButton *)sender
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Settings"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Change Profile Picture", @"Delete Profile Picture", @"Log Out", nil];
    [actionSheet setTag:0];
    [actionSheet showInView:self.view];
}


- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 0)
    {
        if (buttonIndex == 0)
        {
            // Change Profile Picture.
            UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:@"Change Profile Picture"
                                          delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:@"Take Photo", @"Choose Existing Photo", nil];
            [actionSheet setTag:1];
            [actionSheet showInView:self.view];
            
        }
        else if (buttonIndex == 1)
        {
            // Delete Profile Picture.
            UIAlertView* alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Delete Profile Picture"
                                      message:@"Are you sure?"
                                      delegate:self
                                      cancelButtonTitle:@"No"
                                      otherButtonTitles:@"Yes", nil];
            [alertView setTag:1];
            [alertView show];
        }
        else if (buttonIndex == 2)
        {
            // Log Out.
            
            UIAlertView* alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Log Out"
                                      message:@"Are you sure?"
                                      delegate:self
                                      cancelButtonTitle:@"No"
                                      otherButtonTitles:@"Yes", nil];
            [alertView setTag:2];
            [alertView show];
        }
    }
    else if (actionSheet.tag == 1)
    {
        if (buttonIndex == 0)
        {
            // Take Photo
        }
        else if(buttonIndex == 1)
        {
            // Choose Existing Photo
            UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:true completion:nil];
        }
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        // Delete Profile Picture AlertView
        if (buttonIndex == 1)
        {
            PFUser* user = [PFUser currentUser];
            UIImage* localImage = [UIImage imageNamed:@"defaultUserImage"];
            PFFile* imageFile = [PFFile fileWithData:UIImagePNGRepresentation(localImage)];
            [user setObject:imageFile forKey:@"profileImage"];
            [user saveInBackground];
            [self reloadView];
        }
    }
    else if (alertView.tag == 2)
    {
        // Log Out AlertView
        if (buttonIndex == 1)
        {
            [PFUser logOut];
            
            AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
            
            UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
            
            appDelegateTemp.window.rootViewController = rootController;
            
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Scale down the image
    UIImage* scaledImage = [self scaleImageWith:pickedImage andSize:CGSizeMake(100, 100)];
    
    PFFile* imageFile = [PFFile fileWithData:UIImagePNGRepresentation(scaledImage)];
    PFUser* currentUser = [PFUser currentUser];
    [currentUser setObject:imageFile forKey:@"profileImage"];
    [currentUser saveInBackground];
    [picker dismissViewControllerAnimated:true completion:nil];
    [self reloadView];
}

- (UIImage *) scaleImageWith:(UIImage *)image andSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
