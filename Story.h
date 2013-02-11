//
//  Story.h
//  ESPN
//
//  Created by Luke Geiger on 2/10/13.
//  Copyright (c) 2013 www.lukejgeiger.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Story : NSObject

@property (nonatomic, strong)NSString*headline;
@property (nonatomic, strong)NSString*description;
@property (nonatomic, strong)NSString*source;
@property (nonatomic, strong)NSNumber*idCode;
@property (nonatomic, strong)NSDictionary*linksDictionary;
@property (nonatomic, strong)NSDictionary*mobileDictionary;
@property (nonatomic, strong)NSString*storyURL;


+ (Story*)storyFromESPN:(NSDictionary*)dict;

@end
