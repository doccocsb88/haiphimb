//
//  PlayVideoViewController.m
//  SlideMenu
//
//  Created by Apple on 5/30/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import "PlayVideoViewController.h"
#import "FBLoginDialogViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "TabInfoView.h"
#import "TabRelateView.h"
#import "TabOverview.h"
#import "FilmInfoDetails.h"
#import "ColorSchemeHelper.h"
#import "Genre.h"
#import "RelateFilmViewController.h"
#import "EmployeeDbUtil.h"
#import "UserDataFilm.h"
#import "MONActivityIndicatorView.h"
#import "AppDelegate.h"
#import "GuidePlayerView.h"
#import "UserDataFilm.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#define BUTTON_PLAY_SIZE 40
#define NAVBAR_HEIGHT 64
NSString *const PlayMovieTabpped = @"PlayMovieTabpped";

const NSString *API_URL_WHATCH_FILM = @"http://www.phimb.net/json-api/movies.php?v=538c7f456122cca4d87bf6de9dd958b5%2F";

@interface PlayVideoViewController () <PlayMovieDelegate,UIGestureRecognizerDelegate,RelateFilmViewControllerDelegate,MONActivityIndicatorViewDelegate,GUIPlayerViewDelegate>
{
    NSArray *genraData;
    CGFloat viewWidth;
    CGFloat viewHeight;
    CGFloat marginTop;
    CGFloat infoMarginTop;
    CGFloat btnTabWidth;
    NSMutableData *receivedData;
    CGFloat keyboardHeight;
    CGFloat playerHeight;
    CGFloat infoHeight;
    CGFloat movieRatio;
    BOOL allowRotation;
    NSArray *_serverA;
    NSArray *_serverB;
    NSTimer *_timer;
    CGFloat videoMinimumWidth;
    
}
@property (nonatomic ,strong)     NSURL *movieURL;
@property (nonatomic ,strong)     NSIndexPath *curIndexPath;
//= [NSURL URLWithString:@"http://techslides.com/demos/sample-videos/small.mp4"];
@property (strong,nonatomic) FilmInfoDetails *infoDetail;
@property (nonatomic,assign) NSInteger mpCurrentState;
@property (strong, nonatomic)  UIView *ctrStyleView;

@property (strong, nonatomic) TabInfoView *infoView;
@property (strong, nonatomic) TabRelateView *relateView;
@property (strong, nonatomic) TabOverview *overviewView;
@property (strong, nonatomic) TabCommentView *commentView;
@property (strong, nonatomic) UIView *tabViewHightLight;
//@property (strong, nonatomic) UIView *bgHeadrView;
@property (strong, nonatomic) MONActivityIndicatorView *movieIndicator;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic)  UIView *tabviewPanel;
@property (nonatomic, assign) CGPoint preVelocity;
@property (nonatomic,assign) BOOL showPanel;
@property (nonatomic,strong) EmployeeDbUtil *dbManager;
//@property (nonatomic, strong) UIButton *btnClose;
@property (strong, nonatomic) GUIPlayerView *playerView;
@property (strong, nonatomic) GuidePlayerView *guideView;
@property (strong, nonatomic) UserDataFilm *previousEpsider;
@property (nonatomic, strong) GADBannerView *bannerView;

@end

@implementation PlayVideoViewController
//@synthesize playvideoDelegate;
@synthesize filmInfo;
@synthesize movieURL, curIndexPath,rightButton,originSize;
@synthesize playerView, movieIndicator;
//@synthesize btnTabInfo;
//@synthesize btnTabRelative;
-(id)init{
    self = [super init];
    if(self){
        self.view.backgroundColor = [UIColor clearColor];
        self.mpCurrentState = MPMoviePlaybackStateStopped;
    }
    return self;
    
}
-(id)initWithInfo:(SearchResultItem *)info{
    self = [super init];
    if(self){

        self.view.backgroundColor = [UIColor clearColor];
        self.mpCurrentState = MPMoviePlaybackStateStopped;
        NSString *deviceString =[[UIDevice currentDevice] platformString];
        if ([deviceString containsString:@"iPad"]) {
            ((AppDelegate *)[[UIApplication sharedApplication] delegate]).allowRotation = YES;
            
        }else{
            ((AppDelegate *)[[UIApplication sharedApplication] delegate]).allowRotation = NO;
        }
        NSLog(@"filmID : %ld",filmInfo._id);

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor redColor ];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else
    {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:@"UIDeviceOrientationDidChangeNotification"
                                               object:nil];
    NSString *deviceString =[[UIDevice currentDevice] platformString];
    if ([deviceString containsString:@"iPad"]) {
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).allowRotation = YES;
        videoMinimumWidth = CGRectGetWidth([[UIScreen mainScreen] bounds])/2;

    }else{
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).allowRotation = NO;
        videoMinimumWidth = CGRectGetWidth([[UIScreen mainScreen] bounds])*2/3;
    }
    [self supportedInterfaceOrientations];
    [self shouldAutorotate];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"guideplayer"] == nil) {
        _guideView = [[GuidePlayerView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_guideView];
    }
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    originSize = YES;
    self.dbManager = [[EmployeeDbUtil alloc] init];
    [self.dbManager initDatabase];
    NSLog(@"filmID : %ld",filmInfo._id);
    [self setupGestures];
   
    NSLog(@"marginTop %f",marginTop);
    // Do any additional setup after loading the view.
  
//    [self callWebService];
    [self initViews];
    [self addIndicator];
    self.bannerView = [[GADBannerView alloc] initWithAdSize:GADAdSizeFromCGSize(CGSizeMake(320, 50))];
    self.bannerView.frame= CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
    
    self.bannerView.adUnitID = @"ca-app-pub-1737618998941554/9716869826";
    self.bannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    // Requests test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made. GADBannerView automatically returns test ads when running on a
    // simulator.
//    request.testDevices = @[
//                            @"31d3e2f86e101c729ad91ba5134da532133c490c"  // Eric's iPod Touch
//                            ];
    [self.bannerView loadRequest:request];
    [self.view addSubview:self.bannerView];
}
- (BOOL)prefersStatusBarHidden {
    return originSize;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_guideView) {
        [self.view bringSubviewToFront:_guideView];

    }
    [_btnTabRelative sendActionsForControlEvents:UIControlEventTouchUpInside];
//    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
//        // portrait
//        
//    } else {
//        // landscape
//        //        [playerView  toggleFullscreen:playerView.fullscreenButton];
//        
////    self.view.transform = CGAffineTransformMakeRotation(90 * M_PI/180);
//        
//    }
////    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
////    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//    self.view.backgroundColor = [UIColor redColor];
    NSLog(@"filmID : %ld",filmInfo._id);
    self.previousEpsider = [self.dbManager getUserDataByFilmId:filmInfo._id];
    if (self.previousEpsider) {
        NSLog(@"current: %@",self.previousEpsider.currentEpsider);

    }

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}
-(void) initParams{
    _currentTab = TAB_INFO;
    viewHeight = self.view.frame.size.height;
    viewWidth  = self.view.frame.size.width;
    marginTop = 0;
    infoMarginTop = marginTop + playerHeight;
    btnTabWidth = viewWidth/3;
    genraData = @[
                  [Genre itemWithTitle:@"Action Films" withKey:@"hanh-dong"],
                  [Genre itemWithTitle:@"Adventure Films" withKey:@"phieu-luu"],
                  [Genre itemWithTitle:@"Romance Films" withKey:@"tinh-cam"],
                  [Genre itemWithTitle:@"Drama Films" withKey:@"tam-ly"],
                  [Genre itemWithTitle:@"Kungfu Films" withKey:@"vo-thuat"],
                  [Genre itemWithTitle:@"Costume Films" withKey:@"co-trang"],
                  [Genre itemWithTitle:@"Funny Films" withKey:@"hai-huoc"],
                  [Genre itemWithTitle:@"Musical Films" withKey:@"ca-nhac"],
                  [Genre itemWithTitle:@"Comedy Films" withKey:@"hai-kich"],
                  [Genre itemWithTitle:@"Crime Films" withKey:@"hinh-su"],
                  [Genre itemWithTitle:@"War Films " withKey:@"chien-tranh"]];

}
-(void)initViews{
    [self initParams];
    [self caculatePlayerHeight];
    [self styleNavBar];
    [self initMovieIndicator];

    [self initViewInfo];
    [self initTabView];

    [self initPreviewImage];
    //[self createControllStyleView];
    [self initMoviePlayerView];

    [self initPlayFilmController];
    [self initNotification];

}

