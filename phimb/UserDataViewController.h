//
//  UserDataViewController.h
//  phimb
//
//  Created by Apple on 6/10/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee.h"
#import "EmployeeDbUtil.h"
#import "UserDataFilm.h"
@protocol HistoryDelegate <NSObject>
-(void)playHistoryMovie:(NSInteger)filmID;
@end
@interface UserDataViewController : UIView <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) id<HistoryDelegate> delegate;
@property (strong,nonatomic) UITableView *userdataTable;
@property (assign,nonatomic) CGFloat myValue;
@property  (assign,nonatomic) int dataType;
@property (strong, nonatomic) EmployeeDbUtil *employeeDbUtil;
@property (strong, nonatomic) NSMutableArray *employeeList;
-(id)initWithFrame:(CGRect)frame;
-(void)refreshHistoryData;
@end
