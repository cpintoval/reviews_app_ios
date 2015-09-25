//
//  ReviewTableViewCell.m
//  Reviews App
//
//  Created by Carlos Pinto on 7/24/15.
//  Copyright (c) 2015 cs2680. All rights reserved.
//

#import "ReviewTableViewCell.h"
#import <Parse/Parse.h>

@implementation ReviewTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setReviewInfo:(PFObject *)review
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss"];
    NSString* dateString = [dateFormatter stringFromDate:[review updatedAt]];
    self.usernameLabel.text = review[@"user"];
    self.reviewTextView.text = review[@"text"];
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

@end
