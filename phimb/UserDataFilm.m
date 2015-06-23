//
//  UserDataFilm.m
//  phimb
//
//  Created by Apple on 6/11/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import "UserDataFilm.h"

@implementation UserDataFilm
@synthesize userdataID,info,type,date;
-(id)initWidthStatement:(sqlite3_stmt *)statement{
    self = [super init];
    if (self) {
        self.info = [[FilmInfoDetails alloc] init];
        self.info._id = sqlite3_column_int(statement, 1);
        self.info.name = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
        self.info.subname = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
        self.info.img = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
        self.info.img_landscpae =  [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
        self.info.cate = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
        self.info.country = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
        self.info.total = sqlite3_column_int(statement, 8);
        self.info.star = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)];
        self.info.director = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)];
        self.info.desc = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 11)];
        self.type = sqlite3_column_int(statement, 12);
        self.date = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 13)];
        self.thumb = nil;
    }
    return self;

}
@end