- (void)styleNavBar {

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)shouldAutorotate{
    return NO;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait; // or Right of course
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark - SlideNavigationController Methods -

//- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
//{
//    return NO;
//}
//
//- (BOOL)slideNavigationControllerShouldDisplayRightMenu
//{
//    return YES;
//}
//
#pragma Reister NOtification
-(void)initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];
}

#pragma mark - InitView
-(void)initMovieIndicator{

//    _movieIndicator= [[MONActivityIndicatorView alloc] init];
//  
//    _movieIndicator.delegate = self;
//    _movieIndicator.numberOfCircles = 3;
//    _movieIndicator.radius = 10;
//    _movieIndicator.internalSpacing = 3;
//    CGSize size = [_movieIndicator intrinsicContentSize];
//    _movieIndicator.frame = CGRectMake((viewWidth-size.width)/2, marginTop + (playerHeight- size.height)/2, size.width, size.height);
//    [_movieIndicator startAnimating];
//    
//    [self.view addSubview:_movieIndicator];
////    [self placeAtTheCenterWithView:_movieIndicator];
//    
////    [NSTimer scheduledTimerWithTimeInterval:7 target:indicatorView selector:@selector(stopAnimating) userInfo:nil repeats:NO];
//    [NSTimer scheduledTimerWithTimeInterval:9 target:_movieIndicator selector:@selector(startAnimating) userInfo:nil repeats:NO];
}


#pragma mark -
#pragma mark - MONActivityIndicatorViewDelegate Methods

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index {
//    CGFloat red   = (arc4random() % 256)/255.0;
//    CGFloat green = (arc4random() % 256)/255.0;
//    CGFloat blue  = (arc4random() % 256)/255.0;
//    CGFloat alpha = 1.0f;
    //return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    return [ColorSchemeHelper sharedNationHeaderColor];
}

-(void)initMoviePlayerView{


//    self.btnClose = [[UIButton alloc] initWithFrame:CGRectMake(-20, -20, 40, 40)];
//    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
//    bgView.layer.cornerRadius = 15.0;
////    bgView.layer.cornerRadius = 20.0;
//    bgView.layer.masksToBounds = YES;
//    bgView.layer.borderColor = [UIColor whiteColor].CGColor;
//    bgView.layer.borderWidth = 1.0;
//    bgView.backgroundColor = [UIColor redColor];
//    bgView.contentMode = UIViewContentModeScaleAspectFit;
//    bgView.image = [UIImage imageNamed:@"ic_button_close.png"];
//    [self.btnClose addSubview:bgView];
//    bgView.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
//    [self.btnClose setImage:[UIImage imageNamed:@"ic_button_close.png"] forState:UIControlStateNormal];
//    [self.view addSubview:self.btnClose];
//    [self.btnClose addTarget:self action:@selector(pressedClose:) forControlEvents:UIControlEventTouchUpInside];
    //
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//
    playerView = [[GUIPlayerView alloc] initWithFrame:CGRectMake(0, 0, width, playerHeight)];
    [playerView setTintColor:[UIColor clearColor]];
    [playerView setBufferTintColor:[UIColor redColor]];
    [playerView setDelegate:self];
    [[self view] addSubview:playerView];
   
}
-(void)initPlayFilmController{

    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_play.png"]];
    backImg.frame =CGRectMake(0, 0,30  , 30);
    
    _btnBack = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [_btnBack addTarget:self action:@selector(pressCloseMoviePlayerView:) forControlEvents:UIControlEventTouchUpInside];
    [_btnBack addSubview:backImg];
    _btnBack.backgroundColor = [UIColor redColor];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(pressCloseMoviePlayerView:)
//                                                 name:MPMoviePlayerWillExitFullscreenNotification
//                                               object:nil];

}
-(void)initTabView{
    UIFont *font  = [UIFont systemFontOfSize:13.f];

    _tabviewPanel = [[UIView alloc]initWithFrame:CGRectMake(0, playerHeight+infoHeight, viewWidth, 30)];
    _tabviewPanel.backgroundColor = [UIColor whiteColor];
    CGFloat tabMargin = (btnTabWidth-100)/2;
    _btnTabInfo = [[UIButton alloc] initWithFrame:CGRectMake(tabMargin, 0, 100, 30)];
    [_btnTabInfo setTag:1];
    [_btnTabInfo setTitle:@"Overview" forState:UIControlStateNormal];
    _btnTabInfo.titleLabel.font = font;
    [_btnTabInfo setTintColor:[UIColor blackColor]];

    //[_btnTabInfo setTitleColor:[ColorSchemeHelper sharedTabTextColor] forState:UIControlStateNormal];
    [_btnTabInfo addTarget:self action:@selector(pressInfoTab:) forControlEvents:UIControlEventTouchUpInside];
    //
    _btnTabRelative = [[UIButton alloc] initWithFrame:CGRectMake(btnTabWidth +tabMargin, 0, 100, 30)];
    [_btnTabRelative setTag:2];
    _btnTabRelative.titleLabel.font = font;
    [_btnTabRelative setTintColor:[UIColor blackColor]];

    [_btnTabRelative setTitle:@"Episodes" forState:UIControlStateNormal];
    _btnTabRelative.backgroundColor = [UIColor whiteColor];
//    _btnTabRelative.alpha = 0.5f;
    //[_btnTabRelative setTitleColor:[ColorSchemeHelper sharedTabTextColor] forState:UIControlStateNormal];
    [_btnTabRelative addTarget:self action:@selector(pressRelateTab:) forControlEvents:UIControlEventTouchUpInside];
    //btnTabComment
    _btnTabComment = [[UIButton alloc] initWithFrame:CGRectMake(btnTabWidth*2+tabMargin, 0, 100, 30) ];
    [_btnTabComment setTag:3];
    [_btnTabComment setTitle:@"Comments" forState:UIControlStateNormal];
    //[_btnTabComment setTitleColor:[ColorSchemeHelper sharedTabTextColor] forState:UIControlStateNormal];
    _btnTabComment.backgroundColor = [UIColor whiteColor];
    _btnTabComment.titleLabel.font = font;
    [_btnTabComment addTarget:self action:@selector(pressedTab:) forControlEvents:UIControlEventTouchUpInside];

//addToMainView
    [_btnTabInfo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnTabRelative setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnTabComment setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [_tabviewPanel addSubview:_btnTabInfo];
    [_tabviewPanel addSubview:_btnTabRelative];
    [_tabviewPanel addSubview:_btnTabComment];
    _tabViewHightLight = [[UIView alloc] initWithFrame:CGRectMake(btnTabWidth/4, 28, btnTabWidth/2, 2)];
    _tabViewHightLight.backgroundColor = [ColorSchemeHelper sharedMovieInfoTitleColor];
    [_tabviewPanel addSubview:_tabViewHightLight];
    [_tabviewPanel.layer setCornerRadius:0];
    [_tabviewPanel.layer setShadowColor:[UIColor blackColor].CGColor];
    [_tabviewPanel.layer setShadowOpacity:0.3];
    [_tabviewPanel.layer setShadowOffset:CGSizeMake(2, 2)];
    [self.view addSubview:_tabviewPanel];
}
-(void)initPreviewImage{
    CGFloat preImgHeight=playerHeight;
    _previewImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,marginTop, viewWidth, preImgHeight)];
    _previewImage.contentMode = UIViewContentModeScaleToFill;
    _previewImage.image = [UIImage imageNamed:@""];
    _btnPlay = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth/2 - BUTTON_PLAY_SIZE/2, marginTop + preImgHeight/2 - BUTTON_PLAY_SIZE/2, BUTTON_PLAY_SIZE, BUTTON_PLAY_SIZE)];
    UIImageView *playImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_play.png"]];
    playImg.frame =CGRectMake(0, 0, BUTTON_PLAY_SIZE, BUTTON_PLAY_SIZE);
    [_btnPlay setUserInteractionEnabled:NO];
    [_btnPlay addSubview:playImg];
    [_btnPlay addTarget:self action:@selector(pressPlay:) forControlEvents:UIControlEventTouchUpInside];
    [_btnPlay setHidden:YES];
    [self.view addSubview:_btnPlay];
    //init backButton
  
}
-(void)initViewInfo{

    NSString *deviceString =[[UIDevice currentDevice] platformString];
    if ([deviceString containsString:@"iPad"]) {
        infoHeight = playerHeight *2/3;
    }else{
        infoHeight = playerHeight;
    }
     _infoView= [[TabInfoView alloc] initWithFrame: CGRectMake(0, playerHeight, self.view.frame.size.width, infoHeight)];
       _infoView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:_infoView];
    //initscroll
    CGFloat scrollH =viewHeight - infoMarginTop - (playerHeight+30) - 50;
