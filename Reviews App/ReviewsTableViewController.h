//
//  ReviewsTableViewController.h
//  Reviews App
//
//  Created by Carlos Pinto on 7/24/15.
//  Copyright (c) 2015 cs2680. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewsTableViewController : UITableViewController
{
    NSString* subject;
    
    NSMutableArray* reviews;
}

- (id) initWithArray:(NSArray *) array ofSubject:(NSString*) subj;


@end
