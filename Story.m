//
//  Story.m
//  ESPN
//
//  Created by Luke Geiger on 2/10/13.
//  Copyright (c) 2013 www.lukejgeiger.com. All rights reserved.
//

#import "Story.h"

@implementation Story


+ (Story*)storyFromESPN:(NSDictionary*)dict{
    
    Story*story = [[Story alloc]init];
    story.headline = [dict valueForKey:@"headline"];
    story.description = [dict valueForKey:@"description"];
    story.source = [dict valueForKey:@"source"];
    story.idCode = [NSNumber numberWithInt:[[dict valueForKey:@"id"]intValue]];
    story.linksDictionary = [dict valueForKey:@"links"];
    story.mobileDictionary = [story.linksDictionary valueForKey:@"mobile"];
    story.storyURL = [story.mobileDictionary valueForKey:@"href"];

    return story;
}


@end