//    infoMarginTop+playerHeight
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, playerHeight + infoHeight+30, viewWidth*3, scrollH)];
    _scrollView.contentSize = CGSizeMake(viewWidth*2, scrollH);
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:_scrollView];
    //
    _relateView =[[TabRelateView alloc] initWithFrame: CGRectMake(viewWidth, 0, viewWidth, scrollH-20)];
    _relateView.backgroundColor = [UIColor whiteColor];
//    [_relateView setHidden:YES];
    _relateView.playvideoDelegate = self;
    _overviewView = [[TabOverview alloc] initWithInfo:@"kjdfkjdk" descriotion:@"kkjdkfjdkjf" frame:CGRectMake(0, 0, viewWidth, scrollH-20)];
    _overviewView.backgroundColor = [UIColor whiteColor];
    _commentView = [[TabCommentView alloc] initWithFrameX:CGRectMake(viewWidth*2, 0, viewWidth, viewHeight - infoMarginTop -  (playerHeight+30)) ];
    _commentView.backgroundColor = [UIColor whiteColor];
    _commentView.webDelegate = self;
//    _commentView = [[TabCommentView alloc] initWithFrameX:CGRectMake(0, 0, viewWidth, viewHeight) ];
//
    [_commentView requestFilmComment:filmInfo._id];
//    _commentView.backgroundColor = [UIColor blueColor];
    //
    _commentView.backgroundColor = [UIColor redColor];
    [_scrollView addSubview:_commentView];
    [_scrollView addSubview:_overviewView];
    [_scrollView addSubview:_relateView];

    
}

-(void)setupGestures {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveTabPanel:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    [self.view addGestureRecognizer:panRecognizer];
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:gestureRecognizer];
}
-(void)swipeHandler:(UISwipeGestureRecognizer *)recognizer {
    NSLog(@"Swipe received.");
}
-(void)prepareFilmData : (SearchResultItem *)item{
    filmInfo = item;
   // _previewImage.image = [UIImage imageNamed:@""];
    //
    [_infoView setInfoThumbnail:filmInfo.thumbnail andUrl:filmInfo.img];
    if(filmInfo.hasData==NO){
        NSString *url =@"";
        if(filmInfo.imglanscape &&  ![filmInfo.imglanscape isEqualToString:@""]){
            url = filmInfo.imglanscape;
        }else{
            url = filmInfo.img;
        }
        NSLog(@"filmThumbanilURL %@ -%@ - %@ %d",url,filmInfo.img,filmInfo.imglanscape,filmInfo._id);
        NSURL *imageURL = [NSURL URLWithString:url];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                _previewImage.image = [UIImage imageWithData:imageData];

                NSLog(@"previewImageHeight %f",_previewImage.frame.size.height);
            });
        });
    }else{
        _previewImage.image = filmInfo.thumbnail;
    }
    [self callWebService];
}
#pragma Mark - TouchNotification
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"touchesEnded %d",originSize);
//    if (!originSize) {
////        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:touches forKey:@"touchesKey"];
////        
////        [[NSNotificationCenter defaultCenter] postNotificationName:@"playmovieTouch" object:nil userInfo:userInfo];
////        for (UITouch *aTouch in touches) {
////            if (aTouch.tapCount >= 2) {
////                // The view responds to the tap
////                NSLog(@"multiTouch");
////            }else{
////                NSLog(@"singleTouch");
////            }
////        }
//    }
//}
#pragma mark - Action

