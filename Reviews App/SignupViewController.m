//
//  SignupViewController.m
//  Reviews App
//
//  Created by Carlos Pinto on 7/23/15.
//  Copyright (c) 2015 cs2680. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)createAccount:(UIButton *)sender
{
    NSString* username = self.usernameTextField.text;
    NSString* password = self.passwordTextField.text;
    NSString* email = self.emailTextField.text;
    
    if ([username length] == 0 || [password length] == 0 || [email length] == 0)
    {
        UIAlertView* alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Oops!"
                                  message:@"Please make sure you fill out all the blanks."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        
        [alertView show];
    }
    else
    {
        PFUser* user = [PFUser user];
        user.username = username;
        user.password = password;
        user.email = email;
        
        UIImage* localImage = [UIImage imageNamed:@"defaultUserImage"];
        PFFile* imageFile = [PFFile fileWithData:UIImagePNGRepresentation(localImage)];
        [user setObject:imageFile forKey:@"profileImage"];
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if (!error)
             {
                 // Take the user to the Home Page.
                 AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
                 
                 appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
             }
             else
             {
                 // Show the errorString somewhere and let the user try again.
                 NSString *errorString = [error userInfo][@"error"];
                 
                 UIAlertView* alertView = [[UIAlertView alloc]
                                           initWithTitle:@"Oops!"
                                           message:errorString
                                           delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
                 
                 [alertView show];
             }
         }];

    }
}

@end
