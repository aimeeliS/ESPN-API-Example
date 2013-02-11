//
//  Team.h
//  ESPN
//
//  Created by Luke Geiger on 2/9/13.
//  Copyright (c) 2013 www.lukejgeiger.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Team : NSObject

@property (nonatomic, strong)NSString*location;
@property (nonatomic, strong)NSString*abv;
@property (nonatomic, strong)NSString*name;
@property (nonatomic, strong)NSNumber*idCode;
@property (nonatomic, strong)NSString*newsURL;
@property (nonatomic, strong)NSString*notesURL;
@property (nonatomic, strong)NSString*hexColor;

@property (nonatomic, strong)NSString*webURL;
@property (nonatomic, strong)NSDictionary*linksArray;
@property (nonatomic, strong)NSDictionary*webDictionary;
@property (nonatomic, strong)NSDictionary*teamDictionary;

+ (Team*)teamFromESPN:(NSDictionary*)dict;


@end