-(void)moveTabPanel:(id)sender {
    if (playerView.fullscreen) {
        return;
    }
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    CGPoint currentlocation = [sender locationInView:self.view];
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
   
        
    

    if (self.view.frame.origin.y == 0 && (currentlocation.y < 0 || currentlocation.y > playerView.frame.size.height)) {
        return;
    }
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
       // UIView *childView = nil;
        
        if(velocity.x > 0) {
//            if (!_showingRightPanel) {
//                childView = [self getLeftView];
//            }
        } else {
//            if (!_showingLeftPanel) {
//                childView = [self getRightView];
//            }
            
        }
        // make sure the view we're working with is front and center
        //[self.view sendSubviewToBack:childView];
        //[[sender view] bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        if (originSize == NO) {
            if (self.view.frame.origin.x < self.view.frame.size.width/6) {
                [self performSelector:@selector(pressedClose:) withObject:nil afterDelay:0];        }
            self.playerView.alpha = 1;
        }
       

        if (!_showPanel) {
            [self moveTabPanelToOriginalPosition];
        } else {
            NSLog(@"TAB : MORE THAN HALF");

            if (_currentTab == TAB_INFO) {
                [self pressRelateTab:nil];
            }  else if (_currentTab == TAB_RELATIVE) {
                if(_preVelocity.x < 0){
                    [self pressCommentTab:nil];

                }else{
                    [self pressInfoTab:nil];
                }
                NSLog(@"direction :: %f",_preVelocity.x);
            }else if(_currentTab == TAB_COMMENT){
                [self pressRelateTab:nil];
            }
        }
        CGFloat curW = self.view.frame.size.width;
        CGFloat curY = self.view.frame.origin.y ;
        if (curW > viewWidth*2/3 ||  curY < viewHeight/2) {
            [self scaleViewToOriginalSize];
            
        }else{
            [self scaleViewToMinimumSize];
        }
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        if(velocity.x > 0) {
             NSLog(@"gesture went right");
        } else {
             NSLog(@"gesture went left");
        }
        if (velocity.x > velocity.y) {
            
        }
        CGFloat infoPos = _infoView.frame.size.height + _infoView.frame.origin.y;
        if(currentlocation.y < infoPos){
            CGFloat deltaX = velocity.x - _preVelocity.x;
            CGFloat delta = velocity.y - _preVelocity.y;

            
            if (deltaX > delta && originSize == NO) {
                if (velocity.x < 0) {
                    if (self.view.frame.origin.x + velocity.x/20 > 0) {
                        self.view.frame = CGRectMake(self.view.frame.origin.x + velocity.x/30, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                        self.playerView.alpha = self.playerView.alpha - 0.01;
                    }else{
                        [self performSelector:@selector(pressedClose:) withObject:nil afterDelay:0];
                        
                    }
                }
                
                
            }else{
            CGFloat delta = velocity.y - _preVelocity.y;
            if(abs(delta)>20 && velocity.y){
                if(velocity.y > 0){
                    NSLog(@"gesture went down: %f - %d",delta,abs(delta));
                }else{
                    NSLog(@"gesture went up: %f - %d",delta,abs(delta));
                    
                }
                [self scalePlayView:velocity];
                _preVelocity = velocity;
            }
            NSLog(@"deltaYYY%f",delta);
            }
            
            
        }else  if(currentlocation.y>=infoMarginTop+playerHeight+30){
            
            
            if (_currentTab== TAB_COMMENT && velocity.x > 0) {
                
//                _showPanel = abs(_commentView.center.x - self.view.frame.size.width/2) > self.view.frame.size.width/3;
//                _overviewView.center = CGPointMake(_overviewView.center.x + translatedPoint.x, _overviewView.center.y);
//                _relateView.center = CGPointMake(_relateView.center.x + translatedPoint.x, _relateView.center.y);
//                _commentView.center = CGPointMake(_commentView.center.x + translatedPoint.x, _commentView.center.y);
//                _tabViewHightLight.center =  CGPointMake(_tabViewHightLight.center.x - translatedPoint.x/3, _tabViewHightLight.center.y);
//                NSLog(@"currentTabView 1 %d",_showPanel);
                
            }else if(_currentTab == TAB_INFO && velocity.x < 0){
                NSLog(@"currentTabView 2");
                
//                _showPanel = abs(_overviewView.center.x - self.view.frame.size.width/2) > self.view.frame.size.width/3;
//                _overviewView.center = CGPointMake(_overviewView.center.x + translatedPoint.x, _overviewView.center.y);
//                _relateView.center = CGPointMake(_relateView.center.x + translatedPoint.x, _relateView.center.y);
//                _commentView.center = CGPointMake(_commentView.center.x + translatedPoint.x, _commentView.center.y);
//                
//                _tabViewHightLight.center =  CGPointMake(_tabViewHightLight.center.x - translatedPoint.x/3, _tabViewHightLight.center.y);
                
            }else if(_currentTab == TAB_RELATIVE){
                NSLog(@"currentTabView 3");
//                CGFloat centerX = _relateView.center.x;
//                _showPanel = abs(_relateView.center.x - self.view.frame.size.width/2) > self.view.frame.size.width/3 ;
//                _overviewView.center = CGPointMake(_overviewView.center.x + translatedPoint.x, _overviewView.center.y);
//                _relateView.center = CGPointMake(_relateView.center.x + translatedPoint.x, _relateView.center.y);
//                _commentView.center = CGPointMake(_commentView.center.x + translatedPoint.x, _commentView.center.y);
//                
//                _tabViewHightLight.center =  CGPointMake(_tabViewHightLight.center.x - translatedPoint.x/3, _tabViewHightLight.center.y);
            }else{
                NSLog(@"currentTabView 4");
                _showPanel = FALSE;
                
            }
            [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
            _preVelocity = velocity;
            
        }
    }
    
}
-(void)scaleViewToMinimumSize{
   originSize = NO;
    self.playerView.originsize = originSize;
    self.playerView.btnExpand.selected = YES;
    CGFloat toX = viewWidth - videoMinimumWidth;
    CGFloat newW = viewWidth - toX;
    CGFloat pRatio = viewWidth/viewHeight;

    CGFloat toY = viewHeight-(playerHeight*(newW/viewWidth) + 50) ;
    CGRect infoFrame = _infoView.frame;
    CGRect scrollFrame = _scrollView.frame;
    CGRect tabFrame = _tabviewPanel.frame;
//    CGFloat newH = 
    [UIView animateWithDuration:0.3f animations:^{
//        self.view.frame = CGRectMake(0, 0, viewWidth, viewHeight);
        [self.view setFrame:CGRectMake(toX, toY, newW, viewHeight/pRatio)];
        CGRect playerFrame = self.playerView.frame;
        self.playerView.frame = CGRectMake(0, playerFrame.origin.y, newW, playerHeight*(newW/viewWidth));
        [playerView updatePlayerLayer];
//        CGRect preFrame = self.view.frame;

        _infoView.frame = CGRectMake(infoFrame.origin.x, toY+newW/pRatio, infoFrame.size.width, infoFrame.size.height);
        _tabviewPanel.frame= CGRectMake(tabFrame.origin.x, toY+newW/pRatio+infoFrame.size.height, tabFrame.size.width, tabFrame.size.height);
        _scrollView.frame= CGRectMake(scrollFrame.origin.x, toY+newW/pRatio+infoFrame.size.height +tabFrame.size.height, scrollFrame.size.width, scrollFrame.size.height);
        
        //    _movieIndicator.frame =CGRectMake(toX,toY, newW, newH);
        _btnPlay.center = playerView.center;
        _btnPlay.transform = CGAffineTransformMakeScale(newW/viewWidth,newW/viewWidth);
        //    CGSize size = [_movieIndicator intrinsicContentSize];
        //    _movieIndicator.center = playerView.center;
        //makeviewtransparent
        CGFloat alpha  = 0;
        //    _bgHeadrView.alpha = alpha;÷
        _infoView.alpha = alpha;
        _scrollView.alpha = alpha;
        _tabviewPanel.alpha = alpha;
//        self.btnClose.frame = CGRectMake(playerView.frame.origin.x - 20, playerView.frame.origin.y - 20, 40, 40);
//        self.btnClose.hidden = NO;
//        [self.view bringSubviewToFront:self.btnClose];
        
    } completion:^(BOOL finished){
        [self.view setFrame:CGRectMake(toX, toY, newW, playerHeight*pRatio)];
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
        {
            [self prefersStatusBarHidden];
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }
        else
        {
            // iOS 6
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        }
        self.playerView.hasController = NO;

        [self.playerView hideControllers];
    }];

}
-(void)scaleViewToOriginalSize{
    originSize = YES;
    self.playerView.originsize = originSize;
    self.playerView.btnExpand.selected = NO;

    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame = CGRectMake(0, 0, viewWidth, viewHeight);
        [self.playerView setFrame:CGRectMake(0, marginTop, viewWidth, playerHeight)];
        [playerView updatePlayerLayer];

//        [self.movieIndicator setFrame:CGRectMake(0, marginTop, viewWidth, playerHeight)];
//        [self.bgHeadrView setFrame:CGRectMake(0, 0, viewWidth, 64)];
       
        CGFloat scrollH =viewHeight - infoMarginTop - (playerHeight+30) - 50;
        //    infoMarginTop+playerHeight
        [_infoView setFrame:CGRectMake(0, infoMarginTop + playerHeight, self.view.frame.size.width, infoHeight)];
        [self.tabviewPanel setFrame:CGRectMake(0, infoMarginTop+playerHeight + _infoView.frame.size.height, viewWidth, 30)];
        [self.scrollView setFrame:CGRectMake(0, infoMarginTop + playerHeight+30 + _infoView.frame.size.height, viewWidth*3, scrollH)];
        [self.btnPlay setFrame:CGRectMake(viewWidth/2 - BUTTON_PLAY_SIZE/2, marginTop + viewHeight/8 - BUTTON_PLAY_SIZE/2, BUTTON_PLAY_SIZE, BUTTON_PLAY_SIZE)];
        self.btnPlay.center = self.playerView.center;
//        CGSize size = [_movieIndicator intrinsicContentSize];
//        _movieIndicator.frame = CGRectMake((viewWidth-size.width)/2, marginTop + (playerHeight - size.height)/2, size.width, size.height);
//        self.btnClose.frame =  CGRectMake(-20, -20, 40, 40);
//        self.btnClose.hidden = YES;
//        _infoView.alpha = 1.f;
        _scrollView.alpha = 1.f;
        _tabviewPanel.alpha = 1.f;
        _infoView.alpha = 1.0;
//        [self.bgHeadrView setAlpha:1.f];

    } completion:^(BOOL finished){
        self.playerView.hasController = YES;
        [self.playerView showControllers];

    }];
    
    
}
-(void)scalePlayView:(CGPoint)velectity{
    CGFloat ratio = viewWidth/viewHeight;
    CGRect preFrame = self.view.frame;
    CGFloat deltaX = 0;
    CGFloat deltaY = 0;
    CGFloat deltaH = 0;
    CGFloat deltaW = 0;
   
        deltaY = velectity.y/20;
    CGFloat pRatio = viewWidth/playerHeight;

    if(preFrame.size.width<=viewWidth && velectity.y > 0){
        deltaH = velectity.y/20;
        NSLog(@"----------------------");
    }else if(preFrame.size.width >=viewWidth/2 && velectity.y<0){
        deltaH = velectity.y/20;

    }
    deltaW = ratio*deltaH/2;
    deltaX = ratio*deltaY/2;
    CGFloat toY =  preFrame.origin.y + deltaY;
    CGFloat toX = preFrame.origin.x + deltaX;
    
    CGFloat newW = preFrame.size.width - deltaW;
    if (newW<videoMinimumWidth) {
        newW = videoMinimumWidth;
    }else if(newW>viewWidth){
        newW = viewWidth;
    }
    CGFloat newH = preFrame.size.height - deltaH;
    if (newH>viewHeight) {
        newH = viewHeight;
    }else if(newH< viewHeight - (newW/pRatio+10)){
        newH =  viewHeight - (newW/pRatio+10);
        
    }
    if(toY<0){
        toY = 0;
    }else if(toY>viewHeight-(newW/pRatio+ 50)){
        toY=viewHeight-(newW/pRatio + 50) ;
    }
    deltaY = toY - preFrame.origin.y;
    if(toX>viewWidth - videoMinimumWidth){
        toX = viewWidth- videoMinimumWidth;
    }else if(toX<0){
        toX = 0;
    }
//    self.view.frame = CGRectMake(toX,toY, newW, newH);
    CGRect playerFrame = playerView.frame;

    playerView.frame = CGRectMake(playerFrame.origin.x,playerFrame.origin.y, newW, newW/pRatio);
    self.view.frame =  CGRectMake(toX,toY, newW, newW/pRatio);
   

    [playerView updatePlayerLayer];
    CGFloat alpha  = (viewHeight - toY)/viewHeight;
//    if (velectity.y>0) {
//        alpha=alpha-0.005f;
//        alpha = alpha<0?0:alpha;
//    }else{
//        alpha=alpha+0.005f;
//        alpha=alpha>1?1:alpha;
//    }
//    CGRect headerFrame = _bgHeadrView.frame;
    //        self.view.alpha = alpha;
//    CGRect movieFrame = _moviePlayerController.view.frame;
    CGRect infoFrame = _infoView.frame;
    CGRect scrollFrame = _scrollView.frame;
    CGRect tabFrame = _tabviewPanel.frame;
//    CGFloat movieY = movieFrame.origin.y ;//-deltaY;
//    if(preFrame.origin.y>=0 && preFrame.origin.y<=74){
//        movieY-=deltaY;
//    }
//    if(movieY<0){
//        movieY = 0;
//    }else if(movieY>64){
//        movieY = 64;
//    }
//    _bgHeadrView.frame = CGRectMake(headerFrame.origin.x+(toX-preFrame.origin.x), headerFrame.origin.y+(toY-preFrame.origin.y) , headerFrame.size.width, headerFrame.size.height);

    _infoView.frame = CGRectMake(infoFrame.origin.x, playerFrame.origin.y+newW/pRatio, infoFrame.size.width, infoFrame.size.height);
    _tabviewPanel.frame= CGRectMake(tabFrame.origin.x, playerFrame.origin.y+newW/pRatio+infoFrame.size.height, tabFrame.size.width, tabFrame.size.height);
    _scrollView.frame= CGRectMake(scrollFrame.origin.x, playerFrame.origin.y+newW/pRatio+infoFrame.size.height +tabFrame.size.height, scrollFrame.size.width, scrollFrame.size.height);
  
//    _movieIndicator.frame =CGRectMake(toX,toY, newW, newH);
    _btnPlay.center = playerView.center;
    _btnPlay.transform = CGAffineTransformMakeScale(newW/viewWidth,newW/viewWidth);
//    CGSize size = [_movieIndicator intrinsicContentSize];
//    _movieIndicator.center = playerView.center;
    //makeviewtransparent
//    if(preFrame.origin.y>viewHeight/2){
//        alpha = 0.f;
//    }
//    _bgHeadrView.alpha = alpha;÷
    _infoView.alpha = alpha;
    _scrollView.alpha = alpha;
    _tabviewPanel.alpha = alpha;
//    self.btnClose.frame = CGRectMake(playerView.frame.origin.x - 20, playerView.frame.origin.y - 20, 40, 40);
//    self.btnClose.hidden = NO;
//    [self.view bringSubviewToFront:self.btnClose];
}
-(void)closeLoginView{
    [self.view bringSubviewToFront:_commentView];
    [_commentView setFrame:CGRectMake(10, infoMarginTop + playerHeight+30, viewWidth, viewHeight - infoMarginTop -210)];
    [_commentView.webview setFrame:(CGRectMake(5, 5, viewWidth-30, viewHeight-95))];
    NSLog(@"closeloginviewy");
}
-(void)showLoginView{
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(10, 10, viewWidth-20, viewHeight-20) ];
    
    NSString *fullURL = [NSString stringWithFormat:@"http://sukienmienbac.com.vn/phimbb.html"];
    NSURL *url = [NSURL URLWithString:fullURL];
    [web loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:web];
