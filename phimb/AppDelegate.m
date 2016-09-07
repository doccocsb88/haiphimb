//
//  AppDelegate.m
//  phimb
//
//  Created by Apple on 6/5/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import "AppDelegate.h"
#import "ColorSchemeHelper.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PlayVideoViewController.h"
#import <RealReachability/RealReachability.h>
@import Firebase;
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *deviceString =[[UIDevice currentDevice] platformString];
    if ([deviceString containsString:@"iPad"]) {
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).allowRotation = YES;
        
    }else{
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).allowRotation = NO;
    }
    // Override point for customization after application launch.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerWillEnterFullscreenNotification:) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerWillExitFullscreenNotification:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    
    /**/
//    [fb]
    UIImage *whiteBackground = [UIImage imageNamed:@"redbackgroundx.png"];
    [[UITabBar appearance] setSelectionIndicatorImage:whiteBackground];
    [FBSDKLoginButton class];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],
                                                        NSForegroundColorAttributeName : [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1]
                                                        } forState:UIControlStateNormal];
    
    //
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor greenColor], UITextAttributeTextColor, nil]
//                                             forState:UIControlStateNormal];
    [[UITabBar appearance] setTintColor:[ColorSchemeHelper sharedNationHeaderColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor grayColor] }
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [ColorSchemeHelper sharedNationHeaderColor] }
                                             forState:UIControlStateSelected];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [GLobalRealReachability startNotifier];
    [FIRApp configure];

    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
   
    NSLog(@"rotation");
    if ([self.window.rootViewController.presentedViewController isKindOfClass:[PlayVideoViewController class]]){
        NSString *deviceString =[[UIDevice currentDevice] platformString];
        if ([deviceString containsString:@"iPad"]) {
            return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
            
        }else{
            return UIInterfaceOrientationMaskPortrait;
        }
    }else{
        if (self.allowRotation) {
            return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
        }
    }
    return UIInterfaceOrientationMaskPortrait;

}
- (void) moviePlayerWillEnterFullscreenNotification:(NSNotification*)notification {
    NSString *deviceString =[[UIDevice currentDevice] platformString];
    if ([deviceString containsString:@"iPad"]) {
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).allowRotation = YES;
        
    }else{
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).allowRotation = NO;
    }
//    self.allowRotation = NO;
}
- (void) moviePlayerWillExitFullscreenNotification:(NSNotification*)notification {
    NSString *deviceString =[[UIDevice currentDevice] platformString];
    if ([deviceString containsString:@"iPad"]) {
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).allowRotation = YES;
        
    }else{
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).allowRotation = NO;
    }
    //    self.allowRotation = NO;

}

+ (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}
-(void)showAddBanner:(UIViewController *)controller{
    self.bannerView = [[GADBannerView alloc] initWithAdSize:GADAdSizeFromCGSize(CGSizeMake(320, 50))];
    self.bannerView.frame = CGRectMake(0, CGRectGetHeight([[UIScreen mainScreen] bounds]) - 100, CGRectGetWidth([[UIScreen mainScreen] bounds]), 50);
    self.bannerView.adUnitID = @"ca-app-pub-1737618998941554/9716869826";
    self.bannerView.rootViewController = controller;
    
    GADRequest *request = [GADRequest request];
    // Requests test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made. GADBannerView automatically returns test ads when running on a
    // simulator.
    request.testDevices = @[
                            @"31d3e2f86e101c729ad91ba5134da532133c490c"  // Eric's iPod Touch
                            ];
    [self.bannerView loadRequest:request];
    //    [self.view addSubview:self.bannerView];
    [self.window addSubview:self.bannerView];

}
-(BOOL)canClick{
//    if (self.playerViewController) {
//        if (self.playerViewController.originSize) {
//            return NO;
//        }
//        return YES;
//    }
    return YES;
}
-(void)showPlayer:(SearchResultItem *)item inView:(UIView *)view{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    if (self.bannerView) {
        self.bannerView.hidden = YES;
    }
    if (self.playerViewController) {
        
        [self.playerViewController prepareFilmData:item];
       [self.playerViewController  scaleViewToOriginalSize];
    }else{
        self.playerViewController = [[PlayVideoViewController alloc] initWithInfo:item];
        CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        CGFloat height = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        
        self.playerViewController.view.frame = CGRectMake(width, height, width, height);
        self.playerViewController.view.alpha = 0.0;

        [self.playerViewController prepareFilmData:item];
        [self.window addSubview:self.playerViewController.view];

        [UIView animateWithDuration:0.5 animations:^{
            self.playerViewController.view.frame = CGRectMake(0, 0, width, height);
            self.playerViewController.view.alpha = 1.0;
        } completion:^(BOOL finished) {
            if (finished) {
//                [view bringSubviewToFront:self.playerViewController.view];
                [self.playerViewController scaleViewToOriginalSize];
            }
        }];
    }
}
-(void)closePlayer{
    [self.playerViewController.view removeFromSuperview];
    self.playerViewController = nil;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if (self.bannerView) {
        self.bannerView.hidden = NO;
    }
}
@end
