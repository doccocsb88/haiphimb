//
//  Employee.h
//  phimb
//
//  Created by Apple on 6/11/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Employee : NSObject
@property (nonatomic) NSInteger employeeID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *department;
@property (nonatomic) NSInteger age;
@end