//    [self.view bringSubviewToFront:_commentView];
//    [_commentView setFrame:CGRectMake(10, 74, viewWidth-20, viewHeight-90)];
//    [_commentView.webview setFrame:(CGRectMake(5, 5, viewWidth-30, viewHeight-95))];
}
-(void)moveTabPanelToOriginalPosition{
    if(_currentTab == TAB_INFO){
        [self pressInfoTab:nil];
    }else if(_currentTab == TAB_RELATIVE){
        [self pressRelateTab:nil];
    }else{
        [self pressCommentTab:nil];
    }
}
-(void)pressedTab : (id)button{
    UIButton *btnTab = (UIButton *)button;
    NSInteger tag = btnTab.tag;
    if (tag==1) {
        [self pressInfoTab:button];
    }else if(tag==2){
        [self pressRelateTab:button];
    }else if(tag==3){
    
        [self pressCommentTab:button];
    }
  
}
-(void)pressCommentTab : (id)button{

    _currentTab = TAB_COMMENT;
    // _btnTabInfo.alpha = 1.0f;
    // _btnTabRelative.alpha = 0.5f;
    [UIView animateWithDuration:0.5f animations:^{
        CGRect fr =  _commentView.frame;
        [_relateView setFrame:CGRectMake(-viewWidth, fr.origin.y, fr.size.width, fr.size.height)];
        [_overviewView setFrame:CGRectMake(-2*viewWidth, fr.origin.y, fr.size.width, fr.size.height)];
        [_commentView setFrame:CGRectMake(0, fr.origin.y, fr.size.width, fr.size.height)];
        [_tabViewHightLight setFrame:CGRectMake(btnTabWidth*2+btnTabWidth/4, 28, btnTabWidth/2, 2)];
        
    }];
}
-(void)pressInfoTab:(id)button{
    _currentTab = TAB_INFO;
    [UIView animateWithDuration:0.5f animations:^{
        CGRect fr =  _overviewView.frame;
        [_relateView setFrame:CGRectMake(viewWidth, fr.origin.y, fr.size.width, fr.size.height)];
        [_overviewView setFrame:CGRectMake(0, fr.origin.y, fr.size.width, fr.size.height)];
        [_commentView setFrame:CGRectMake(2*viewWidth, fr.origin.y, fr.size.width, fr.size.height)];
        [_tabViewHightLight setFrame:CGRectMake(btnTabWidth/4, 28, btnTabWidth/2, 2)];
        
    }];
}
-(void)pressRelateTab:(id)button{
    
    _currentTab    = TAB_RELATIVE;
    [UIView animateWithDuration:0.5f animations:^{
        CGRect fr =  _relateView.frame;
        [_relateView setFrame:CGRectMake(0, fr.origin.y, fr.size.width, fr.size.height)];
        [_overviewView setFrame:CGRectMake(-viewWidth, fr.origin.y, fr.size.width, fr.size.height)];
        [_commentView setFrame:CGRectMake(viewWidth, fr.origin.y, fr.size.width, fr.size.height)];
        [_tabViewHightLight setFrame:CGRectMake(btnTabWidth+btnTabWidth/4, 28, btnTabWidth/2, 2)];
    }];
}
-(void)pressCloseMoviePlayerView : (id)button{
//    [self ]
//    [self.moviePlayerViewController.moviePlayer stop];
//    [self.moviePlayerController stop];
    [self dismissMoviePlayerViewControllerAnimated];

}
-(void)pressPlay : (id)button{
    
//    [[self navigationController] setNavigationBarHidden:YES animated:YES];
//    
//    [self.view addSubview:_moviePlayerController.view];
//
//    [self.moviePlayerController setContentURL:movieURL];
//    [self.moviePlayerController prepareToPlay];
    [_btnPlay setHidden:YES];
    [self.playerView play];
//    [self.view addSubview: self.ctrStyleView];
/*
    self.moviePlayerViewController.moviePlayer.shouldAutoplay = YES;
    if(self.moviePlayerViewController.moviePlayer.playbackState == MPMoviePlaybackStatePaused){
        [self.moviePlayerViewController.moviePlayer play];

    }
    [self presentMoviePlayerViewControllerAnimated:self.moviePlayerViewController];
*/
 }
