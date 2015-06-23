//
//  EmployeeDbUtil.h
//  phimb
//
//  Created by Apple on 6/11/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>
#import "Employee.h"
#import "UserDataFilm.h"
@interface EmployeeDbUtil : NSObject {
    sqlite3 *mySqliteDB;
}

@property (nonatomic, strong) NSString *databasePath;

- (void) initDatabase;
//- (BOOL) saveEmployee:(Employee *)employee;
- (BOOL) saveFilmUserData:(UserDataFilm *)userData;
//- (BOOL) deleteEmployee:(Employee *)employee;
//- (NSMutableArray *) getEmployees;
- (NSMutableArray *) getUserDatas;
- (NSMutableArray *) getRecentViewed;
- (UserDataFilm *) getUserDataByFilmId:(NSInteger) filmID;
//- (Employee *) getEmployee:(NSInteger) employeeID;
@end
