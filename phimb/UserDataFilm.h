//
//  UserDataFilm.h
//  phimb
//
//  Created by Apple on 6/11/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilmInfoDetails.h"
#import <sqlite3.h>

@interface UserDataFilm : NSObject
@property (assign,nonatomic) NSInteger userdataID;
@property (strong, nonatomic) NSString * currentEpsider;
@property (strong,nonatomic) FilmInfoDetails *info;
@property (assign,nonatomic) NSInteger type;
@property (strong, nonatomic) NSString *date;
-(id)initWidthStatement:(sqlite3_stmt *)statement;
@end
