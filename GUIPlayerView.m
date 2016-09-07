//
//  GUIPlayerView.m
//  GUIPlayerView
//
//  Created by Guilherme Araújo on 08/12/14.
//  Copyright (c) 2014 Guilherme Araújo. All rights reserved.
//

#import "GUIPlayerView.h"
#import "GUISlider.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MONActivityIndicatorView.h"
#import "UIView+UpdateAutoLayoutConstraints.h"
#import "ColorSchemeHelper.h"
@interface GUIPlayerView () <AVAssetResourceLoaderDelegate, NSURLConnectionDataDelegate, MONActivityIndicatorViewDelegate>
{
    BOOL isInit;
}
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayerItem *currentItem;

@property (strong, nonatomic) UIView *controllersView;
@property (strong, nonatomic) UIView *controllersFullScreenView;

@property (strong, nonatomic) UILabel *airPlayLabel;

@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UIButton *fplayButton;

//


//
@property (strong, nonatomic) MPVolumeView *volumeView;
@property (strong, nonatomic) UISlider *volume;
@property (strong, nonatomic) GUISlider *normalSlider;
@property (strong, nonatomic) GUISlider *fullScreenSlider;
@property (strong, nonatomic) UILabel *currentTimeLabel;
@property (strong, nonatomic) UILabel *remainingTimeLabel;
//@property (strong, nonatomic) UILabel *liveLabel;
@property (strong, nonatomic) UIImageView *imvVolume;
@property (strong, nonatomic) UILabel *fullScreenCurrentTimeLabel;
@property (strong, nonatomic) UILabel *fullScreenRemainingTimeLabel;

@property (strong, nonatomic) UIView *spacerView;

//@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
//@property (strong, nonatomic) MONActivityIndicatorView *movieIndicator;

@property (strong, nonatomic) NSTimer *progressTimer;
@property (strong, nonatomic) NSTimer *fullScreenProgressTimer;

@property (strong, nonatomic) NSTimer *controllersTimer;

@property (assign, nonatomic) CGRect defaultFrame;
@property (assign, nonatomic) CGFloat angle;

@end

@implementation GUIPlayerView

@synthesize player, playerLayer, currentItem, isReady;
@synthesize controllersView, controllersFullScreenView, airPlayLabel;
@synthesize playButton, fplayButton, fullscreenButton, volumeView, normalSlider, currentTimeLabel, remainingTimeLabel, /*liveLabel,*/ spacerView, btnExpand;
@synthesize  progressTimer,fullScreenProgressTimer, controllersTimer, seeking, fseeking, fullscreen, defaultFrame;
@synthesize fullScreenSlider, fullScreenCurrentTimeLabel, fullScreenRemainingTimeLabel, fullscreenButtonz, nextButton, prevButton, volume, lbTitle, imvVolume;
@synthesize videoURL, filmname, controllersTimeoutPeriod, delegate;

#pragma mark - View Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    defaultFrame = frame;
    [self setup];
    [self setupFullScreenController];

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self setup];
    [self setupFullScreenController];
    return self;
}

