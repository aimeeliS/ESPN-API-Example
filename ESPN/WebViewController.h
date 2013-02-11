//
//  WebViewController.h
//  ESPN
//
//  Created by Luke Geiger on 2/10/13.
//  Copyright (c) 2013 www.lukejgeiger.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"
#import "Story.h"
@interface WebViewController : UIViewController
{
    
    NSString*_url;
    Team*_team;
    Story*_story;
}
@property BOOL isModal;

-(id)initWithURL:(NSString *)url andTeam:(Team*)team;
-(id)initWithURL:(NSString *)url andStory:(Story*)story;

@end
