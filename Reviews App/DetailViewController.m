//
//  DetailViewController.m
//  Reviews App
//
//  Created by Carlos Pinto on 7/24/15.
//  Copyright (c) 2015 cs2680. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString* currentUsername = [[PFUser currentUser] username];
    NSString* reviewUsername = review[@"user"];
    
    if (![currentUsername isEqualToString:reviewUsername])
    {
        self.deleteButton.hidden = true;
        self.updateButton.hidden = true;
        self.lineView.hidden = true;
    }
    
    self.usernameLabel.text = review[@"user"];
    self.reviewTextView.text = review[@"text"];
    self.title = review[@"subject"];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss"];
    NSString* dateString = [dateFormatter stringFromDate:[review updatedAt]];
    self.dateLabel.text = dateString;
    
    PFFile* imageFile = review[@"photo"];
    if (imageFile)
    {
        [imageFile getDataInBackgroundWithBlock:^(NSData* imageData, NSError* error)
         {
             if (!error)
             {
                 UIImage* image = [[UIImage alloc] initWithData:imageData];
                 self.photoImageView.image = image;
                 self.photoImageView.hidden = false;
             }
         }];
    }
    else
    {
        self.photoImageView.hidden = true;
    }
    
    PFQuery* query = [PFUser query];
    [query whereKey:@"username" equalTo:review[@"user"]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject* object, NSError* error)
     {
         PFUser* user = (PFUser *) object;
         if (user)
         {
             PFFile* profileImage = user[@"profileImage"];
             [profileImage getDataInBackgroundWithBlock:^(NSData* imageData, NSError* error)
              {
                  if (!error)
                  {
                      UIImage* image = [[UIImage alloc] initWithData:imageData];
                      self.userImageView.image = image;
                      self.userImageView.layer.cornerRadius = image.size.width / 4;
                      self.userImageView.layer.masksToBounds = true;
                  }
              }];
         }
     }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithObject:(PFObject *)object
{
    self = [super init];
    
    review = object;
    
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)deleteButtonPressed:(UIButton *)sender
{
    UIAlertView* alertView = [[UIAlertView alloc]
                              initWithTitle:@"Delete"
                              message:@"Are you sure?"
                              delegate:self
                              cancelButtonTitle:@"No"
                              otherButtonTitles:@"Yes", nil];
    
    [alertView show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [review deleteInBackground];
        [self.navigationController popViewControllerAnimated:true];
    }
}

- (IBAction)updateButtonPressed:(UIButton *)sender
{
    NSString* reviewText = self.reviewTextView.text;
    
    if ([reviewText length] == 0)
    {
        UIAlertView* alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Oops!"
                                  message:@"Please make sure you fill out your review before updating."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        
        [alertView show];
    }
    else
    {
        review[@"text"] = reviewText;
        [review saveInBackground];
        [self.navigationController popViewControllerAnimated:true];
    }
}
@end