- (void)setup {
    isInit = NO;
    isReady = NO;
    self.originsize = YES;
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(volumeChangedz:)
     name:@"AVSystemController_SystemVolumeDidChangeNotification"
     object:nil];
    // Set up notification observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFailedToPlayToEnd:)
                                                 name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStalled:)
                                                 name:AVPlayerItemPlaybackStalledNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(airPlayAvailabilityChanged:)
                                                 name:MPVolumeViewWirelessRoutesAvailableDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(airPlayActivityChanged:)
                                                 name:MPVolumeViewWirelessRouteActiveDidChangeNotification object:nil];
    
    [self setBackgroundColor:[UIColor blackColor]];
    
    NSArray *horizontalConstraints;
    NSArray *verticalConstraints;
    
    
    /** Container View **************************************************************************************************/
    controllersView = [UIView new];
    [controllersView setTranslatesAutoresizingMaskIntoConstraints:NO];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = controllersView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [controllersView.layer insertSublayer:gradient atIndex:0];
    [self addSubview:controllersView];
    //
    horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[CV]|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:@{@"CV" : controllersView}];
    
    verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[CV(40)]|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:@{@"CV" : controllersView}];
    [self addConstraints:horizontalConstraints];
    [self addConstraints:verticalConstraints];
    /*
     fullscreen controller constrints
     */
    controllersFullScreenView = [UIView new];
    [controllersFullScreenView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [controllersFullScreenView setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.45f]];
    
    [self addSubview:controllersFullScreenView];
    horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[CFV]|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:@{@"CFV" : controllersFullScreenView}];
    
    verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[CFV]|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:@{@"CFV" : controllersFullScreenView}];
    [self addConstraints:horizontalConstraints];
    [self addConstraints:verticalConstraints];
    /** AirPlay View ****************************************************************************************************/
    
    airPlayLabel = [UILabel new];
    [airPlayLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [airPlayLabel setText:@"AirPlay is enabled"];
    [airPlayLabel setTextColor:[UIColor lightGrayColor]];
    [airPlayLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
    [airPlayLabel setTextAlignment:NSTextAlignmentCenter];
    [airPlayLabel setNumberOfLines:0];
    [airPlayLabel setHidden:YES];
    
    [self addSubview:airPlayLabel];
    
    horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[AP]|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:@{@"AP" : airPlayLabel}];
    
    verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[AP]-40-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:@{@"AP" : airPlayLabel}];
    [self addConstraints:horizontalConstraints];
    [self addConstraints:verticalConstraints];
    
    /** UI Controllers **************************************************************************************************/
    playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [playButton setImage:[UIImage imageNamed:@"gui_play"] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"gui_pause"] forState:UIControlStateSelected];
    
    volumeView = [MPVolumeView new];
    [volumeView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [volumeView setShowsRouteButton:YES];
    [volumeView setShowsVolumeSlider:NO];
    [volumeView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    fullscreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [fullscreenButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [fullscreenButton setImage:[UIImage imageNamed:@"ic_fullscreen"] forState:UIControlStateNormal];
    [fullscreenButton setImage:[UIImage imageNamed:@"ic_fullscreen_exit"] forState:UIControlStateSelected];
    
    currentTimeLabel = [UILabel new];
    [currentTimeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [currentTimeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
    [currentTimeLabel setTextAlignment:NSTextAlignmentCenter];
    [currentTimeLabel setTextColor:[UIColor whiteColor]];
    
    remainingTimeLabel = [UILabel new];
    [remainingTimeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [remainingTimeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
    [remainingTimeLabel setTextAlignment:NSTextAlignmentCenter];
    [remainingTimeLabel setTextColor:[UIColor whiteColor]];
    
    normalSlider = [GUISlider new];
    [normalSlider setTranslatesAutoresizingMaskIntoConstraints:NO];
    [normalSlider setContinuous:YES];
    
    btnExpand = [UIButton new];
    [btnExpand setTranslatesAutoresizingMaskIntoConstraints:NO];
    [btnExpand setImage:[UIImage imageNamed:@"ic_expand_more_white"] forState:UIControlStateNormal];
    [btnExpand setImage:[UIImage imageNamed:@"ic_expand_less_white"] forState:UIControlStateSelected];
    
    btnExpand.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btnExpand.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 5, 5);
    [btnExpand addTarget:self action:@selector(pressedExpand:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnExpand];
    horizontalConstraints = [NSLayoutConstraint
                             constraintsWithVisualFormat:@"H:|[EP(40)]"
                             options:0
                             metrics:nil
                             views:@{@"EP" : btnExpand}];
    
    [self addConstraints:horizontalConstraints];
    verticalConstraints = [NSLayoutConstraint
                           constraintsWithVisualFormat:@"V:|-0-[EP(40)]"
                           options:NSLayoutFormatAlignAllCenterY
                           metrics:nil
                           views:@{@"EP" : btnExpand}];
    [self addConstraints:verticalConstraints];
//    liveLabel = [UILabel new];
//    [liveLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [liveLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
//    [liveLabel setTextAlignment:NSTextAlignmentCenter];
//    [liveLabel setTextColor:[UIColor whiteColor]];
//    [liveLabel setText:@"Live"];
//    [liveLabel setHidden:YES];
    
    spacerView = [UIView new];
    [spacerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [controllersView addSubview:playButton];
    [controllersView addSubview:fullscreenButton];
    [controllersView addSubview:volumeView];
    [controllersView addSubview:currentTimeLabel];
    [controllersView addSubview:normalSlider];
    [controllersView addSubview:remainingTimeLabel];
//    [controllersView addSubview:liveLabel];
    [controllersView addSubview:spacerView];
    
    horizontalConstraints = [NSLayoutConstraint
                             constraintsWithVisualFormat:@"H:|[P(40)][S(10)][C]-5-[I]-5-[R][F(40)][V(40)]|"
                             options:0
                             metrics:nil
                             views:@{@"P" : playButton,
                                     @"S" : spacerView,
                                     @"C" : currentTimeLabel,
                                     @"I" : normalSlider,
                                     @"R" : remainingTimeLabel,
                                     @"V" : volumeView,
                                     @"F" : fullscreenButton}];
    
    [controllersView addConstraints:horizontalConstraints];
    
    [volumeView hideByWidth:YES];
    [spacerView hideByWidth:YES];
    
//    horizontalConstraints = [NSLayoutConstraint
//                             constraintsWithVisualFormat:@"H:|-5-[L]-5-|"
//                             options:0
//                             metrics:nil
//                             views:@{@"L" : liveLabel}];
//    
//    [controllersView addConstraints:horizontalConstraints];
    
    for (UIView *view in [controllersView subviews]) {
        verticalConstraints = [NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[V(40)]"
                               options:NSLayoutFormatAlignAllCenterY
                               metrics:nil
                               views:@{@"V" : view}];
        [controllersView addConstraints:verticalConstraints];
    }
    
    
    /** Loading Indicator ***********************************************************************************************/
//    movieIndicator = [UIActivityIndicatorView new];
//    [activityIndicator stopAnimating];
//    [self addIndicator];
    CGRect frame = self.frame;
    frame.origin = CGPointZero;
//    [activityIndicator setFrame:frame];
//    
//    [self addSubview:activityIndicator];

    
    //    [self placeAtTheCenterWithView:_movieIndicator];
    
    //    [NSTimer scheduledTimerWithTimeInterval:7 target:indicatorView selector:@selector(stopAnimating) userInfo:nil repeats:NO];
//    [NSTimer scheduledTimerWithTimeInterval:9 target:movieIndicator selector:@selector(startAnimating) userInfo:nil repeats:NO];
    
    /** Actions Setup ***************************************************************************************************/
//    play
    [playButton addTarget:self action:@selector(togglePlay:) forControlEvents:UIControlEventTouchUpInside];
    [fullscreenButton addTarget:self action:@selector(toggleFullscreen:) forControlEvents:UIControlEventTouchUpInside];
    
    [normalSlider addTarget:self action:@selector(seek:) forControlEvents:UIControlEventValueChanged];
    [normalSlider addTarget:self action:@selector(pauseRefreshing) forControlEvents:UIControlEventTouchDown];
    [normalSlider addTarget:self action:@selector(resumeRefreshing) forControlEvents:UIControlEventTouchUpInside|
     UIControlEventTouchUpOutside];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showControllers)]];
    [self showControllers];
    
    controllersTimeoutPeriod = 3;
   
    
}
-(void)setupFullScreenController{
    NSArray *verticalConstraints;
    NSArray *horizontalConstraints;
    //
    UIView *header = [UIView new];
    [header setTranslatesAutoresizingMaskIntoConstraints:NO];
//    header.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = header.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    [header.layer insertSublayer:gradient atIndex:0];

    [controllersFullScreenView addSubview:header];
    horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[HD]|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:@{@"HD" : header}];
    
    verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[HD(40)]"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:@{@"HD" : header}];
    [controllersFullScreenView addConstraints:verticalConstraints];
    [controllersFullScreenView addConstraints:horizontalConstraints];
    //
    UIView *footer = [UIView new];
    [footer setTranslatesAutoresizingMaskIntoConstraints:NO];
//    footer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
//    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = footer.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [footer.layer insertSublayer:gradient atIndex:0];
    [controllersFullScreenView addSubview:footer];

   
    horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[FT]|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:@{@"FT" : footer}];
    
    verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[FT(40)]|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:@{@"FT" : footer}];
    [controllersFullScreenView addConstraints:verticalConstraints];
    [controllersFullScreenView addConstraints:horizontalConstraints];
    //
    fplayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [fplayButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [fplayButton setImage:[UIImage imageNamed:@"gui_play"] forState:UIControlStateNormal];
    [fplayButton setImage:[UIImage imageNamed:@"gui_pause"] forState:UIControlStateSelected];
    [footer addSubview:fplayButton];
    //
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [nextButton setImage:[UIImage imageNamed:@"ic_next"] forState:UIControlStateNormal];
    [nextButton setImage:[UIImage imageNamed:@"ic_next"] forState:UIControlStateSelected];
    [nextButton addTarget:self action:@selector(pressedNext:) forControlEvents:UIControlEventTouchUpInside];
    
    prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [prevButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [prevButton setImage:[UIImage imageNamed:@"ic_previous"] forState:UIControlStateNormal];
    [prevButton setImage:[UIImage imageNamed:@"ic_previous"] forState:UIControlStateSelected];
    [prevButton addTarget:self action:@selector(pressedPrev:) forControlEvents:UIControlEventTouchUpInside];
    //volume
    volume = [UISlider new];
    [volume setTranslatesAutoresizingMaskIntoConstraints:NO];
    [volume setContinuous:YES];
    volume.minimumValue = 0.0;
//    [UIView animateWithDuration:0.2 animations:^{
//        [volume setValue:50.0 animated:YES];
//
//    }];
    
    volume.maximumValue = 100;
    [volume setTintColor:[UIColor redColor]];
    [volume addTarget:self action:@selector(volumeChanged:) forControlEvents:UIControlEventValueChanged];
    [footer addSubview:volume];
    imvVolume = [UIImageView new];
    [imvVolume setTranslatesAutoresizingMaskIntoConstraints:NO];
    imvVolume.image = [UIImage imageNamed:@"ic_volume"];
    imvVolume.contentMode = UIViewContentModeScaleAspectFit;
    [footer addSubview:imvVolume];
    lbTitle = [MarqueeLabel new];
    [lbTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
    lbTitle.text = filmname;
    lbTitle.textColor = [UIColor whiteColor];
    lbTitle.textAlignment = NSTextAlignmentRight;
//    lbTitle set
    [footer addSubview:lbTitle];
    
    //
    [footer addSubview:nextButton];
    [footer addSubview:prevButton];
    horizontalConstraints = [NSLayoutConstraint
                             constraintsWithVisualFormat:@"H:|-[FVL(100)]-[FM(20)]-(>=50)-[FV(30)]-5-[FP(30)]-5-[FN(30)]-10-[FT]-|"
                             options:0
                             metrics:nil
                             views:@{@"FVL":volume,
                                     @"FM" :imvVolume,
                                     @"FV" : prevButton,
                                     @"FP" : fplayButton,
                                     @"FN" : nextButton,
                                     @"FT" : lbTitle
                                     }];
    [footer addConstraints:horizontalConstraints];
    //
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:fplayButton
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:fplayButton.superview
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.f constant:0.f];
    
    [footer addConstraint:c];
    //
    fullscreenButtonz = [UIButton buttonWithType:UIButtonTypeCustom];
    [fullscreenButtonz setTranslatesAutoresizingMaskIntoConstraints:NO];
    [fullscreenButtonz setImage:[UIImage imageNamed:@"ic_fullscreen"] forState:UIControlStateNormal];
    [fullscreenButtonz setImage:[UIImage imageNamed:@"ic_fullscreen_exit"] forState:UIControlStateSelected];
    
    fullScreenCurrentTimeLabel = [UILabel new];
    [fullScreenCurrentTimeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [fullScreenCurrentTimeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
    [fullScreenCurrentTimeLabel setTextAlignment:NSTextAlignmentCenter];
    [fullScreenCurrentTimeLabel setTextColor:[UIColor whiteColor]];
    
    fullScreenRemainingTimeLabel = [UILabel new];
    [fullScreenRemainingTimeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [fullScreenRemainingTimeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]];
    [fullScreenRemainingTimeLabel setTextAlignment:NSTextAlignmentCenter];
    [fullScreenRemainingTimeLabel setTextColor:[UIColor whiteColor]];
    
    fullScreenSlider = [GUISlider new];
    [fullScreenSlider setTranslatesAutoresizingMaskIntoConstraints:NO];
    [fullScreenSlider setContinuous:YES];
    [header addSubview:fullScreenCurrentTimeLabel];
    [header addSubview:fullScreenRemainingTimeLabel];
    [header addSubview:fullScreenSlider];
    [header addSubview:fullscreenButtonz];
    horizontalConstraints = [NSLayoutConstraint
                             constraintsWithVisualFormat:@"H:|[FC(40)]-5-[FI]-5-[FR(40)][FF(40)]|"
                             options:0
                             metrics:nil
                             views:@{
                                     @"FC" : fullScreenCurrentTimeLabel,
                                     @"FI" : fullScreenSlider,
                                     @"FR" : fullScreenRemainingTimeLabel,
                                     @"FF":fullscreenButtonz}];
    
    [header addConstraints:horizontalConstraints];
    for (UIView *view in [header subviews]) {
        verticalConstraints = [NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[FV(40)]"
                               options:NSLayoutFormatAlignAllCenterY
                               metrics:nil
                               views:@{@"FV" : view}];
        [header addConstraints:verticalConstraints];
    }
    for (UIView *view in [footer subviews]) {
        verticalConstraints = [NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[FV(40)]"
                               options:NSLayoutFormatAlignAllCenterY
                               metrics:nil
                               views:@{@"FV" : view}];
        [footer addConstraints:verticalConstraints];
    }

    //
    [fplayButton addTarget:self action:@selector(togglePlay:) forControlEvents:UIControlEventTouchUpInside];

    [fullscreenButtonz addTarget:self action:@selector(toggleFullscreen:) forControlEvents:UIControlEventTouchUpInside];
    
    [fullScreenSlider addTarget:self action:@selector(fseek:) forControlEvents:UIControlEventValueChanged];
    [fullScreenSlider addTarget:self action:@selector(fpauseRefreshing) forControlEvents:UIControlEventTouchDown];
    [fullScreenSlider addTarget:self action:@selector(fresumeRefreshing) forControlEvents:UIControlEventTouchUpInside|
     UIControlEventTouchUpOutside];
    
    controllersFullScreenView.hidden = YES;
    
}
#pragma mark - UI Customization

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    
    [normalSlider setTintColor:tintColor];
    [fullScreenSlider setTintColor:tintColor];
}

- (void)setBufferTintColor:(UIColor *)tintColor {
    [normalSlider setSecondaryTintColor:tintColor];
    [fullScreenSlider setSecondaryTintColor:tintColor];
}

- (void)setLiveStreamText:(NSString *)text {
//    [liveLabel setText:text];
}

- (void)setAirPlayText:(NSString *)text {
    [airPlayLabel setText:text];
}

#pragma mark - Actions

- (void)togglePlay:(UIButton *)button {
    if ([button isSelected]) {
        [button setSelected:NO];
        [player pause];
        
        if ([delegate respondsToSelector:@selector(playerDidPause)]) {
            [delegate playerDidPause];
        }
    } else {
        [button setSelected:YES];
        [self play];
        
        if ([delegate respondsToSelector:@selector(playerDidResume)]) {
            [delegate playerDidResume];
        }
    }
    
    [self showControllers];
}

- (void)toggleFullscreen:(UIButton *)button {
    if (fullscreen) {
        [self changeViewtoPortrait];
        
        [button setSelected:NO];
    } else {
        [self changeViewToLandcape];
        [button setSelected:YES];

    }
    
    [self showControllers];
}
-(void)changeViewtoPortrait{
    if ([delegate respondsToSelector:@selector(playerWillLeaveFullscreen)]) {
        [delegate playerWillLeaveFullscreen];
    }
    [self updatePlayerLayer];
    self.angle = 0;
    self.rotating = YES;

    [UIView animateWithDuration:0.4f animations:^{
        [self setTransform:CGAffineTransformMakeRotation(0)];
        
        [self setFrame:defaultFrame];
        playerLayer.frame = CGRectMake(0, 0, defaultFrame.size.width, defaultFrame.size.height);
        
        //            CGRect frame = defaultFrame;
        //            frame.origin = CGPointZero;
        //            [playerLayer setFrame:frame];
        //            [movieIndicator setFrame:frame];
        //            movieIndicator.center = self.center;
    } completion:^(BOOL finished) {
        fullscreen = NO;
        controllersFullScreenView.hidden = YES;
        controllersView.hidden = NO;
        btnExpand.hidden = NO;
        self.rotating = NO;
        [self rotateQueue];
        if ([delegate respondsToSelector:@selector(playerDidLeaveFullscreen)]) {
            [delegate playerDidLeaveFullscreen];
        }
    }];
}

-(void)changeViewToLandcape{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    CGRect frame;
    CGFloat duration = 0.4;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        CGFloat aux = width;
        width = height;
        height = aux;
        frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);
    } else {
        frame = CGRectMake(0, 0, width, height);
        duration = duration *3;
    }
    //
    
    //
    if ([delegate respondsToSelector:@selector(playerWillEnterFullscreen)]) {
        [delegate playerWillEnterFullscreen];
    }
    self.rotating = YES;
    float vol = [[AVAudioSession sharedInstance] outputVolume];

    volume.value = vol * 100;
    
    [UIView animateWithDuration:duration animations:^{
        if (self.angle == 0) {
            [self setFrame:frame];
        }
//        }else if(self.angle == -M_PI_2){
//            [self setFrame:CGRectMake(0, 0, width, height)];
//
//        }
        [playerLayer setFrame:CGRectMake(0, 0, width, height)];
        
        //            [movieIndicator setFrame:CGRectMake(0, 0, width, height)];
        //            movieIndicator.center = self.center;
        if (UIInterfaceOrientationIsPortrait(orientation)) {
            [self setTransform:CGAffineTransformMakeRotation(M_PI_2)];
            self.angle = M_PI_2;
            //                [movieIndicator setTransform:CGAffineTransformMakeRotation(M_PI_2)];
            //            movieIndicator.center = self.center;
        }
        
    } completion:^(BOOL finished) {
        fullscreen = YES;
        controllersFullScreenView.hidden = NO;
        controllersView.hidden = YES;
        btnExpand.hidden = NO;
        self.rotating = NO;
        [self rotateQueue];

        if ([delegate respondsToSelector:@selector(playerDidEnterFullscreen)]) {
            [delegate playerDidEnterFullscreen];
        }
    }];
    
}
-(void)changeViewToLandcapeLeft{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    CGRect frame;
    CGFloat duration = 0.4;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        CGFloat aux = width;
        width = height;
        height = aux;
        frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);
    } else {
        frame = CGRectMake(0, 0, width, height);
        duration = duration*3;
    }
    //
    
    //
    self.rotating = YES;

    if ([delegate respondsToSelector:@selector(playerWillEnterFullscreen)]) {
        [delegate playerWillEnterFullscreen];
    }
    
    [UIView animateWithDuration:duration animations:^{
        if (self.angle == 0) {
            [self setFrame:frame];

        }
        [playerLayer setFrame:CGRectMake(0, 0, width, height)];
        
        //            [movieIndicator setFrame:CGRectMake(0, 0, width, height)];
        //            movieIndicator.center = self.center;
        if (UIInterfaceOrientationIsPortrait(orientation)) {
            [self setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
            self.angle =-M_PI_2;
            //                [movieIndicator setTransform:CGAffineTransformMakeRotation(M_PI_2)];
            //            movieIndicator.center = self.center;
        }
        
    } completion:^(BOOL finished) {
        fullscreen = YES;
        controllersFullScreenView.hidden = NO;
        controllersView.hidden = YES;
        btnExpand.hidden = NO;
        self.rotating = NO;
        [self rotateQueue];
        if ([delegate respondsToSelector:@selector(playerDidEnterFullscreen)]) {
            [delegate playerDidEnterFullscreen];
        }
    }];
    

}
-(void)rotateQueue{
    switch (self.queueRotate) {
        case UIDeviceOrientationPortrait:
            // do something for portrait orientation
            if (self.rotating == NO) {
                [self changeViewtoPortrait];
            }else{
//                playerView.queueRotate = orientation;
            }
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            break;
        case UIDeviceOrientationLandscapeLeft:
            if (self.rotating == NO) {
                
                [self changeViewToLandcape];
            }else{
//                playerView.queueRotate = orientation;
            }
            break;
            
        case UIDeviceOrientationLandscapeRight:
            // do something for landscape orientation
            if (self.rotating == NO) {
                
                [self changeViewToLandcapeLeft];
            }
            else{
//                playerView.queueRotate = orientation;
            }
            break;
            
        default:
            break;
    }
    self.queueRotate = UIDeviceOrientationUnknown;
}
- (void)seek:(UISlider *)slider {
    if (isReady) {
        [self pause];
        int timescale = currentItem.asset.duration.timescale;
        float time = slider.value * (currentItem.asset.duration.value / timescale);
        [player seekToTime:CMTimeMakeWithSeconds(time, timescale)];
        
        [self showControllers];
    }
   
}

- (void)pauseRefreshing {
    seeking = YES;
    [self pause];
}

- (void)resumeRefreshing {
    seeking = NO;
    [self play];
}
- (void)fseek:(UISlider *)slider {
    if (isReady) {
        [self pause];
        int timescale = currentItem.asset.duration.timescale;
        float time = slider.value * (currentItem.asset.duration.value / timescale);
        [player seekToTime:CMTimeMakeWithSeconds(time, timescale)];
        [self showControllers];
    }
}

- (void)fpauseRefreshing {
    fseeking = YES;
    [self pause];
}

- (void)fresumeRefreshing {
    fseeking = NO;
    [self play];
}
- (NSTimeInterval)availableDuration {
    NSTimeInterval result = 0;
    NSArray *loadedTimeRanges = player.currentItem.loadedTimeRanges;
    
    if ([loadedTimeRanges count] > 0) {
        CMTimeRange timeRange = [[loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
        Float64 startSeconds = CMTimeGetSeconds(timeRange.start);
        Float64 durationSeconds = CMTimeGetSeconds(timeRange.duration);
        result = startSeconds + durationSeconds;
    }
    
    return result;
}
-(void)refreshFullscreenSlider{
    CGFloat duration = CMTimeGetSeconds(currentItem.asset.duration);
    
    if (duration == 0 || isnan(duration)) {
        // Video is a live stream
        [fullScreenCurrentTimeLabel setText:nil];
        [fullScreenRemainingTimeLabel setText:nil];
        [fullScreenSlider setHidden:YES];
        //        [liveLabel setHidden:NO];
    }
    
    else {
        CGFloat current = fseeking ?
        fullScreenSlider.value * duration :         // If seeking, reflects the position of the slider
        CMTimeGetSeconds(player.currentTime); // Otherwise, use the actual video position
        
     
        [fullScreenSlider setValue:(current / duration)];
        [fullScreenSlider setSecondaryValue:([self availableDuration] / duration)];
        // Set time labels
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:(duration >= 3600 ? @"hh:mm:ss": @"mm:ss")];
        
        NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:current];
        NSDate *remainingTime = [NSDate dateWithTimeIntervalSince1970:(duration - current)];

        //fullscreen
        [fullScreenCurrentTimeLabel setText:[formatter stringFromDate:currentTime]];
        [fullScreenRemainingTimeLabel setText:[NSString stringWithFormat:@"-%@", [formatter stringFromDate:remainingTime]]];
        
        [fullScreenSlider setHidden:NO];
        //        [liveLabel setHidden:YES];
    }

}
- (void)refreshProgressIndicator {
    CGFloat duration = CMTimeGetSeconds(currentItem.asset.duration);
    
    if (duration == 0 || isnan(duration)) {
        // Video is a live stream
        [currentTimeLabel setText:nil];
        [remainingTimeLabel setText:nil];
        [normalSlider setHidden:YES];
//        [liveLabel setHidden:NO];
    }
    
    else {
        CGFloat current = seeking ?
        normalSlider.value * duration :         // If seeking, reflects the position of the slider
        CMTimeGetSeconds(player.currentTime); // Otherwise, use the actual video position
        
        [normalSlider setValue:(current / duration)];
        [normalSlider setSecondaryValue:([self availableDuration] / duration)];

        // Set time labels
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:(duration >= 3600 ? @"hh:mm:ss": @"mm:ss")];
        
        NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:current];
        NSDate *remainingTime = [NSDate dateWithTimeIntervalSince1970:(duration - current)];
        
        [currentTimeLabel setText:[formatter stringFromDate:currentTime]];
        [remainingTimeLabel setText:[NSString stringWithFormat:@"-%@", [formatter stringFromDate:remainingTime]]];
        [normalSlider setHidden:NO];
//        [liveLabel setHidden:YES];
    }
}

