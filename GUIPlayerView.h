//
//  GUIPlayerView.h
//  GUIPlayerView
//
//  Created by Guilherme Araújo on 08/12/14.
//  Copyright (c) 2014 Guilherme Araújo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MarqueeLabel.h>

@class GUIPlayerView;

@protocol GUIPlayerViewDelegate <NSObject>

@optional
- (void)playerDidExpandMore;
- (void)playerDidExpandLess;
- (void)playerDidNext;
- (void)playerDidPrevious;
- (void)playerDidPause;
- (void)playerDidResume;
- (void)playerDidEndPlaying;
- (void)playerDidPlaying;
- (void)playerWillEnterFullscreen;
- (void)playerDidEnterFullscreen;
- (void)playerWillLeaveFullscreen;
- (void)playerDidLeaveFullscreen;

- (void)playerFailedToPlayToEnd;
- (void)playerStalled;

@end

@interface GUIPlayerView : UIView
@property (strong, nonatomic) UIButton *fullscreenButton;
@property (strong, nonatomic) UIButton *fullscreenButtonz;
@property (strong, nonatomic) MarqueeLabel *lbTitle;
@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) UIButton *prevButton;
@property (strong, nonatomic) UIButton *btnExpand;
@property (assign, nonatomic) BOOL seeking;
@property (assign, nonatomic) BOOL fseeking;

@property (assign, nonatomic) BOOL fullscreen;
@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) NSString *filmname;
@property (assign, nonatomic) NSInteger controllersTimeoutPeriod;
@property (weak, nonatomic) id<GUIPlayerViewDelegate> delegate;
@property (assign, nonatomic) int total;
@property (assign, nonatomic) int current;
@property (assign, nonatomic) BOOL rotating;
@property (assign, nonatomic) BOOL originsize;
@property (assign, nonatomic) BOOL isReady;

@property (assign, nonatomic) int lastorientation;
@property (assign, nonatomic) int hasController;

@property (assign, nonatomic) UIDeviceOrientation queueRotate;
@property (assign, nonatomic) UIDeviceOrientation lastRotate;

- (void)toggleFullscreen:(UIButton *)sender;
-(void)hideControllers;
-(void)showControllers;
-(void)changeViewtoPortrait;
-(void)changeViewToLandcape;
-(void)changeViewToLandcapeLeft;
-(void)waitingForRorate;
- (void)prepareAndPlayAutomatically:(BOOL)playAutomatically;
- (void)playWithUrl:(NSString *)videoURL;
- (void)clean;
- (void)play;
- (void)pause;
- (void)stop;

- (BOOL)isPlaying;

- (void)setBufferTintColor:(UIColor *)tintColor;

- (void)setLiveStreamText:(NSString *)text;

- (void)setAirPlayText:(NSString *)text;
- (void)updatePlayerLayer;
@end
