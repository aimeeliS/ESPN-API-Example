//
//  WebViewController.m
//  ESPN
//
//  Created by Luke Geiger on 2/10/13.
//  Copyright (c) 2013 www.lukejgeiger.com. All rights reserved.
//

#import "WebViewController.h"
#import "Team.h"
@interface WebViewController ()

@end

@implementation WebViewController

#pragma mark Life
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//////////////////////////////////////////////////////////////////////////////////////////////////

-(id)initWithURL:(NSString *)url andTeam:(Team*)team{
    self = [self init];
    if (self) {
        // Custom initialization
        _url = url;
        _team = team;
    }
    return self;
    
}
//////////////////////////////////////////////////////////////////////////////////////////////////

-(id)initWithURL:(NSString *)url andStory:(Story*)story{
    self = [self init];
    if (self) {
        // Custom initialization
        _url = url;
        _story = story;
    }
    return self;
}
//////////////////////////////////////////////////////////////////////////////////////////////////


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_isModal) {
        UIBarButtonItem*done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissModalViewControllerAnimated:)];
        self.navigationItem.leftBarButtonItem = done;
        self.navigationItem.title = _team.name;
    }
    
    UIWebView*web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    web.scalesPageToFit = YES;
    [web loadRequest:request];
    [self.view addSubview:web];
    
    self.navigationItem.title = _story.source;


	// Do any additional setup after loading the view.
}
//////////////////////////////////////////////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
