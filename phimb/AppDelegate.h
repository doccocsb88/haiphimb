//
//  AppDelegate.h
//  phimb
//
//  Created by Apple on 6/5/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayVideoViewController.h"
#import "SearchResultItem.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) BOOL allowRotation;
@property (strong, nonatomic) PlayVideoViewController *playerViewController;
+ (UIViewController*) topMostController;
-(BOOL)canClick;
-(void)showPlayer:(SearchResultItem *)item inView:(UIView *)view;
-(void)closePlayer;
@end

