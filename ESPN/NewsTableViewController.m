//
//  NewTableViewController.m
//  ESPN
//
//  Created by Luke Geiger on 2/10/13.
//  Copyright (c) 2013 www.lukejgeiger.com. All rights reserved.
//

#import "NewsTableViewController.h"
#import "Story.h"
#import "Team.h"
#import "WebViewController.h"
@interface NewsTableViewController ()

@end

@implementation NewsTableViewController

#pragma mark Life
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
//////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    newsArray = [[NSMutableArray alloc]init];
    self.navigationItem.title = _team.name;
    
    UIBarButtonItem*web = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(visitWebPage)];
    self.navigationItem.rightBarButtonItem = web;
    [self loadData];
    
}
//////////////////////////////////////////////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Table view data source
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
//////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [newsArray count];
}
//////////////////////////////////////////////////////////////////////////////////////////////////

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 140;
}
//////////////////////////////////////////////////////////////////////////////////////////////////

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    Story*story = [newsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = story.headline;
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.detailTextLabel.text = story.description;
    cell.detailTextLabel.numberOfLines = 5;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    return cell;
}
//////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - Table view delegate
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    Story*story = [newsArray objectAtIndex:indexPath.row];

    WebViewController*web = [[WebViewController alloc]initWithURL:story.storyURL andStory:story];
    web.isModal = NO;
    
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark Load Data
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////

-(void)loadData{
    [self beginAnimating];
    NSString*geoURL = [NSString stringWithFormat:@"http://api.espn.com/v1/sports/basketball/nba/teams/%i/news?apikey=7mu988js9jrm5yphx5xktatv",_team.idCode.intValue];
    
    NSURL*url = [[NSURL alloc]initWithString:geoURL];
    
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:url];
    
    NSMutableURLRequest *requestT = [[NSMutableURLRequest alloc]initWithURL:url];
    [requestT setHTTPMethod:@"GET"];
    
    
    RKHTTPRequestOperation *HTTPRequestOperation = [[RKHTTPRequestOperation alloc]initWithRequest:requestT];
    
    [manager.HTTPClient enqueueHTTPRequestOperation:HTTPRequestOperation];
    
    [HTTPRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* error;
        NSArray *jsonDictionary = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:&error];
        NSArray* cities = [jsonDictionary valueForKeyPath:@"headlines"];
        NSMutableArray*array = [[NSMutableArray alloc]init];
        
        for(NSDictionary* story in cities){
            
            Story* addedTeam = [Story storyFromESPN:story];
            [array addObject:addedTeam];

            
        }
        
        [self updateTableWithArray:array];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self stopAnimating];
    }];
}
//////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark actions
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////

-(void)updateTableWithArray:(NSMutableArray*)array{
    
    newsArray = array;
    [self.tableView reloadData];
    [self stopAnimating];
    
}
//////////////////////////////////////////////////////////////////////////////////////////////////

-(void)beginAnimating{
    activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.frame = CGRectMake(110, 150, 80, 80);
    [self.view addSubview:activity];
    [activity startAnimating];
    
    
}
//////////////////////////////////////////////////////////////////////////////////////////////////

-(void)stopAnimating{
    [activity stopAnimating];
    [activity removeFromSuperview];
}
//////////////////////////////////////////////////////////////////////////////////////////////////

-(void)visitWebPage{
    WebViewController*web = [[WebViewController alloc]initWithURL:_team.webURL andTeam:_team];
    web.isModal = YES;
    UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:web];
    [self presentViewController:nav animated:YES completion:nil];
    
}
//////////////////////////////////////////////////////////////////////////////////////////////////


@end
