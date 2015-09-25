//
//  SearchViewController.h
//  Reviews App
//
//  Created by Carlos Pinto on 7/24/15.
//  Copyright (c) 2015 cs2680. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *queryTextField;

- (IBAction)searchButtonTapped:(UIButton *)sender;

@end