- (void)showControllers {
    [btnExpand setAlpha:1.0];

    if(_hasController){
    [UIView animateWithDuration:0.2f animations:^{
        [controllersView setAlpha:1.0f];
        [controllersFullScreenView setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [controllersTimer invalidate];
        
        if (controllersTimeoutPeriod > 0) {
            controllersTimer = [NSTimer scheduledTimerWithTimeInterval:controllersTimeoutPeriod
                                                                target:self
                                                              selector:@selector(hideControllers)
                                                              userInfo:nil
                                                               repeats:NO];
        }
    }];
    }
}

- (void)hideControllers {
    [UIView animateWithDuration:0.5f animations:^{
        [btnExpand setAlpha:0.0];
        [controllersView setAlpha:0.0f];
        [controllersFullScreenView setAlpha:0.0f];
    }];
}

#pragma mark - Public Methods

- (void)prepareAndPlayAutomatically:(BOOL)playAutomatically {
    if (player) {
        [self stop];
    }
    isReady = NO;
    player = [[AVPlayer alloc] initWithPlayerItem:nil];
    player.volume = 0.5;
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSArray *keys = [NSArray arrayWithObject:@"playable"];
    
    __weak typeof(self) weakSelf = self;
    [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        @try{
            [weakSelf.currentItem removeObserver:self forKeyPath:@"status" context:nil];
            weakSelf.currentItem = [AVPlayerItem playerItemWithAsset:asset];
            [weakSelf.player replaceCurrentItemWithPlayerItem:weakSelf.currentItem];
            
            if (playAutomatically) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [weakSelf play];
                });
            }
        }@catch(id anException){
            //do nothing, obviously it wasn't attached because an exception was thrown
        }
       
    }];
    if (self.current ==0) {
        prevButton.enabled = NO;
    }else{
        prevButton.enabled = YES;
    }
    if (self.current == self.total - 1) {
        nextButton.enabled = NO;
    }else{
        nextButton.enabled = YES;
    }
    if (self.total == 1) {
        prevButton.hidden = YES;
        nextButton.hidden = YES;
    }
    lbTitle.text   = filmname;
    [player setAllowsExternalPlayback:YES];
    playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];

    if (isInit == YES) {
        [playerLayer removeFromSuperlayer];
        
    }
    [self.layer addSublayer:playerLayer];
    isInit = YES;
    if(fullscreen){
//        [UIView animateWithDuration:0.1 animations:^{
//             [playerLayer setFrame:CGRectMake(0, 0, CGRectGetHeight([[UIScreen mainScreen] bounds]), CGRectGetWidth([[UIScreen mainScreen] bounds]))];
//        } completion:^(BOOL finished) {
            [self changeViewToLandcape];
//        }];
       
        
//        self.layer.backgroundColor = [UIColor redColor].CGColor;

    }else{
        defaultFrame = self.frame;
        
        CGRect frame = self.frame;
        frame.origin = CGPointZero;
        
        [playerLayer setFrame:frame];
    }

  