-(void)pressCancel:(id)button{
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.moviePlayerController stop];
}


-(IBAction)btnMovePanelLeft:(id)sender {
    UIButton *button = sender;
    NSLog(@"PlayVideoBtnPanelLeft %d",button.tag);

    switch (button.tag) {
        case 0: {
            [_relateView setHidden:NO];
            [_commentView setHidden:NO];
            [_playDelegate movePanelToOriginalPosition];
            break;
        }
            
        case 1: {
            [_relateView setHidden:YES];
            [_commentView setHidden:YES];
            NSArray *cats = [self getListGenreKey:_infoDetail.cate];
            [_playDelegate movePanelLeft:[cats objectAtIndex:0]];
            break;
        }
            
        default:
            break;
    }
}
#pragma mark - Loading and play Video
- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    
    if ([player
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [[self navigationController] setNavigationBarHidden:NO animated:YES];

       player.fullscreen = NO;
        
//        [self.ctrStyleView removeFromSuperview];
        NSLog(@"PlayBackFinished");
    }
}
- (void) moviePlayBackStateChanged:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];

    if(player.playbackState == MPMoviePlaybackStateInterrupted){
        //[player.view removeFromSuperview];
        //[self.ctrStyleView removeFromSuperview];
    
    }else if(player.playbackState == MPMoviePlaybackStatePlaying){
        [_btnPlay setHidden:YES];
    }else if(player.playbackState == MPMoviePlaybackStatePaused){
        [_btnPlay setHidden:NO];
    }else if(player.playbackState == MPMoviePlaybackStateStopped){
        [_btnPlay setHidden:NO];
    }
    NSLog(@"stageChanged %d",player.playbackState);
}
-(void)addMovieControl:(NSNotification *)notificaton{
    [self.view bringSubviewToFront:self.ctrStyleView];
    NSLog(@"fullscreen_xxx");
}
-(void)moviePlayerLoadStateChanged:(NSNotification*)notification{
//    NSLog(@"State changed to: %d\n", _moviePlayerController.loadState);
//    if(_moviePlayerController.loadState == MPMovieLoadStatePlayable){
//        [_movieIndicator stopAnimating];
//        if(self.moviePlayerController.playbackState!=MPMoviePlaybackStatePlaying){
//            [_btnPlay setHidden:NO];
//
//        }
//    }else if(_moviePlayerController.loadState == MPMovieLoadStateStalled){
//       // [_movieIndicator setHidden:NO];
//       // [_movieIndicator startAnimating];
//    }else if(_moviePlayerController.loadState == MPMovieLoadStateUnknown){
//    
//       // [_movieIndicator setHidden:NO];
//       // [_movieIndicator startAnimating];
//
//    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSArray *)getListGenreKey:(NSString *)cate{
    NSMutableArray *result= [[NSMutableArray alloc] init];
    NSArray *cats= [cate componentsSeparatedByString:@","];
    for(int i = 0; i < cats.count;i++){
        NSString *key= [self getGenreKeyByTitle:[cats objectAtIndex:i]];
        if(![key isEqualToString:@"Not Found"]){
            [result addObject:key];
        }
    }
    return result;


}
-(NSString *) getGenreKeyByTitle:(NSString *)title{
    for(int i = 0; i < genraData.count;i++){
        Genre *gen = [genraData objectAtIndex:i];
        if([title containsString:gen.title]){
            return gen.key;
        }
        
    }
    return @"Not Found";
}
-(void)updateRightMenuData : (NSArray *)data{
//    UIViewController *vc = [SlideNavigationController sharedInstance].rightMenu;
//    
//    if ([vc isKindOfClass:[RightMenuViewController class]]) {
//        // code
//        RightMenuViewController *rv = (RightMenuViewController *)vc;
//        [rv setFilmDataArray:data];
//        NSLog(@"Em day roi ");
//    }else{
//        NSLog(@"Em dau roi");
//    }

}
#pragma Mark DatabaseManager
-(void)saveFilmHistory{
    NSLog(@"SAVEHISTORY");
    
    UserDataFilm *data = [self.dbManager getUserDataByFilmId:_infoDetail._id];
    data.info =_infoDetail;
    data.type = 1;
    data.date = @"01-01-2015";
    if (curIndexPath.section == 0) {
        data.currentEpsider = [NSString stringWithFormat:@"1-%d",playerView.current];

    }else{
        data.currentEpsider = [NSString stringWithFormat:@"2-%d",playerView.current];

    }
    [self.dbManager saveFilmUserData:data];
}
#pragma textFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    NSLog(@"comment on facebook commentbox");
}
-(void)keyboardOnScreen:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    keyboardHeight = keyboardFrame.size.height;
    NSLog(@"keyboardFrame: %@", NSStringFromCGRect(keyboardFrame));
}

