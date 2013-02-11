//
//  Team.m
//  ESPN
//
//  Created by Luke Geiger on 2/9/13.
//  Copyright (c) 2013 www.lukejgeiger.com. All rights reserved.
//

#import "Team.h"

@implementation Team

+ (Team*)teamFromESPN:(NSDictionary*)dict{
    
    Team*team = [[Team alloc]init];
    team.name = [dict valueForKey:@"name"];
    team.location = [dict valueForKey:@"location"];
    team.abv = [dict valueForKey:@"abbreviation"];
    
    team.linksArray = [dict valueForKey:@"links"];
    team.webDictionary = [team.linksArray valueForKey:@"mobile"];
    team.teamDictionary = [team.webDictionary valueForKey:@"teams"];
    team.webURL = [team.teamDictionary valueForKey:@"href"];
    team.idCode = [NSNumber numberWithInt:[[dict valueForKey:@"id"]intValue]];
    team.newsURL = [NSString stringWithFormat:@"http://api.espn.com/v1/sports/basketball/nba/teams/%i/news?%@",team.idCode.intValue,kESPNApiKey];
    team.notesURL = [NSString stringWithFormat:@"http://api.espn.com/v1/sports/basketball/nba/teams/%i/notes/?%@",team.idCode.intValue,kESPNApiKey];

    return team;
}


@end
