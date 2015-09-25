//
//  ReviewsTableViewController.m
//  Reviews App
//
//  Created by Carlos Pinto on 7/24/15.
//  Copyright (c) 2015 cs2680. All rights reserved.
//

#import "ReviewsTableViewController.h"
#import <Parse/Parse.h>
#import "ReviewTableViewCell.h"
#import "ComposeViewController.h"
#import "DetailViewController.h"

@interface ReviewsTableViewController ()

@end

static NSString* CellTableIdentifier = @"ReviewCellIndentifier";

@implementation ReviewsTableViewController

- (id) initWithArray:(NSArray *) array ofSubject:(NSString*) subj
{
    self = [super init];
    
    subject = subj;
    reviews = [[NSMutableArray alloc] initWithArray:array];
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = subject;
    
    self.tableView.rowHeight = 150;
    
    UINib* nib = [UINib nibWithNibName:@"ReviewTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeButtonTapped:)];
    
    self.navigationItem.rightBarButtonItem = composeButton;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:206.0/255.0 green:232.0/255.0 blue:246.0/255.0 alpha:1];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    
}

- (void) reloadData
{
    PFQuery* query = [PFQuery queryWithClassName:@"Review"];
    [query whereKey:@"subject" equalTo:subject];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            [reviews removeAllObjects];
            NSArray* reverseArray = [[objects reverseObjectEnumerator] allObjects];
            reviews = [[NSMutableArray alloc] initWithArray:reverseArray];
            
            // Reload table data
            [self.tableView reloadData];
            
            // End the refreshing
            if (self.refreshControl)
            {
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MMM d, h:mm a"];
                NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
                NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor]
                                                                            forKey:NSForegroundColorAttributeName];
                NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
                self.refreshControl.attributedTitle = attributedTitle;
                
                [self.refreshControl endRefreshing];
            }
            
        }
        else
        {
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

- (IBAction)composeButtonTapped:(UIButton *)sender
{
    ComposeViewController* composeVC = [[ComposeViewController alloc] initWithSubject:subject];
    [self.navigationController pushViewController:composeVC animated:true];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([reviews count] != 0)
    {
        self.tableView.backgroundView = nil;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
    }
    else
    {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No reviews yet. Be the first one to leave a review!";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Avenir-BookOblique" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return reviews.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    PFObject* review = reviews[indexPath.row];
    [cell setReviewInfo:review];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController* detailVC = [[DetailViewController alloc] initWithObject:reviews[indexPath.row]];
    [self.navigationController pushViewController:detailVC animated:true];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
