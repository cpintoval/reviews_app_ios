//
//  DetailViewController.h
//  Reviews App
//
//  Created by Carlos Pinto on 7/24/15.
//  Copyright (c) 2015 cs2680. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DetailViewController : UIViewController <UIAlertViewDelegate>
{
    PFObject* review;
}
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

- (IBAction)deleteButtonPressed:(UIButton *)sender;
- (IBAction)updateButtonPressed:(UIButton *)sender;
- (id)initWithObject:(PFObject *)object;

@end
