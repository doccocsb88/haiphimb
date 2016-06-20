//
//  Control.h
//  HAYABUSA Robot
/**
 *Copyright (C) 2014 Neos CorporationAllRights　Reserved.
 */

#import <Foundation/Foundation.h>

@interface Control : NSObject


@property (nonatomic) NSInteger ID;
@property (nonatomic, strong) NSString *history;
@property (nonatomic, strong) NSString *favourite;

@end