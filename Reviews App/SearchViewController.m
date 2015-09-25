//
//  SearchViewController.m
//  Reviews App
//
//  Created by Carlos Pinto on 7/24/15.
//  Copyright (c) 2015 cs2680. All rights reserved.
//

#import "SearchViewController.h"
#import <Parse/Parse.h>
#import "ReviewsTableViewController.h"
#import "AppDelegate.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

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

- (IBAction)searchButtonTapped:(UIButton *)sender
{
    NSString* queryString = self.queryTextField.text;
    
    if ([queryString length] == 0)
    {
        UIAlertView* alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Oops!"
                                  message:@"Please make sure you type in a query."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        
        [alertView show];
    }
    else
    {
        PFQuery* query = [PFQuery queryWithClassName:@"Review"];
        [query whereKey:@"subject" equalTo:queryString];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
        {
            if (!error)
            {
                NSArray* reversedArray = [[objects reverseObjectEnumerator] allObjects];
                
                // Send the search query and show results.
                ReviewsTableViewController* reviewsTable = [[ReviewsTableViewController alloc] initWithArray:reversedArray ofSubject:queryString];
                [self.navigationController pushViewController:reviewsTable animated:true];
            }
            else
            {
                UIAlertView* alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Oops!"
                                          message:[error localizedDescription]
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                
                [alertView show];
            }
        }];
    }
}
@end
