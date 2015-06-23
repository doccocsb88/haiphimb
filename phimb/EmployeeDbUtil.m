//
//  EmployeeDbUtil.m
//  phimb
//
//  Created by Apple on 6/11/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import "EmployeeDbUtil.h"

@implementation EmployeeDbUtil

@synthesize databasePath;

- (void) initDatabase {
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent:@"phimbb.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    //the file will not be there when we load the application for the first time
    //so this will create the database table
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
        {
            char *errMsg;
//            NSString *sql_stmt = @"CREATE TABLE IF NOT EXISTS EMPLOYEES (";
//            sql_stmt = [sql_stmt stringByAppendingString:@"id INTEGER PRIMARY KEY AUTOINCREMENT, "];
//            sql_stmt = [sql_stmt stringByAppendingString:@"name TEXT, "];
//            sql_stmt = [sql_stmt stringByAppendingString:@"department TEXT, "];
//            sql_stmt = [sql_stmt stringByAppendingString:@"age TEXT)"];
            NSString *sql_stmt_film = @"CREATE TABLE IF NOT EXISTS PHIMBB (";
            sql_stmt_film = [sql_stmt_film stringByAppendingString:@"id INTEGER PRIMARY KEY AUTOINCREMENT, "];
            sql_stmt_film = [sql_stmt_film stringByAppendingString:@"filmid INTEGER, "];
            sql_stmt_film = [sql_stmt_film stringByAppendingString:@"name TEXT, "];
            sql_stmt_film = [sql_stmt_film stringByAppendingString:@"subname TEXT, "];
            sql_stmt_film = [sql_stmt_film stringByAppendingString:@"img TEXT, "];
            sql_stmt_film = [sql_stmt_film stringByAppendingString:@"imglanscape TEXT, "];
            sql_stmt_film = [sql_stmt_film stringByAppendingString:@"cate TEXT, "];
            sql_stmt_film = [sql_stmt_film stringByAppendingString:@"country TEXT, "];
            sql_stmt_film = [sql_stmt_film stringByAppendingString:@"total INTEGER, "];
            sql_stmt_film = [sql_stmt_film stringByAppendingString:@"star TEXT, "];
            sql_stmt_film = [sql_stmt_film stringByAppendingString:@"director TEXT, "];
            sql_stmt_film = [sql_stmt_film stringByAppendingString:@"desc TEXT, "];
            sql_stmt_film = [sql_stmt_film stringByAppendingString:@"type INTEGER, "];
            sql_stmt_film = [sql_stmt_film stringByAppendingString:@"date TEXT)"];
            NSLog(@"slite %@",sql_stmt_film);
//            if (sqlite3_exec(mySqliteDB, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK)
//            {
//                NSLog(@"Failed to create table");
//            }
//            else
//            {
//                NSLog(@"Employees table created successfully");
//            }
            if (sqlite3_exec(mySqliteDB, [sql_stmt_film UTF8String], NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create film table");
            }
            else
            {
                NSLog(@"Film table created successfully");
            }
            sqlite3_close(mySqliteDB);
            
        } else {
            NSLog(@"Failed to open/create database");
        }
    }
    
}

