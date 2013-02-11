//
//  ViewController.h
//  ESPN
//
//  Created by Luke Geiger on 2/9/13.
//  Copyright (c) 2013 www.lukejgeiger.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewAllTeamsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate>

{
    
    UITableView*_tableView;;
    NSMutableArray*teamArray;
    UIActivityIndicatorView*activity;
    UISearchDisplayController*searchDisplayController;
    NSArray*searchResults;
    
    NSArray*eastCoastTeams;
    NSArray*westCoastTeams;
    
}

@end