- (void)keyboardDidShow: (NSNotification *) notif{
    // Do something here
   keyboardHeight =  keyboardHeight > 100?keyboardHeight : 300;
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = CGRectMake(0, -keyboardHeight, viewWidth, viewHeight);
    }];
}

- (void)keyboardDidHide: (NSNotification *) notif{
    // Do something here
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    }];

}
-(void)caculatePlayerHeight{
    NSString *deviceString =[[UIDevice currentDevice] platformString];
    if ([deviceString containsString:@"iPad"]) {
        //panelWidth = self.view.frame.size.width - 320;
        playerHeight =   viewHeight/2.5;
    }else{
        //panelWidth = PANEL_WIDTH;
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
            // portrait
            playerHeight = viewHeight * 30.0/100.0;

        } else {
            playerHeight = self.view.frame.size.width/4;
            // landscape
        }
        
    }
    movieRatio = viewWidth/(playerHeight);

}
-(void)pressedClose:(UIButton *)button{
    [playerView clean];
    playerView = nil;
    NSString *deviceString =[[UIDevice currentDevice] platformString];
    if ([deviceString containsString:@"iPad"]) {
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).allowRotation = YES;
        
    }else{
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).allowRotation = NO;
    }
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) closePlayer];
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.view removeFromSuperview];
}

#pragma mark - call php api
-(void)callWebService{
    NSLog(@"call API");
    NSString *ext= @"%2F0";
    NSString *WS_URL = [NSString stringWithFormat:@"%@%d%@",API_URL_WHATCH_FILM,filmInfo._id,ext];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:WS_URL]];
//    
//    [request setHTTPMethod:@"GET"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:WS_URL]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"API URL %@",WS_URL);
    if (connection)
    {
        //receivedData = nil;
    }
    else
    {
        NSLog(@"Connection could not be established");
    }
    
}
#pragma mark - NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!receivedData)
        receivedData = [[NSMutableData alloc] initWithData:data];
    else
        [receivedData appendData:data];
    [self pareJsonToData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"***** Connection failed");
    
    receivedData=nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    NSLog(@"***** Succeeded! Received %d bytes of data",[receivedData length]);
   // NSLog(@"***** AS UTF8:%@",[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
}
-(void)pareJsonToData{
    NSLog(@"pareDAta");
    if(_serverA){
        _serverA = nil;
    }
    if (_serverB) {
        _serverB = nil;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Background work
        NSString *receivedDataString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        NSError* error;
        
        NSDictionary* json =     [NSJSONSerialization JSONObjectWithData: [receivedDataString dataUsingEncoding:NSUTF8StringEncoding]
                                                                 options: NSJSONReadingMutableContainers
                                                                   error: &error];        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI
            
            
            //SearchResultItem *item = [[SearchResultItem alloc] initWithData:json];
            if(json){
//                [searchResults removeAllObjects];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSDictionary *listServer= [json objectForKey:@"movie_links_server"];
//                    movie_links
                    _serverA = [listServer objectForKey:@"server_1"];
                    _serverB = [listServer objectForKey:@"server_2"];
//
//                    NSLog(@"LinkfilmARR %@ %d",listLink,listLink.count);
                    int total = 0;
                    int current = 0;
                    int server = 0;
                    int section = 0;
                    if([_serverA isKindOfClass:[NSArray class]] &&  [_serverA count]>0){
                        int curEpsider = 0;
                        if (self.previousEpsider && self.previousEpsider.userdataID > 0) {
                            NSArray  *sv = [self.previousEpsider.currentEpsider componentsSeparatedByString:@"-"];
                            if ([sv[0] intValue] == 0) {
                                server = 0;
                                if (sv.count > 1) {
                                    current = [sv[1] intValue];
                                    
                                }
                                total = (int)_serverA.count;
                                curIndexPath = [NSIndexPath indexPathForRow:current inSection:section];
                                movieURL =[NSURL URLWithString:[_serverA objectAtIndex:current ]];

                            }else{
                                total = (int)_serverA.count;
                                curIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
                                movieURL =[NSURL URLWithString:[_serverA objectAtIndex:current ]];

                            }
                        }else{
                            total = (int)_serverA.count;
                            curIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
                            movieURL =[NSURL URLWithString:[_serverA objectAtIndex:0 ]];
   
                        }
                        section++;
                    }else if([_serverB isKindOfClass:[NSArray class]] &&_serverB .count > 0){
                        if (self.previousEpsider && self.previousEpsider.userdataID > 0) {
                            NSArray  *sv = [self.previousEpsider.currentEpsider componentsSeparatedByString:@"-"];
                            if ([sv[0] intValue] == 1) {
                                server = 1;
                                if (sv.count > 1) {
                                    current = [sv[1] intValue];

                                }
                                
                                total = (int)_serverB.count;
                                curIndexPath = [NSIndexPath indexPathForRow:current inSection:section];
                                movieURL =[NSURL URLWithString:[_serverB objectAtIndex:current ]];
                            }else{
                                total = (int)_serverB.count;
                                curIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
                                movieURL =[NSURL URLWithString:[_serverB objectAtIndex:current ]];

                            }
                        }else{
                            total = (int)_serverB.count;
                            curIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
                            movieURL =[NSURL URLWithString:[_serverB objectAtIndex:0 ]];

                        }
                    }
                    
                   // NSDictionary *serverlist = [json objectForKey:@"movie_links_server"];
                   // NSLog(@"serverlist %@",[serverlist objectForKey:@"server_2"]);
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [_tbSearch reloadData];
                        [_relateView setDataArrayEpsolider2:_serverA server2:_serverB currentIndexPath:curIndexPath];
                        _infoDetail = [[FilmInfoDetails alloc] initWithData:json];
                        [_infoView bindDataToView:_infoDetail];
                        [_overviewView bindDataToView:_infoDetail.name desc:_infoDetail.desc];
//                        [self.moviePlayerViewController .moviePlayer setContentURL:movieURL];
//                        [self.moviePlayerViewController.moviePlayer prepareToPlay];
//                        [self.moviePlayerController setContentURL:movieURL];
                        //
//                        [playerView setVideoURL:movieURL];
                        playerView.total = total;
                        playerView.current = current;
                        [self playVideoWithUrl:movieURL atEpside:curIndexPath.row];
//                        [self saveFilmHistory];
                        //                        EmployeeDbUtil get
                        //[self pressPlay:nil];
//                        [self updateRightMenuData : listLink];
                    });
                });
            }
            
        });
    });


}
#pragma PlayVideo Delegate
-(void)playVideoAtIndex:(NSInteger)index{
    [self pressPlay:nil];
    
}
-(void)playMovieWithData:(SearchResultItem *)item{
    filmInfo = item;
    _infoView.thumbnail.image = nil;
    [self btnMovePanelLeft:nil];
    [self prepareFilmData:item];
}
-(void)playMovieAtIndex:(NSString *)url epside:(NSIndexPath *)indexPath{
    movieURL = [NSURL URLWithString:url];
    curIndexPath = indexPath;
    playerView.current = (int)indexPath.item;
    [self playVideoWithUrl:movieURL atEpside:indexPath.row];

}
#pragma mark - PlayerDelegate
-(void)playerDidLeaveFullscreen{
    [playerView updatePlayerLayer];
    movieIndicator.transform = CGAffineTransformMakeRotation(0);
    self.bannerView.hidden = NO;

}
-(void)playerWillEnterFullscreen{
//    self.btnClose.hidden = YES;
    self.bannerView.hidden = YES;
    float degrees = 90; //the value in degrees
    movieIndicator.transform = CGAffineTransformMakeRotation(degrees * M_PI/180);
}
-(void)playerStalled{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Movies Error" message:@"Server is overload now, please try again later!" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        [alert dismissViewControllerAnimated:YES completion:nil];
//    }];
//    [alert addAction:okAction];
//    [self presentViewController:alert animated:YES completion:nil];
}

