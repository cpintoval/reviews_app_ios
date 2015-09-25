//
//  ComposeViewController.m
//  Reviews App
//
//  Created by Carlos Pinto on 7/24/15.
//  Copyright (c) 2015 cs2680. All rights reserved.
//

#import "ComposeViewController.h"
#import <Parse/Parse.h>

@interface ComposeViewController ()

@end

@implementation ComposeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.reviewTextView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.reviewTextView.layer.borderWidth = 0.5;
    self.reviewTextView.layer.cornerRadius = 5;
    [self.reviewTextView becomeFirstResponder];
    self.cancelButton.hidden = true;
    self.uploadImageView.hidden = true;
}

- (id) initWithSubject:(NSString *)subj
{
    self = [super init];
    
    subject = subj;
    
    return self;
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

- (IBAction)postButtonTapped:(UIButton *)sender
{
    PFObject* newReview = [PFObject objectWithClassName:@"Review"];
    newReview[@"subject"] = subject;
    newReview[@"text"] = self.reviewTextView.text;
    newReview[@"user"] = [[PFUser currentUser] username];
    
    if (uploadImage != nil)
    {
        PFFile* imageFile = [PFFile fileWithData:UIImagePNGRepresentation(uploadImage)];
        newReview[@"photo"] = imageFile;
    }
    
    [newReview saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (succeeded)
        {
            // The object has been saved.
            [self.navigationController popViewControllerAnimated:true];
        }
        else
        {
            // There was a problem, check error.description
            UIAlertView* alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Oops!"
                                      message:error.description
                                      delegate:nil
                                      cancelButtonTitle:@"Close"
                                      otherButtonTitles:nil];
            
            [alertView show];
        }
    }];
}

- (IBAction)imageButtonTapped:(UIButton *)sender
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Upload Photo"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Take Photo", @"Choose Existing Photo", nil];
    [actionSheet setTag:0];
    [actionSheet showInView:self.view];
}

- (IBAction)cancelButtonTapped:(UIButton *)sender
{
    uploadImage = nil;
    self.uploadImageView.image = nil;
    self.uploadImageView.hidden = true;
    self.cancelButton.hidden = true;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 0)
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Scale down the image
    uploadImage = [self scaleImageWith:pickedImage andSize:CGSizeMake(300, 300)];
    self.uploadImageView.image = uploadImage;
    self.uploadImageView.hidden = false;
    self.cancelButton.hidden = false;
    
    [picker dismissViewControllerAnimated:true completion:nil];
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
