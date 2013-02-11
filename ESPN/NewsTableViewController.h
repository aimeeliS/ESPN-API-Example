//
//  NewTableViewController.h
//  ESPN
//
//  Created by Luke Geiger on 2/10/13.
//  Copyright (c) 2013 www.lukejgeiger.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"
@interface NewsTableViewController : UITableViewController
{
    
    NSMutableArray*newsArray;
    UIActivityIndicatorView*activity;
}

@property (nonatomic, strong)Team*team;
@end