//save our data
//- (BOOL) saveEmployee:(Employee *)employee
//{
//    BOOL success = false;
//    sqlite3_stmt *statement = NULL;
//    const char *dbpath = [databasePath UTF8String];
//    
//    if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
//    {
//        if (employee.employeeID > 0) {
//            NSLog(@"Exitsing data, Update Please");
//            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE EMPLOYEES set name = '%@', department = '%@', age = '%@' WHERE id = ?",
//                                   employee.name,
//                                   employee.department,
//                                   [NSString stringWithFormat:@"%d", employee.age]];
//            
//            const char *update_stmt = [updateSQL UTF8String];
//            sqlite3_prepare_v2(mySqliteDB, update_stmt, -1, &statement, NULL );
//            sqlite3_bind_int(statement, 1, employee.employeeID);
//            if (sqlite3_step(statement) == SQLITE_DONE)
//            {
//                success = true;
//            }
//            
//        }
//        else{
//            NSLog(@"New data, Insert Please");
//            NSString *insertSQL = [NSString stringWithFormat:
//                                   @"INSERT INTO EMPLOYEES (name, department, age) VALUES (\"%@\", \"%@\", \"%@\")",
//                                   employee.name,
//                                   employee.department,
//                                   [NSString stringWithFormat:@"%d", employee.age]];
//            
//            const char *insert_stmt = [insertSQL UTF8String];
//            sqlite3_prepare_v2(mySqliteDB, insert_stmt, -1, &statement, NULL);
//            if (sqlite3_step(statement) == SQLITE_DONE)
//            {
//                success = true;
//            }
//        }
//        
//        sqlite3_finalize(statement);
//        sqlite3_close(mySqliteDB);
//        
//    }
//    
//    return success;
//}
- (BOOL) saveFilmUserData:(UserDataFilm *)userData
{
    BOOL success = false;
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
    {
        if (userData.userdataID > 0) {
            NSLog(@"Exitsing data, Update Please");
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE PHIMBB set filmid = '%d', name = '%@', subname = '%@', img = '%@', img_lanscpae = '%@', cate = '%@', country = '%@', total = '%d', star = '%@', director = '%@', desc = '%@', type ='%d', date = '%@' WHERE id = ?",
//                        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE PHIMBB set filmid = '%d', name = '%@', subname = '%@', img = '%@', imglanscape = '%@',type = '%d' date = '%@' WHERE id = ?",
                                   userData.info._id,
                                   userData.info.name,
                                   userData.info.subname,
                                   userData.info.img,
                                   userData.info.img_landscpae,
                                   userData.info.cate,
                                   userData.info.country,
                                   userData.info.total,
                                   userData.info.star,
                                   userData.info.director,
                                   userData.info.desc,
                                   userData.type,
                                   userData.date];
            
            const char *update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(mySqliteDB, update_stmt, -1, &statement, NULL );
            sqlite3_bind_int(statement, 1, userData.userdataID);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                success = true;
            }
            
        }
        else{
            NSLog(@"New data, Insert Please");
//            NSString *insertSQL = [NSString stringWithFormat:
//                                   @"INSERT INTO PHIMBB (filmid,name, subname, img, img_lanscpae, cate, country, total, star, director, desc, style, date) VALUES (%d, \"%@\", \"%@\",\"%@\",\"%@\",\"%@\",\"%@\",%d,\"%@\",\"%@\",\"%@\",%d,\"%@\")",
            NSString *insertSQL = [NSString stringWithFormat:
                                   @"INSERT INTO PHIMBB (filmid, name, subname, img, imglanscape,cate,country,total,star,director,desc,type, date) VALUES (%d, \"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",%d,\"%@\",\"%@\",\"%@\",%d,\"%@\")",
                                   userData.info._id,
                                   userData.info.name,
                                   userData.info.subname,
                                   userData.info.img,
                                   userData.info.img_landscpae,
                                   userData.info.cate,
                                   userData.info.country,
                                   userData.info.total,
                                   userData.info.star,
                                   userData.info.director,
                                   userData.info.desc,
                                   userData.type,
                                   userData.date];
            
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(mySqliteDB, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                success = true;
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(mySqliteDB);
        
    }
    
    return success;
}


