//
//  AppDelegate.h
//  phimb
//
//  Created by Apple on 6/5/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) BOOL allowRotation;
+ (UIViewController*) topMostController;
@end

