//
//  SearchResultItem.m
//  SlideMenu
//
//  Created by Apple on 6/1/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import "SearchResultItem.h"

@implementation SearchResultItem
@synthesize _id;
@synthesize name ;
@synthesize subname;
@synthesize img;
@synthesize imglanscape;
@synthesize thumbnail;
@synthesize hasData;
-(id)initWithData: (NSDictionary *)data{
    self = [super init];
    if(self){
        _id= [[data objectForKey:@"id"] integerValue];
        name = [data objectForKey:@"name"];
        subname = [data objectForKey:@"subname"];
        img = [data objectForKey:@"img"];
        imglanscape = [data objectForKey:@"img_landscpae"];
        thumbnail = nil;
        hasData = NO;
    }
    return self;
}

@end