//get a list of all our employees
//- (NSMutableArray *) getEmployees
//{
//    NSMutableArray *employeeList = [[NSMutableArray alloc] init];
//    const char *dbpath = [databasePath UTF8String];
//    sqlite3_stmt    *statement;
//    
//    if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
//    {
//        NSString *querySQL = @"SELECT id,filmid, name, subname, img, img_lanscpae, cate, country, total, star, director, desc,type, date FROM PHIMBB";
//        const char *query_stmt = [querySQL UTF8String];
//        
//        if (sqlite3_prepare_v2(mySqliteDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
//        {
//            while (sqlite3_step(statement) == SQLITE_ROW)
//            {
//                Employee *employee = [[Employee alloc] init];
//                employee.employeeID = sqlite3_column_int(statement, 0);
//                employee.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                employee.department = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//                employee.age = sqlite3_column_int(statement, 3);
//                [employeeList addObject:employee];
//            }
//            sqlite3_finalize(statement);
//        }
//        sqlite3_close(mySqliteDB);
//    }
//    
//    return employeeList;
//}
- (NSMutableArray *) getRecentViewed{
    NSMutableArray *userDataList = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
    {
        NSString *querySQL = @"SELECT id,filmid, name, subname, img, imglanscape, cate, country, total, star, director, desc,type, date FROM PHIMBB ORDER BY id DESC LIMIT 5";
        //                NSString *querySQL = @"SELECT id,filmid, name, subname,img,imglanscape, date FROM PHIMBB";
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(mySqliteDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                UserDataFilm *data = [[UserDataFilm alloc] init];
                data.userdataID = sqlite3_column_int(statement, 0);
                FilmInfoDetails *info = [[FilmInfoDetails alloc] init];
                info._id = sqlite3_column_int(statement, 1);
                NSLog(@"LogAtHere 1");
                info.name =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                NSLog(@"LogAtHere 2-a");
                
                info.subname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                NSLog(@"LogAtHere 2-b");
                
                info.img =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)!=nil?(char *)sqlite3_column_text(statement, 4):(char *)"bac"];
                NSLog(@"LogAtHere 2");
                info.img_landscpae = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)!=nil?(char *)sqlite3_column_text(statement, 5):(char*)"abc"];
                
                info.cate =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)!=nil?(char *)sqlite3_column_text(statement, 6):(char *)"abc"];
                
                info.country =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)!=nil?(char *)sqlite3_column_text(statement, 7):(char*)"abc"];
                NSLog(@"LogAtHere 3");
                
                info.total =sqlite3_column_int(statement, 8);
                NSLog(@"totalFilm : %d",info.total);
                info.star =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)!=nil?(char *)sqlite3_column_text(statement, 9):(char*)"abc"];
                
                info.director = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)!=nil?(char *)sqlite3_column_text(statement, 10):(char *)"abc"];
                NSLog(@"LogAtHere 4");
                
                info.desc = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)!=nil?(char *)sqlite3_column_text(statement, 11):(char*)"abc"];
                
                
                data.info = info;
                data.type = sqlite3_column_int(statement, 12);
                NSLog(@"LogAtHere 5");
                
                data.date =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)!=nil?(char *)sqlite3_column_text(statement, 13):(char*)"abc"];
                
                [userDataList addObject:data];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(mySqliteDB);
    }
    
    return userDataList;
}
- (NSMutableArray *) getUserDatas
{
    NSMutableArray *userDataList = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
    {
        NSString *querySQL = @"SELECT id,filmid, name, subname, img, imglanscape, cate, country, total, star, director, desc,type, date FROM PHIMBB ORDER BY id DESC";
//                NSString *querySQL = @"SELECT id,filmid, name, subname,img,imglanscape, date FROM PHIMBB";
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(mySqliteDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {

                UserDataFilm *data = [[UserDataFilm alloc] init];
                data.userdataID = sqlite3_column_int(statement, 0);
                FilmInfoDetails *info = [[FilmInfoDetails alloc] init];
                info._id = sqlite3_column_int(statement, 1);
                NSLog(@"LogAtHere 1");
                info.name =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                NSLog(@"LogAtHere 2-a");

                info.subname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                NSLog(@"LogAtHere 2-b");

                info.img =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)!=nil?(char *)sqlite3_column_text(statement, 4):(char *)"bac"];
                NSLog(@"LogAtHere 2");
                info.img_landscpae = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)!=nil?(char *)sqlite3_column_text(statement, 5):(char*)"abc"];

                info.cate =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)!=nil?(char *)sqlite3_column_text(statement, 6):(char *)"abc"];

                info.country =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)!=nil?(char *)sqlite3_column_text(statement, 7):(char*)"abc"];
                NSLog(@"LogAtHere 3");

                info.total =sqlite3_column_int(statement, 8);
                NSLog(@"totalFilm : %d",info.total);
                info.star =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)!=nil?(char *)sqlite3_column_text(statement, 9):(char*)"abc"];

                info.director = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)!=nil?(char *)sqlite3_column_text(statement, 10):(char *)"abc"];
                NSLog(@"LogAtHere 4");

                info.desc = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)!=nil?(char *)sqlite3_column_text(statement, 11):(char*)"abc"];

                
                data.info = info;
                data.type = sqlite3_column_int(statement, 12);
                NSLog(@"LogAtHere 5");

                data.date =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)!=nil?(char *)sqlite3_column_text(statement, 13):(char*)"abc"];

                [userDataList addObject:data];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(mySqliteDB);
    }
    
    return userDataList;
}