//    [playerLayer setFrame:CGRectMake(0, 0, 100, 100)];
    [self bringSubviewToFront:btnExpand];
    [self bringSubviewToFront:controllersView];
    [self bringSubviewToFront:controllersFullScreenView];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [player addObserver:self forKeyPath:@"rate" options:0 context:nil];
    [currentItem addObserver:self forKeyPath:@"status" options:0 context:nil];
    
    [player seekToTime:kCMTimeZero];
    [player setRate:0.0f];
    [playButton setSelected:YES];
    [fplayButton setSelected:YES];
//     [self addIndicator];
    if (playAutomatically) {
//        [self bringSubviewToFront:movieIndicator];
//        movieIndicator.hidden = NO;
//        movieIndicator.alpha = 1.0;
//        [movieIndicator startAnimating];
    }
}

- (void)clean {
    
    [progressTimer invalidate];
    progressTimer = nil;
    [fullScreenProgressTimer invalidate];
    fullScreenProgressTimer = nil;
    [controllersTimer invalidate];
    controllersTimer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPVolumeViewWirelessRoutesAvailableDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPVolumeViewWirelessRouteActiveDidChangeNotification object:nil];
    
    [player setAllowsExternalPlayback:NO];
    [self stop];
//    if (player respondsToSelector:<#(SEL)#>) {
//        <#statements#>
//    }
//    [player removeObserver:self forKeyPath:@"rate"];
    [self setPlayer:nil];
    [self.playerLayer removeFromSuperlayer];
    [self setPlayerLayer:nil];
    [self removeFromSuperview];
}

