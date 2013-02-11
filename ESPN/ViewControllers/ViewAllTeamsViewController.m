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
    
    
    UISearchBar*searcher = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 44)];
    searcher.placeholder = @"Search for your NBA Team";
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:searcher contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsTableView.delegate = self;
    searchDisplayController.searchResultsTableView.dataSource = self;
    
    _tableView.tableHeaderView = searcher;
    
    [self loadData];
    
    searchResults = [[NSArray alloc]init];
    
    
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
    if (tableView == searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    }
    else
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
    
    Team*team;
    if (tableView == searchDisplayController.searchResultsTableView) {
        team = [searchResults objectAtIndex:indexPath.row];
    }
    else{
        team = [teamArray objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = team.name;
    cell.detailTextLabel.text = team.location;
    
    cell.opaque = YES;
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    
    UIView*accesView = [[UIView alloc]initWithFrame:CGRectMake(265, 10, 40, 40)];
    accesView.backgroundColor = [UIColor colorWithHexString:team.hexColor];
    accesView.layer.cornerRadius = 2.0;
    accesView.layer.shadowOpacity = 0.6f;
    accesView.layer.shadowRadius = 0.85;
    accesView.layer.shadowColor = [[UIColor colorWithRed:125/255. green:125/255. blue:125/255. alpha:1]CGColor];
    accesView.layer.shadowOffset = CGSizeMake(0, 0);
    [accesView.layer setShadowPath:[[UIBezierPath bezierPathWithRoundedRect:accesView.bounds cornerRadius:2.0]CGPath]];
    
    
    cell.accessoryView = accesView;
    
    
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

#pragma mark Search Display Help
- (void)filterContentForSearchText:(NSString*)searchText
                             scope:(NSString*)scope
{
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@", searchText ];
    NSArray *filtered  = [teamArray filteredArrayUsingPredicate:predicate];
    NSLog(@"%@",filtered);
    searchResults = filtered;
    [searchDisplayController.searchResultsTableView reloadData];
    [_tableView reloadData];
    
}


#pragma mark - UISearchDisplayController delegate methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}



@end