//get information about a specfic employee by it's id
- (UserDataFilm *) getUserDataByFilmId:(NSInteger) filmID
{
    UserDataFilm *data = [[UserDataFilm alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT * FROM PHIMBB WHERE filmid=%d",
                              filmID];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(mySqliteDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                data.userdataID = sqlite3_column_int(statement, 0);
                FilmInfoDetails *info = [[FilmInfoDetails alloc] init];
                info._id = sqlite3_column_int(statement, 1);
                NSLog(@"LogAtHere 1");
                info.name =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                NSLog(@"LogAtHere 2-a");
                
                info.subname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                NSLog(@"LogAtHere 2-b");
                
                info.img =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)!=nil?(char *)sqlite3_column_text(statement, 4):(char *)"bac"];
                NSLog(@"LogAtHere 2");
                info.img_landscpae = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)!=nil?(char *)sqlite3_column_text(statement, 5):(char*)"abc"];
                
                info.cate =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)!=nil?(char *)sqlite3_column_text(statement, 6):(char *)"abc"];
                
                info.country =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)!=nil?(char *)sqlite3_column_text(statement, 7):(char*)"abc"];
                NSLog(@"LogAtHere 3");
                
                info.total =sqlite3_column_int(statement, 8);
                NSLog(@"totalFilm : %d",info.total);
                info.star =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)!=nil?(char *)sqlite3_column_text(statement, 9):(char*)"abc"];
                
                info.director = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)!=nil?(char *)sqlite3_column_text(statement, 10):(char *)"abc"];
                NSLog(@"LogAtHere 4");
                
                info.desc = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)!=nil?(char *)sqlite3_column_text(statement, 11):(char*)"abc"];
                
                
                data.info = info;
                data.type = sqlite3_column_int(statement, 12);
                NSLog(@"LogAtHere 5");
                
                data.date =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)!=nil?(char *)sqlite3_column_text(statement, 13):(char*)"abc"];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(mySqliteDB);
    }
    
    return data;
}
//
////delete the employee from the database
//- (BOOL) deleteEmployee:(Employee *)employee
//{
//    BOOL success = false;
//    sqlite3_stmt *statement = NULL;
//    const char *dbpath = [databasePath UTF8String];
//    
//    if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
//    {
//        if (employee.employeeID > 0) {
//            NSLog(@"Exitsing data, Delete Please");
//            NSString *deleteSQL = [NSString stringWithFormat:@"DELETE from EMPLOYEES WHERE id = ?"];
//            
//            const char *delete_stmt = [deleteSQL UTF8String];
//            sqlite3_prepare_v2(mySqliteDB, delete_stmt, -1, &statement, NULL );
//            sqlite3_bind_int(statement, 1, employee.employeeID);
//            if (sqlite3_step(statement) == SQLITE_DONE)
//            {
//                success = true;
//            }
//            
//        }
//        else{
//            NSLog(@"New data, Nothing to delete");
//            success = true;
//        }
//        
//        sqlite3_finalize(statement);
//        sqlite3_close(mySqliteDB);
//        
//    }
//    
//    return success;
//}
@end
