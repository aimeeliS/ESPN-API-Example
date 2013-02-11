//
//  ViewController.h
//  ESPN
//
//  Created by Luke Geiger on 2/9/13.
//  Copyright (c) 2013 www.lukejgeiger.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewAllTeamsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

{

    UITableView*_tableView;;
    NSMutableArray*teamArray;
    UIActivityIndicatorView*activity;
}

@end
