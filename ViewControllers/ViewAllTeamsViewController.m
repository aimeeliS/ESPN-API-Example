//
//  ViewController.m
//  ESPN
//
//  Created by Luke Geiger on 2/9/13.
//  Copyright (c) 2013 www.lukejgeiger.com. All rights reserved.
//

#import "ViewAllTeamsViewController.h"
#import "Team.h"
#import "NewsTableViewController.h"

@interface ViewAllTeamsViewController ()

@end

@implementation ViewAllTeamsViewController

#pragma mark Life 
/////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
     self.navigationItem.title = @"NBA";
    [self.view addSubview:_tableView];
    [self loadData];

}
//////////////////////////////////////////////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
//////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [teamArray count];
}
//////////////////////////////////////////////////////////////////////////////////////////////////

-(void)updateTableWithArray:(NSMutableArray*)array{

    teamArray = array;
    [_tableView reloadData];
    [self stopAnimating];
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
    Team*team = [teamArray objectAtIndex:indexPath.row];
    cell.textLabel.text = team.name;
    cell.detailTextLabel.text = team.location;
    return cell;
}
//////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark Delegate
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Team*team = [teamArray objectAtIndex:indexPath.row];
    
    NewsTableViewController*nt = [[NewsTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    nt.team = team;
    
    [self.navigationController pushViewController:nt animated:YES];
    
}
//////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark Actions
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////

-(void)beginAnimating{
    activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.frame = CGRectMake(110, 150, 80, 80);
    [self.view addSubview:activity];
    [activity startAnimating];
}
-(void)stopAnimating{
    [activity stopAnimating];
    [activity removeFromSuperview];
}

#pragma mark Load Data
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////

-(void)loadData{
    [self beginAnimating];
    
    
    NSString*espnURL = [NSString stringWithFormat:@"http://api.espn.com/v1/sports/basketball/nba/teams/?%@",kESPNApiKey];
    
    NSURL*url = [[NSURL alloc]initWithString:espnURL];
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:url];
    
    NSMutableURLRequest *requestT = [[NSMutableURLRequest alloc]initWithURL:url];
    [requestT setHTTPMethod:@"GET"];
    
    
    RKHTTPRequestOperation *HTTPRequestOperation = [[RKHTTPRequestOperation alloc]initWithRequest:requestT];
    
    [manager.HTTPClient enqueueHTTPRequestOperation:HTTPRequestOperation];
    
    [HTTPRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* error;
        NSArray *jsonDictionary = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:&error];
        NSArray* cities = [jsonDictionary valueForKeyPath:@"sports.leagues.teams"];
        NSMutableArray*array = [[NSMutableArray alloc]init];
        
        for(NSArray* sport in cities){
            for (NSArray*league in sport) {
                for (NSDictionary*team in league) {
                    
                    Team* addedTeam = [Team teamFromESPN:team];
                    [array addObject:addedTeam];
                }
            }
        }
        [self updateTableWithArray:array];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self stopAnimating];
        
    }];
}
@end