-(void)playerDidNext{
    if (curIndexPath) {

        NSInteger section = curIndexPath.section;
        int count = 0;
        if ( [_serverA isKindOfClass:[NSArray class]]) {
            count++;
        }
        if([_serverB isKindOfClass:[NSArray class]]){
            count++;
            
            
        }
        if (count == 2) {
            if (section == 0 && [_serverA isKindOfClass:[NSArray class]]) {
                if (curIndexPath.row + 1 < _serverA.count) {
                    [self playNextvideo:_serverA];
                    
                }
            }else if(section == 1 && [_serverB isKindOfClass:[NSArray class]]){
                if (curIndexPath.row + 1 < _serverB.count) {
                    
                    [self playNextvideo:_serverB];
                }
            }
        }else if(count == 1){
            if ([_serverA isKindOfClass:[NSArray class]]) {
                if (curIndexPath.row + 1 < _serverA.count) {
                    [self playNextvideo:_serverA];
                    
                }
            }else if([_serverB isKindOfClass:[NSArray class]]){
                if (curIndexPath.row + 1 < _serverB.count) {
                    
                    [self playNextvideo:_serverB];
                }
            }
        }
       
    }
}
-(void)playerDidPrevious{
    if (curIndexPath) {
        
        NSInteger section = curIndexPath.section;
        int count = 0;
        if ( [_serverA isKindOfClass:[NSArray class]]) {
            count++;
        }
        if([_serverB isKindOfClass:[NSArray class]]){
            count++;

        
        }
        if (count == 2) {
            if (section == 0 && [_serverA isKindOfClass:[NSArray class]]) {
                count++;
                if (curIndexPath.row > 0) {
                    [self playPrevVideo:_serverA];
                    
                }
            }else if(section == 1 && [_serverB isKindOfClass:[NSArray class]]){
                count++;
                
                if (curIndexPath.row >0) {
                    
                    [self playPrevVideo:_serverB];
                }
            }
        }else if(count == 1){
            if ([_serverA isKindOfClass:[NSArray class]]) {
                count++;
                if (curIndexPath.row > 0) {
                    [self playPrevVideo:_serverA];
                    
                }
            }else if([_serverB isKindOfClass:[NSArray class]]){
                count++;
                
                if (curIndexPath.row >0) {
                    
                    [self playPrevVideo:_serverB];
                }
            }
        }
       
    }

}
-(void)playerDidExpandLess{
    [self scaleViewToMinimumSize];
}
-(void)playerDidExpandMore{
    [self scaleViewToOriginalSize];
}
-(void)playNextvideo:(NSArray *)server{
    curIndexPath = [NSIndexPath indexPathForItem:curIndexPath.row + 1 inSection:curIndexPath.section];
    movieURL = [NSURL URLWithString:[server objectAtIndex:curIndexPath.row]];
    //            curIndexPath = indexPath;
//    [playerView clean];
    [self playVideoWithUrl:movieURL atEpside:curIndexPath.row];

}
-(void)playPrevVideo:(NSArray *)server{
    curIndexPath = [NSIndexPath indexPathForItem:curIndexPath.row - 1 inSection:curIndexPath.section];
    movieURL = [NSURL URLWithString:[server objectAtIndex:curIndexPath.row]];
    //            curIndexPath = indexPath;
//    [playerView clean];
    [self playVideoWithUrl:movieURL atEpside:curIndexPath.row];
}

-(void)playVideoWithUrl:(NSURL *)url atEpside:(NSInteger)eps{
    movieIndicator.hidden = NO;
    playerView.current = (int)eps;
    [playerView setVideoURL:url];
    [playerView setFilmname:[NSString stringWithFormat:@"%@ Tập %ld",_infoDetail.name,eps + 1]];
    [playerView prepareAndPlayAutomatically:YES];
    [self.view bringSubviewToFront:movieIndicator];
    movieIndicator.hidden = NO;
    [movieIndicator startAnimating];
    //    [self.moviePlayerController setContentURL:movieURL];
    //    [self.moviePlayerController prepareToPlay];
    [self saveFilmHistory];
    [self addIndicator];
    [self pressPlay:nil];
}
-(void)playerDidPlaying{
    [movieIndicator removeFromSuperview];
}
-(void)addIndicator{
    movieIndicator= [[MONActivityIndicatorView alloc] init];
    [movieIndicator setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    movieIndicator.delegate = self;
    movieIndicator.numberOfCircles = 3;
    movieIndicator.radius = 10;
    movieIndicator.internalSpacing = 3;
    [self.playerView addSubview:movieIndicator];
    if (self.playerView) {
        NSLayoutConstraint *c;
        c = [NSLayoutConstraint constraintWithItem:movieIndicator
                                         attribute:NSLayoutAttributeCenterX
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:playerView
                                         attribute:NSLayoutAttributeCenterX
                                        multiplier:1
                                          constant:0];
        [self.view addConstraint:c];
        c = [NSLayoutConstraint constraintWithItem:movieIndicator
                                         attribute:NSLayoutAttributeCenterY
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:playerView
                                         attribute:NSLayoutAttributeCenterY
                                        multiplier:1
                                          constant:0];
        [self.view addConstraint:c];
        [movieIndicator startAnimating];
    }

}

- (void) didRotate:(NSNotification *)notification {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
       
    }
    NSNumber *number = [NSNumber numberWithInteger:orientation];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(waitingForRatation:) userInfo:number repeats:NO];
}
-(void)waitingForRatation:(NSTimer *)timer{
    NSNumber *number = [timer userInfo];
    if (number) {
        UIDeviceOrientation orientation = [number integerValue];
        if(originSize){
        [self doRotate:orientation];
        }

    }
}
-(void)doRotate:(UIDeviceOrientation )orientation{
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            // do something for portrait orientation
            if (playerView.rotating == NO) {
                [playerView changeViewtoPortrait];
            }else{
                playerView.queueRotate = orientation;
            }
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            break;
        case UIDeviceOrientationLandscapeLeft:
            if (playerView.rotating == NO) {
                
                [playerView changeViewToLandcape];
            }else{
                playerView.queueRotate = orientation;
            }
            break;
            
        case UIDeviceOrientationLandscapeRight:
            // do something for landscape orientation
            if (playerView.rotating == NO) {
                
                [playerView changeViewToLandcapeLeft];
            }
            else{
                playerView.queueRotate = orientation;
            }
            break;
            
        default:
            break;
    }

}

@end
