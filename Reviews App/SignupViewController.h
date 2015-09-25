//
//  SignupViewController.h
//  Reviews App
//
//  Created by Carlos Pinto on 7/23/15.
//  Copyright (c) 2015 cs2680. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

- (IBAction)createAccount:(UIButton *)sender;

@end
