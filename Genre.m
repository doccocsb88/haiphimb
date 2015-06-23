//
//  Genre.m
//  SlideMenu
//
//  Created by Apple on 6/2/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import "Genre.h"

@implementation Genre
@synthesize title;
@synthesize key;
+ (id)itemWithTitle:(NSString *)title  withKey:(NSString *)creator
{
    return [[self alloc] initWithTitle:(NSString *)title  withKey:(NSString *)creator];
}

- (id)initWithTitle:(NSString *)_title  withKey:(NSString *)creator
{
    if ((self = [super init]))
    {
        title = _title;
//        _image = image;
        key = creator;
    }
    
    return self;
}
@end
