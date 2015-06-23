//
//  Control.m
//  HAYABUSA Robot
/**
 *Copyright (C) 2014 Neos CorporationAllRights　Reserved.
 */

#import "Control.h"

@implementation Control

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.ID = -1;
        self.history = @"";
        self.favourite = @"";
        
       
    }
    
    return self;
}

@end