- (void)play {
    [player play];
    
    [playButton setSelected:YES];
    [fplayButton setSelected:YES];
    progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                     target:self
                                                   selector:@selector(refreshProgressIndicator)
                                                   userInfo:nil
                                                    repeats:YES];
    fullScreenProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                     target:self
                                                   selector:@selector(refreshFullscreenSlider)
                                                   userInfo:nil
                                                    repeats:YES];
}

- (void)pause {
    [player pause];
    [playButton setSelected:NO];
    [fplayButton setSelected:NO];
    if ([delegate respondsToSelector:@selector(playerDidPause)]) {
        [delegate playerDidPause];
    }
}

- (void)stop {
    if (player) {
        [player pause];
        [player seekToTime:kCMTimeZero];
        
        [playButton setSelected:NO];
        [fplayButton setSelected:NO];
//        [self.currentItem removeObserver:self forKeyPath:@"status"];
        [self.player removeObserver:self forKeyPath:@"rate"];
        [playerLayer removeFromSuperlayer];
        
    }
    //
    if (normalSlider) {
        normalSlider.value = 0;
    }
    if (fullScreenSlider) {
        fullScreenSlider.value = 0;

    }
}

- (BOOL)isPlaying {
    return [player rate] > 0.0f;
}

#pragma mark - AV Player Notifications and Observers

