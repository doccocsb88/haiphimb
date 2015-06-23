//
//  FilmInfoDetails.m
//  SlideMenu
//
//  Created by Apple on 6/1/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import "FilmInfoDetails.h"

@implementation FilmInfoDetails
@synthesize _id;
@synthesize name;
@synthesize subname,img,img_landscpae,cate,total,country,star,director,desc;
-(id)init{
    self = [super init];
    if(self){
        NSString *xstr = @"Updating";
        _id = 1l;
        name = xstr;
        subname = xstr;
        if([subname isEqualToString:@""]){
            subname = name;
        }
        img = xstr;
        img_landscpae = xstr;
        cate = xstr;
        total = 0;
        country = xstr;
        star = xstr;
        director = xstr;
        desc = xstr;

    }
    return self;
    
}
-(id)initWithData:(NSDictionary *)filmData{
    self = [super init];
    if(self){
        NSString *xstr = @"Updating";

        _id = [[filmData objectForKey:@"id"] integerValue];
        name = [filmData objectForKey:@"name"];
        subname = [filmData objectForKey:@"subname"];
        if([subname isEqualToString:@""]){
            subname = name;
        }
        img = [filmData objectForKey:@"img"];
        img_landscpae = [filmData objectForKey:@"img_landscpae"];
        cate = [filmData objectForKey:@"cate"];
        total = [[filmData objectForKey:@"total"] integerValue];
        country = [filmData objectForKey:@"country"];
        star = [filmData objectForKey:@"star"];
        director = [filmData objectForKey:@"director"];
        if ([director isEqualToString:@""]) {
            director = xstr;
        }
        desc = [filmData objectForKey:@"desc"];
    }
    return self;

}
@end
