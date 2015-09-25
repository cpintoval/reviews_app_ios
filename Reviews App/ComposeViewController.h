//
//  ComposeViewController.h
//  Reviews App
//
//  Created by Carlos Pinto on 7/24/15.
//  Copyright (c) 2015 cs2680. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposeViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSString* subject;
    UIImage* uploadImage;
}

@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIImageView *uploadImageView;

- (id) initWithSubject:(NSString *)subj;
- (IBAction)postButtonTapped:(UIButton *)sender;
- (IBAction)imageButtonTapped:(UIButton *)sender;
- (IBAction)cancelButtonTapped:(UIButton *)sender;

@end