- (void)playerDidFinishPlaying:(NSNotification *)notification {
    [self stop];
    
    if (fullscreen) {
        [self toggleFullscreen:fullscreenButton];
    }
    
    if ([delegate respondsToSelector:@selector(playerDidEndPlaying)]) {
        [delegate playerDidEndPlaying];
    }
}

- (void)playerFailedToPlayToEnd:(NSNotification *)notification {
    [self stop];
    
    if ([delegate respondsToSelector:@selector(playerFailedToPlayToEnd)]) {
        [delegate playerFailedToPlayToEnd];
    }
}

- (void)playerStalled:(NSNotification *)notification {
    [self togglePlay:playButton];
    [self toggleFullscreen:fplayButton];
    if ([delegate respondsToSelector:@selector(playerStalled)]) {
        [delegate playerStalled];
    }
}


- (void)airPlayAvailabilityChanged:(NSNotification *)notification {
    [UIView animateWithDuration:0.4f
                     animations:^{
                         if ([volumeView areWirelessRoutesAvailable]) {
                             [volumeView hideByWidth:NO];
                         } else if (! [volumeView isWirelessRouteActive]) {
                             [volumeView hideByWidth:YES];
                         }
                         [self layoutIfNeeded];
                     }];
}


- (void)airPlayActivityChanged:(NSNotification *)notification {
    [UIView animateWithDuration:0.4f
                     animations:^{
                         if ([volumeView isWirelessRouteActive]) {
                             if (fullscreen)
                                 [self toggleFullscreen:fullscreenButton];
                             
                             [playButton hideByWidth:YES];
                             [fplayButton hideByWidth:YES];
                             [fullscreenButton hideByWidth:YES];
                             [spacerView hideByWidth:NO];
                             
                             [airPlayLabel setHidden:NO];
                             
                             controllersTimeoutPeriod = 0;
                             [self showControllers];
                         } else {
                             [playButton hideByWidth:NO];
                             [fplayButton hideByWidth:NO];
                             [fullscreenButton hideByWidth:NO];
                             [spacerView hideByWidth:YES];
                             
                             [airPlayLabel setHidden:YES];
                             
                             controllersTimeoutPeriod = 3;
                             [self showControllers];
                         }
                         [self layoutIfNeeded];
                     }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        if (currentItem.status == AVPlayerItemStatusFailed) {
            if ([delegate respondsToSelector:@selector(playerFailedToPlayToEnd)]) {
                [delegate playerFailedToPlayToEnd];
            }
        }
    }
    
    if ([keyPath isEqualToString:@"rate"]) {
        CGFloat rate = [player rate];
        if (rate > 0) {
//            [movieIndicator stopAnimating];
            isReady = YES;
            if ([delegate respondsToSelector:@selector(playerDidPlaying)]) {
                [delegate playerDidPlaying];
            }
        }
    }
}
-(void)volumeChanged:(UISlider *)slider{
    CGFloat vlume = slider.value/100.0;

    if ([player respondsToSelector:@selector(setVolume:)]) {
        player.volume =vlume;
    } else {
        NSArray *audioTracks = currentItem.asset.tracks;
        
        // Mute all the audio tracks
        NSMutableArray *allAudioParams = [NSMutableArray array];
        for (AVAssetTrack *track in audioTracks) {
            AVMutableAudioMixInputParameters *audioInputParams =[AVMutableAudioMixInputParameters audioMixInputParameters];
            [audioInputParams setVolume:vlume atTime:kCMTimeZero];
            [audioInputParams setTrackID:[track trackID]];
            [allAudioParams addObject:audioInputParams];
        }
        AVMutableAudioMix *audioZeroMix = [AVMutableAudioMix audioMix];
        [audioZeroMix setInputParameters:allAudioParams];
        
        [currentItem setAudioMix:audioZeroMix]; // Mute the player item
    }

}
- (void)volumeChangedz:(NSNotification *)notification
{
    float vol=
    [[[notification userInfo]
      objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"]
     floatValue];
    [volume setValue:vol * 100 animated:YES];
    // Do stuff with volume
}
-(void)updatePlayerLayer{

    if (fullscreen) {
        playerLayer.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
    }else{
        CGRect frame = self.frame;
        frame.origin = CGPointZero;
        playerLayer.frame = frame;
    }
    [self layoutIfNeeded];
}
- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index {
    return [ColorSchemeHelper sharedNationHeaderColor];
}
- (void)dealloc {
    NSLog(@"dealloc");
}

#pragma mark - Button Actions

-(void)pressedExpand:(UIButton *)sender{
    if (self.originsize) {
//        btnExpand.selected = YES;
//        btnExpand.backgroundColor = [UIColor redColor];
        [delegate playerDidExpandLess];
    }else{
//        btnExpand.selected = NO;
        [delegate playerDidExpandMore];
    }
}

-(void)pressedNext:(UIButton *)sender{
    [delegate playerDidNext];
}

-(void)pressedPrev:(UIButton *)sender{
    [delegate playerDidPrevious];
}

@end
