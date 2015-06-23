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
#define BUTTON_PLAY_SIZE 40
#define NAVBAR_HEIGHT 64
NSString *const PlayMovieTabpped = @"PlayMovieTabpped";

const NSString *API_URL_WHATCH_FILM = @"http://www.phimb.net/json-api/movies.php?v=538c7f456122cca4d87bf6de9dd958b5%2F";

@interface PlayVideoViewController () <PlayMovieDelegate,UIGestureRecognizerDelegate,RelateFilmViewControllerDelegate,MONActivityIndicatorViewDelegate>
{
    NSArray *genraData;
    CGFloat playerMinWidth;
    CGFloat viewWidth;
    CGFloat viewHeight;
    CGFloat marginTop;
    CGFloat tabBarHeight;

    CGFloat infoMarginTop;
    CGFloat btnTabWidth;
    CGFloat btnTabHeight;
    NSMutableData *receivedData;
    CGFloat keyboardHeight;
    CGFloat playerHeight;
    CGFloat movieRatio;
    NSTimer *expandTimer;
    BOOL allowRotation;
    BOOL hasControl;
}
@property (nonatomic ,strong)     NSURL *movieURL;
//= [NSURL URLWithString:@"http://techslides.com/demos/sample-videos/small.mp4"];
@property (strong,nonatomic) FilmInfoDetails *infoDetail;
@property (nonatomic,assign) NSInteger mpCurrentState;
@property (strong, nonatomic)  UIView *ctrStyleView;
@property (strong,nonatomic) UIView *playerView;
@property (strong,nonatomic) MPMoviePlayerController *moviePlayerController;
//@property (strong, nonatomic) MPMoviePlayerViewController *moviePlayerViewController;
@property (strong, nonatomic) MONActivityIndicatorView *movieIndicator;
//@property (strong, nonatomic) DotLoading *dotLoading;
@property (strong, nonatomic) TabInfoView *infoView;
@property (strong, nonatomic) TabRelateView *relateView;
@property (strong, nonatomic) TabOverview *overviewView;
@property (strong, nonatomic) TabCommentView *commentView;
@property (strong, nonatomic) UIView *tabViewHightLight;
@property (strong, nonatomic) UIView *bgHeadrView;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic)  UIView *tabviewPanel;
@property (nonatomic, assign) CGPoint preVelocity;
@property (nonatomic,assign) BOOL showPanel;
@property (nonatomic,assign) BOOL originSize;
@property (nonatomic,strong)EmployeeDbUtil *dbManager;

//@property (nonatomic,strong) UIView *holderView;
//@property (nonatomic, assign) nsin

@end

@implementation PlayVideoViewController
@synthesize removeDelegate;
@synthesize filmInfo;
@synthesize movieURL,rightButton,originSize,isFullScreen;

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
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    self.view.backgroundColor = [UIColor clearColor];
    isFullScreen = NO;
    hasControl = NO;
    originSize = YES;
    self.dbManager = [[EmployeeDbUtil alloc] init];
    [self.dbManager initDatabase];
   
    NSLog(@"marginTop %f",marginTop);
    // Do any additional setup after loading the view.
//    self.holderView = [[UIView alloc] initWithFrame:self.initialFirstViewFrame];
//    [self callWebService];
    [self initViews];
    [self setupGestures];

}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationFade];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void) initParams{
    _currentTab = TAB_INFO;
    viewHeight =  self.view.frame.size.height;
    viewWidth  = self.view.frame.size.width;
    playerMinWidth = viewWidth*2/3;
    [self caculatePlayerHeight];
    tabBarHeight = 50;
    marginTop = 0;
    movieRatio = viewWidth/playerHeight;
    infoMarginTop = marginTop + playerHeight;
    btnTabWidth = viewWidth/3;
    btnTabHeight = 20;
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if (![language isEqualToString:@"vi"]) {

        
        genraData = @[
                       [Genre itemWithTitle:@"Action Films" withKey:@"hanh-dong"],
                       [Genre itemWithTitle:@"Adventure Films" withKey:@"phieu-luu"],
                       [Genre itemWithTitle:@"Romance Films" withKey:@"tinh-cam"],
                       [Genre itemWithTitle:@"Drama Film" withKey:@"tam-ly"],
                       [Genre itemWithTitle:@"Kung fu Films" withKey:@"vo-thuat"],
                       [Genre itemWithTitle:@"Costume Drama Films" withKey:@"co-trang"],
                       [Genre itemWithTitle:@"Hài Hước" withKey:@"hai-huoc"],
                       [Genre itemWithTitle:@"Musical Films" withKey:@"ca-nhac"],
                       [Genre itemWithTitle:@"Comedy Films" withKey:@"hai-kich"],
                       [Genre itemWithTitle:@"Crime Films" withKey:@"hinh-su"],
                       [Genre itemWithTitle:@"Wars Films " withKey:@"chien-tranh"]];
    }else{

        genraData = @[
                       [Genre itemWithTitle:@"Hành Động" withKey:@"hanh-dong"],
                       [Genre itemWithTitle:@"Phiêu Lưu" withKey:@"phieu-luu"],
                       [Genre itemWithTitle:@"Tình Cảm" withKey:@"tinh-cam"],
                       [Genre itemWithTitle:@"Tâm Lý" withKey:@"tam-ly"],
                       [Genre itemWithTitle:@"Võ Thuật" withKey:@"vo-thuat"],
                       [Genre itemWithTitle:@"Cổ trang" withKey:@"co-trang"],
                       [Genre itemWithTitle:@"Hài Hước" withKey:@"hai-huoc"],
                       [Genre itemWithTitle:@"Ca Nhạc" withKey:@"ca-nhac"],
                       [Genre itemWithTitle:@"Hài Kịch" withKey:@"hai-kich"],
                       [Genre itemWithTitle:@"Hình Sự" withKey:@"hinh-su"],
                       [Genre itemWithTitle:@"Chiến Tranh " withKey:@"chien-tranh"]];
    }


}
-(void)initViews{
    [self initParams];
//    [self styleNavBar];
    [self initMoviePlayerView];
    [self initMovieIndicator];
    
    [self initViewInfo];
    [self initTabView];

    [self initPreviewImage];
    //[self createControllStyleView];
    
    [self initPlayFilmController];
    [self initNotification];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
   // [SlideNavigationController sharedInstance].lastControlelr = 2;

}
- (void)styleNavBar {
    marginTop = 64;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    

    _btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 45, 44)];
    [_btnCancel setTitle:@"Back" forState:UIControlStateNormal];
    _btnCancel.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
//    [_btnCancel setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0,10)];
    [_btnCancel addTarget:self action:@selector(pressCancel:) forControlEvents:UIControlEventTouchUpInside];

    _bgHeadrView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 64) ];
    [_bgHeadrView addSubview:_btnCancel];
    _bgHeadrView.backgroundColor = [ColorSchemeHelper     sharedNationHeaderColor];
    [self.view addSubview:_bgHeadrView];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, viewWidth-100, 44)];
    title.text = @"Movie Information";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.font= [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
    [_bgHeadrView addSubview:title];
//    [header addSubview:rightButton];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    _movieIndicator= [[MONActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, playerHeight)];
    _movieIndicator.backgroundColor = [UIColor clearColor];
    _movieIndicator.delegate = self;
    _movieIndicator.numberOfCircles = 3;
    _movieIndicator.radius = 10;
    _movieIndicator.internalSpacing = 3;
//    CGSize size = [_movieIndicator intrinsicContentSize];
//    _movieIndicator.frame = CGRectMake((_moviePlayerController.view.frame.size.width-size.width)/2, marginTop + (playerHeight- size.height)/2, size.width, size.height);
    [_movieIndicator startAnimating];
    _movieIndicator.center = CGPointMake(viewWidth/2, self.moviePlayerController.view.frame.size.height/2) ;
    [self.view addSubview:_movieIndicator];
//    self.dotLoading = [[DotLoading alloc] initWithFrame:CGRectMake(0, marginTop + (playerHeight - 50)/2, viewWidth, 50)];
////    [self.dotLoading setDotsColor:[UIColor redColor]];
//    self.dotLoading.backgroundColor = [UIColor clearColor];
//    [self.dotLoading  startAnimating];
//    [self.view addSubview:self.dotLoading];
//    [self placeAtTheCenterWithView:_movieIndicator];
    
//    [NSTimer scheduledTimerWithTimeInterval:7 target:indicatorView selector:@selector(stopAnimating) userInfo:nil repeats:NO];
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

//        CGFloat movieRatio  = 192.f/ 100.f;
//        playerHeight = viewHeight/4;
  



    /**/
    _playerView = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, viewWidth, playerHeight)];
    
    [self.onView addSubview:_playerView];
    _moviePlayerController = [[MPMoviePlayerController alloc] init];
    _moviePlayerController.view.frame = CGRectMake(0, marginTop, viewWidth, playerHeight);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateChanged:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addMovieControl:)
                                                 name:MPMoviePlayerWillEnterFullscreenNotification
                                               object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willExitFullScreenMode:)
                                                 name:MPMoviePlayerWillExitFullscreenNotification
                                               object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerLoadStateChanged:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerReadyDisPlay:)
                                                 name:MPMoviePlayerReadyForDisplayDidChangeNotification
                                               object:_moviePlayerController];
   
//    [self.moviePlayerController.view addGestureRecognizer:tapMovieGestureRecognizer];
    [self.view addSubview:_moviePlayerController.view];
    _moviePlayerController.scalingMode = MPMovieScalingModeAspectFit;
    _moviePlayerController.controlStyle = MPMovieControlStyleEmbedded;

    //        self.moviePlayerController.view.transform = CGAffineTransformConcat(self.moviePlayerController.view.transform, CGAffineTransformMakeRotation(M_PI_2));
//        [self.moviePlayerController.view setFrame:self.view.frame];
        [_moviePlayerController prepareToPlay];
//       [self createControllStyleView];
        _moviePlayerController.fullscreen = YES;
        _moviePlayerController.shouldAutoplay = NO;
//        [_moviePlayerController play];
    _btnExpandLess = [[UIButton alloc] initWithFrame:CGRectMake(5,5, 30, 30)];
    UIImageView *expandImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_expand_more.png"]];
    expandImg.contentMode = UIViewContentModeScaleAspectFit;
    expandImg.frame =CGRectMake(0, 0, 30  , 30);
    [_btnExpandLess setUserInteractionEnabled:YES];
    [_btnExpandLess addSubview:expandImg];
    [_btnExpandLess setHidden:NO];
//    [_btnExpandLess setAlpha:0.5f];
    [_btnExpandLess addTarget:self action:@selector(scaleViewToSmallSize) forControlEvents:UIControlEventTouchUpInside];
    _btnExpandLess.backgroundColor = [UIColor clearColor];
    [_btnExpandLess setHidden:YES];
    [self.moviePlayerController.view addSubview:_btnExpandLess];
    /**/
    CGFloat btnCloseSize = 80;
    _btnClose = [[UIButton alloc] initWithFrame:CGRectMake(-btnCloseSize/2, -btnCloseSize/2, btnCloseSize, btnCloseSize)];
    UIImageView *playImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_close_circled.png"]];
    btnCloseSize = btnCloseSize-20;
    playImg.contentMode = UIViewContentModeScaleAspectFit;
    playImg.frame =CGRectMake(btnCloseSize/4+10, btnCloseSize/4+10, btnCloseSize/2  , btnCloseSize/2);
    playImg.backgroundColor = [UIColor whiteColor];
    playImg.layer.cornerRadius = btnCloseSize/4;
    playImg.clipsToBounds = YES;
    [_btnClose setUserInteractionEnabled:YES];
    [_btnClose addSubview:playImg];
    [_btnClose setHidden:YES];
    [_btnClose addTarget:self action:@selector(pressCancel:) forControlEvents:UIControlEventTouchUpInside];
//    _btnClose.backgroundColor = [UIColor whiteColor];
//    _btnClose.alpha = 0.f;
    [self.moviePlayerController.view addSubview:_btnClose];

}
-(void)initPlayFilmController{
// self.moviePlayerViewController = [[MPMoviePlayerViewController alloc] init];
//    [self.moviePlayerViewController .moviePlayer setContentURL:[NSURL URLWithString:@"http://phimb.net/videoplayback/aHR0cHM6Ly9waWNhc2F3ZWIuZ29vZ2xlLmNvbS8xMDM1NDUwODQxNTU3MzYwODIwNjMvTWF5MjkyMDE1P2F1dGhrZXk9R3Yxc1JnQ00zaWo5MlIwT09GOFFFIzYxNTQyOTIyODQ2MzExMzExNTQ=.mp4"] ];
//    self.moviePlayerViewController .moviePlayer.shouldAutoplay = NO;
//    self.moviePlayerViewController .moviePlayer.controlStyle  = MPMovieControlStyleEmbedded;
//    [self.moviePlayerViewController .moviePlayer prepareToPlay];
//    self.moviePlayerViewController .moviePlayer.fullscreen = YES;
//    self.moviePlayerViewController = vc;
//    self.moviePlayerViewController.view.transform = CGAffineTransformConcat(self.moviePlayerViewController.view.transform, CGAffineTransformMakeRotation(M_PI_2));
//    UILabel *lbTest= [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    lbTest.text = @"abc";
//    lbTest.textColor = [UIColor redColor];
//    [self.moviePlayerViewController.view addSubview:lbTest];
//    [self.moviePlayerViewController.view addSubview:self.ctrStyleView];
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_play.png"]];
    backImg.frame =CGRectMake(0, 0,30  , 30);
    
    _btnBack = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [_btnBack addTarget:self action:@selector(pressCloseMoviePlayerView:) forControlEvents:UIControlEventTouchUpInside];
    [_btnBack addSubview:backImg];
    _btnBack.backgroundColor = [UIColor redColor];
//    [_moviePlayerViewController.view addSubview:_btnBack ];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(pressCloseMoviePlayerView:)
//                                                 name:MPMoviePlayerWillExitFullscreenNotification
//                                               object:nil];

}
-(void)initTabView{
    UIFont *font  = [UIFont systemFontOfSize:13.f];

    _tabviewPanel = [[UIView alloc]initWithFrame:CGRectMake(0, infoMarginTop+viewHeight/4, viewWidth, btnTabHeight)];
    _tabviewPanel.backgroundColor = [UIColor whiteColor];
    CGFloat tabMargin = (btnTabWidth-100)/2;
    _btnTabInfo = [[UIButton alloc] initWithFrame:CGRectMake(tabMargin, 0, 100, btnTabHeight)];
    [_btnTabInfo setTag:1];
    [_btnTabInfo setTitle:@"Overview" forState:UIControlStateNormal];
    _btnTabInfo.titleLabel.font = font;
    [_btnTabInfo setTintColor:[UIColor blackColor]];

    //[_btnTabInfo setTitleColor:[ColorSchemeHelper sharedTabTextColor] forState:UIControlStateNormal];
    [_btnTabInfo addTarget:self action:@selector(pressInfoTab:) forControlEvents:UIControlEventTouchUpInside];
    //
    _btnTabRelative = [[UIButton alloc] initWithFrame:CGRectMake(btnTabWidth +tabMargin, 0, 100, btnTabHeight)];
    [_btnTabRelative setTag:2];
    _btnTabRelative.titleLabel.font = font;
    [_btnTabRelative setTintColor:[UIColor blackColor]];

    [_btnTabRelative setTitle:@"Episodes" forState:UIControlStateNormal];
    _btnTabRelative.backgroundColor = [UIColor whiteColor];
//    _btnTabRelative.alpha = 0.5f;
    //[_btnTabRelative setTitleColor:[ColorSchemeHelper sharedTabTextColor] forState:UIControlStateNormal];
    [_btnTabRelative addTarget:self action:@selector(pressRelateTab:) forControlEvents:UIControlEventTouchUpInside];
    //btnTabComment
    _btnTabComment = [[UIButton alloc] initWithFrame:CGRectMake(btnTabWidth*2+tabMargin, 0, 100, btnTabHeight) ];
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
    _btnTabComment.alpha = 0.5f;
    _btnTabInfo.alpha = 1.0f;
    _btnTabRelative.alpha = 0.5f;
    [_tabviewPanel addSubview:_btnTabInfo];
    [_tabviewPanel addSubview:_btnTabRelative];
    [_tabviewPanel addSubview:_btnTabComment];
    _tabViewHightLight = [[UIView alloc] initWithFrame:CGRectMake(btnTabWidth/4, btnTabHeight-2, btnTabWidth/2, 2)];
    _tabViewHightLight.backgroundColor = [ColorSchemeHelper sharedMovieInfoTitleColor];
    [_tabviewPanel addSubview:_tabViewHightLight];
    [_tabviewPanel.layer setCornerRadius:0];
    [_tabviewPanel.layer setShadowColor:[UIColor blackColor].CGColor];
    [_tabviewPanel.layer setShadowOpacity:0.3];
    [_tabviewPanel.layer setShadowOffset:CGSizeMake(2, 2)];
    [self.view addSubview:_tabviewPanel];
}
-(void)initPreviewImage{
//    CGFloat preImgHeight=viewHeight/4;
    _previewImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,marginTop, viewWidth, playerHeight)];
    _previewImage.contentMode = UIViewContentModeScaleToFill;
    _previewImage.image = [UIImage imageNamed:@""];
//    _previewImage.autoresizingMask = ( UIViewAutoresizingFlexibleBottomMargin
//                                      | UIViewAutoresizingFlexibleHeight
//                                      | UIViewAutoresizingFlexibleLeftMargin
//                                      | UIViewAutoresizingFlexibleRightMargin
//                                      | UIViewAutoresizingFlexibleTopMargin
//                                      | UIViewAutoresizingFlexibleWidth );
//    [self.view addSubview:_previewImage];
    //
    /*button play
    _btnPlay = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth/2 - BUTTON_PLAY_SIZE/2, marginTop + playerHeight/2 - BUTTON_PLAY_SIZE/2, BUTTON_PLAY_SIZE, BUTTON_PLAY_SIZE)];
    UIImageView *playImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_play.png"]];
    playImg.frame =CGRectMake(0, 0, BUTTON_PLAY_SIZE, BUTTON_PLAY_SIZE);
    [_btnPlay setUserInteractionEnabled:NO];
    [_btnPlay addSubview:playImg];
    [_btnPlay addTarget:self action:@selector(pressPlay:) forControlEvents:UIControlEventTouchUpInside];
    [_btnPlay setHidden:YES];
    [self.view addSubview:_btnPlay];
     */
    //init backButton
  
}
-(void)initViewInfo{
//    UIView *containerView = [[[NSBundle mainBundle] loadNibNamed:@"TabViewInfo" owner:self options:nil] lastObject];
//    containerView.frame = CGRectMake(0, 350, self.view.frame.size.width, self.view.frame.size.height - 350);
//    [self.view addSubview:containerView];
    
    _infoView= [[TabInfoView alloc] initWithFrame: CGRectMake(0, infoMarginTop, self.view.frame.size.width, viewHeight/4)];
    _infoView.backgroundColor = [UIColor whiteColor];
//    _infoView.thumbnail.image = filmInfo.thumbnail;
//    _infoView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_infoView];
    //initscroll
    CGFloat scrollH =viewHeight - infoMarginTop - (viewHeight/4+30);
//    infoMarginTop+viewHeight/4
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, infoMarginTop + viewHeight/4+btnTabHeight, viewWidth*3, scrollH)];
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
    _commentView = [[TabCommentView alloc] initWithFrameX:CGRectMake(viewWidth*2, 0, viewWidth, viewHeight - infoMarginTop -  (viewHeight/4+30)) ];
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
-(void)createControllStyleView{
    CGFloat ctrStyleWidth=viewWidth  - 60;
    self.ctrStyleView= [[UIView alloc] initWithFrame:CGRectMake(  30, playerHeight - 35, ctrStyleWidth, 30)];
    self.ctrStyleView.backgroundColor = [UIColor colorWithRed:0.4f green:0.55f blue:0.66f alpha:0.5f];
    [self.moviePlayerController.view addSubview:self.ctrStyleView];
    UIButton *btnFullScreen = [[UIButton alloc] initWithFrame:CGRectMake(ctrStyleWidth - 40, 0, 40, 30)];
    [btnFullScreen setTitle:@"Full" forState:UIControlStateNormal];
    [btnFullScreen addTarget:self action:@selector(pressedFullScreen:) forControlEvents:UIControlEventTouchUpInside];
    [self.ctrStyleView addSubview:btnFullScreen];
//    return nil;
    
}
-(void)pressedFullScreen:(id)button{
    self.moviePlayerController.fullscreen = YES;
    [self.view bringSubviewToFront:self.ctrStyleView];
}
-(void)setupGestures {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveTabPanel:)];
    panRecognizer.delegate = self;
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    [self.view addGestureRecognizer:panRecognizer];
}

-(void)prepareFilmData : (SearchResultItem *)item{
    filmInfo = item;
   // _previewImage.image = [UIImage imageNamed:@""];
    //
    [_infoView setInfoThumbnail:filmInfo.thumbnail];
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
//        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:touches forKey:@"touchesKey"];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"playmovieTouch" object:nil userInfo:userInfo];
//        for (UITouch *aTouch in touches) {
//            if (aTouch.tapCount >= 2) {
//                // The view responds to the tap
//                NSLog(@"multiTouch");
//            }else{
//                NSLog(@"singleTouch");
//            }
//        }
//    }
//}
#pragma mark - Action
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touches Began");
  
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint location = [[touches anyObject] locationInView:self.view];
    CGRect movieFrame = self.moviePlayerController.view.frame;
    
    if(_moviePlayerController.playbackState == MPMoviePlaybackStatePaused ||_moviePlayerController.playbackState == MPMoviePlaybackStatePlaying){

    if (location.y >= movieFrame.origin.y && location.y <= movieFrame.origin.y+movieFrame.size.height) {
        hasControl = !hasControl;
        if (hasControl) {
//            [self showExpandLessButton];
                           _btnExpandLess.hidden = NO;
                [self performSelector:@selector(showExpandLessButton) withObject:nil afterDelay:5.f];
            

        }else{
            if (location.y >= movieFrame.origin.y && location.y <= movieFrame.origin.y+movieFrame.size.height-45) {

            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showExpandLessButton)  object: nil];

            [_btnExpandLess setHidden:!hasControl];
            }
           
        }
        [self controlVisible];
    }
    }
    if([self istouchOnView:_btnClose atPos:location]){
        [self pressCancel:nil];
    }
    NSLog(@"touchesEnded %f-%f",location.x,location.y);
}
-(void)controlVisible{
    BOOL controlsVisible = NO;
    CGFloat controlPos =0.f;
    int index =0;
    for(id views in [[_moviePlayerController view] subviews]){
//        for(id subViews in [views subviews]){
            //for (id controlView in [subViews subviews]){
                controlsVisible = ([views alpha] <= 0.0) ? (NO) : (YES);
            NSLog(@"%d player controls are visible: %d - >%f",index, controlsVisible,controlPos);
            index++;
//                controlPos = [[controlView view] frame].origin.y;
            //}
//        }
    }
}
-(BOOL)istouchOnView:(UIView*)view atPos:(CGPoint)pos{
    CGRect frame =view.frame;
    if (pos.x>frame.origin.x && pos.x<= frame.origin.x+frame.size.width && pos.y>=frame.origin.y && pos.y<= frame.origin.y+frame.size.height) {
        return YES;
    }
    return NO;
}
-(void)showExpandLessButton{
        _btnExpandLess.hidden = YES;
        hasControl = NO;

}
-(void)hideExpandLessButton{
    hasControl = NO;
}
-(void)moveTabPanel:(id)sender {
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    CGPoint currentlocation = [sender locationInView:self.view];

    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
    
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
        
        if(velocity.x > 0) {
             NSLog(@"gesture went right");
        } else {
             NSLog(@"gesture went left");
        }
     
        if (!_showPanel) {
            [self moveTabPanelToOriginalPosition];
        } else {
            NSLog(@"TAB : MORE THAN HALF");

            if (_currentTab == TAB_INFO) {
                [self pressRelateTab:nil];
            }  else if (_currentTab == TAB_RELATIVE) {
                if(velocity.x < 0){
                    [self pressCommentTab:nil];

                }else{
                    [self pressInfoTab:nil];
                }
                NSLog(@"direction :: %f",velocity.x);
            }else if(_currentTab == TAB_COMMENT){
                [self pressRelateTab:nil];
            }
        }
        CGFloat curW = self.moviePlayerController.view.frame.size.width;
//        CGFloat curH = curW/movieRatio ;
        CGFloat curBot = self.view.frame.origin.y + curW/movieRatio;
        if (curW > playerMinWidth|| curBot+ tabBarHeight < viewHeight) {

            if(self.view.frame.origin.y + tabBarHeight + playerHeight*3/2  < viewHeight){
                [self scaleViewToOriginalSize];
            }else{
                [self scaleViewToSmallSize];
            }
                NSLog(@"%f---+++++--%f",viewWidth/2,self.moviePlayerController.view.frame.origin.y);
            //            }
            
        }else{
            originSize = NO;
            
            [[UIApplication sharedApplication] setStatusBarHidden:NO
                                                    withAnimation:UIStatusBarAnimationFade];
            [_btnClose setHidden:NO];

            self.moviePlayerController.controlStyle = MPMovieControlStyleNone;
        }
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        if(velocity.x > 0) {
            // NSLog(@"gesture went right");
        } else {
            // NSLog(@"gesture went left");
        }
        
        // are we more than halfway, if so, show the panel when done dragging by setting this value to YES (1)
        
        // allow dragging only in x coordinates by only updating the x coordinate with translation position
        //_preVelocity = velocity;
        CGFloat infoPos = _infoView.frame.origin.y;//infoView.frame.size.height + _infoView.frame.origin.y;
        CGFloat playerY = _moviePlayerController.view.frame.origin.y;
        if(currentlocation.y < infoPos && currentlocation.y > playerY){
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
            
            
        }else  if(currentlocation.y>=infoMarginTop+viewHeight/4+30){
            
            
            if (_currentTab== TAB_COMMENT && velocity.x > 0) {
                
                _showPanel = abs(_commentView.center.x - self.view.frame.size.width/2) > self.view.frame.size.width/5;
                _overviewView.center = CGPointMake(_overviewView.center.x + translatedPoint.x, _overviewView.center.y);
                _relateView.center = CGPointMake(_relateView.center.x + translatedPoint.x, _relateView.center.y);
                _commentView.center = CGPointMake(_commentView.center.x + translatedPoint.x, _commentView.center.y);
                _tabViewHightLight.center =  CGPointMake(_tabViewHightLight.center.x - translatedPoint.x/3, _tabViewHightLight.center.y);
                NSLog(@"currentTabView 1 %d",_showPanel);
                
            }else if(_currentTab == TAB_INFO && velocity.x < 0){
                NSLog(@"currentTabView 2");
                
                _showPanel = abs(_overviewView.center.x - self.view.frame.size.width/2) > self.view.frame.size.width/5;
                _overviewView.center = CGPointMake(_overviewView.center.x + translatedPoint.x, _overviewView.center.y);
                _relateView.center = CGPointMake(_relateView.center.x + translatedPoint.x, _relateView.center.y);
                _commentView.center = CGPointMake(_commentView.center.x + translatedPoint.x, _commentView.center.y);
                
                _tabViewHightLight.center =  CGPointMake(_tabViewHightLight.center.x - translatedPoint.x/3, _tabViewHightLight.center.y);
                
            }else if(_currentTab == TAB_RELATIVE){
                NSLog(@"currentTabView 3");
                _showPanel = abs(_relateView.center.x - self.view.frame.size.width/2) > self.view.frame.size.width/5;
                _overviewView.center = CGPointMake(_overviewView.center.x + translatedPoint.x, _overviewView.center.y);
                _relateView.center = CGPointMake(_relateView.center.x + translatedPoint.x, _relateView.center.y);
                _commentView.center = CGPointMake(_commentView.center.x + translatedPoint.x, _commentView.center.y);
                
                _tabViewHightLight.center =  CGPointMake(_tabViewHightLight.center.x - translatedPoint.x/3, _tabViewHightLight.center.y);
            }else{
                NSLog(@"currentTabView 4");
                _showPanel = FALSE;
                
            }
            [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
            
            
        }
    }
}
-(void)scaleViewToSmallSize{
    originSize = YES;
    [_btnClose setHidden:YES];
    CGFloat deltaS = 30;
    CGFloat minLeftX= viewWidth - (playerMinWidth + deltaS);
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame = CGRectMake(minLeftX, viewHeight - (playerMinWidth/movieRatio +tabBarHeight+deltaS),(playerMinWidth+deltaS), viewHeight);
        [self.moviePlayerController.view setFrame:CGRectMake(deltaS, marginTop+deltaS, playerMinWidth, playerMinWidth/movieRatio)];
//        [self.movieIndicator setFrame:CGRectMake(deltaS, marginTop+deltaS, playerMinWidth, playerMinWidth/movieRatio)];
        [self.bgHeadrView setFrame:CGRectMake(deltaS, deltaS, viewWidth, marginTop)];
        CGRect playerFrame= self.moviePlayerController.view.frame;
        [self.tabviewPanel setFrame:CGRectMake(deltaS, playerFrame.origin.y+playerFrame.size.height+viewHeight/4, viewWidth, btnTabHeight)];
        CGFloat scrollH =viewHeight - infoMarginTop - (viewHeight/4+btnTabHeight);
        //    infoMarginTop+viewHeight/4
        [_infoView setFrame:CGRectMake(deltaS, playerFrame.origin.y+playerFrame.size.height, self.view.frame.size.width, viewHeight/4)];

        [self.scrollView setFrame:CGRectMake(deltaS, playerFrame.origin.y+playerFrame.size.height + viewHeight/4+btnTabHeight, viewWidth*3, scrollH)];
//        [self.btnPlay setFrame:CGRectMake(viewWidth/2 - BUTTON_PLAY_SIZE/2, marginTop + viewHeight/8 - BUTTON_PLAY_SIZE/2, BUTTON_PLAY_SIZE, BUTTON_PLAY_SIZE)];
//        self.btnPlay.center = self.moviePlayerController.view.center;
//        _movieIndicator.frame = CGRectMake(deltaS, 0, playerMinWidth, playerMinWidth/movieRatio);
//        _movieIndicator.center = CGPointMake(playerMinWidth/2, playerMinWidth/(2*movieRatio));
        _infoView.alpha = 0.f;
        _scrollView.alpha = 0.f;
        _tabviewPanel.alpha = 0.f;
        _bgHeadrView.alpha = 0.f;
        [_btnExpandLess setHidden:YES];
        [_btnClose setHidden:NO];
    } completion:^(BOOL finished){
        //        _moviePlayerController.controlStyle = MPMovieControlStyleEmbedded;
        self.movieIndicator.center = self.moviePlayerController.view.center;
        self.moviePlayerController.controlStyle =MPMovieControlStyleNone;
        
    }];
    
    
}
-(void)scaleViewToOriginalSize{
    originSize = YES;
    [_btnClose setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame = CGRectMake(0, 0, viewWidth, viewHeight);
        [self.moviePlayerController.view setFrame:CGRectMake(0, marginTop, viewWidth, playerHeight)];
//        [self.movieIndicator setFrame:CGRectMake(0, marginTop, viewWidth, playerHeight)];
        [self.bgHeadrView setFrame:CGRectMake(0, 0, viewWidth, marginTop)];
        [self.tabviewPanel setFrame:CGRectMake(0, infoMarginTop+viewHeight/4, viewWidth, btnTabHeight)];
        CGFloat scrollH =viewHeight - infoMarginTop - (viewHeight/4+btnTabHeight);
        //    infoMarginTop+viewHeight/4
        [_infoView setFrame:CGRectMake(0, infoMarginTop, self.view.frame.size.width, viewHeight/4)];

        [self.scrollView setFrame:CGRectMake(0, infoMarginTop + viewHeight/4+btnTabHeight, viewWidth*3, scrollH)];
//        [self.btnPlay setFrame:CGRectMake(viewWidth/2 - BUTTON_PLAY_SIZE/2, marginTop + viewHeight/8 - BUTTON_PLAY_SIZE/2, BUTTON_PLAY_SIZE, BUTTON_PLAY_SIZE)];
//        self.btnPlay.center = self.moviePlayerController.view.center;
//        CGSize size = [_movieIndicator intrinsicContentSize];
        _movieIndicator.frame = CGRectMake(0, marginTop, viewWidth, playerHeight);
        _movieIndicator.center = CGPointMake(viewWidth/2, playerHeight/2);
        _infoView.alpha = 1.f;
        _scrollView.alpha = 1.f;
        _tabviewPanel.alpha = 1.f;
        [self.bgHeadrView setAlpha:1.f];

    } completion:^(BOOL finished){
//        _moviePlayerController.controlStyle = MPMovieControlStyleEmbedded;
//        _movieIndicator.center = self.moviePlayerController.view.center;

        [_btnExpandLess setHidden:!hasControl];
        self.moviePlayerController.controlStyle =MPMovieControlStyleEmbedded;

    }];
    
    
}
-(void)scalePlayView:(CGPoint)velectity{
    CGFloat ratio = viewWidth/viewHeight;
    CGRect preFrame = self.view.frame;
    CGFloat deltaX = 0;
    CGFloat deltaY = 0;
    CGFloat deltaH = 0;
    CGFloat deltaW = 0;
    CGFloat delta = 30;
    deltaY = velectity.y/20;
    int direction = 1;
    if (velectity.y<0) {
        direction =-1;
    }
    CGFloat pRatio = viewWidth/playerHeight;

    if(preFrame.size.width<=viewWidth && velectity.y > 0){
        deltaH = velectity.y/20;
        NSLog(@"----------------------");
    }else if(preFrame.size.width >=viewWidth/2 && velectity.y<0){
        deltaH = velectity.y/20;

    }
    deltaW = ratio*deltaH;
    deltaX = ratio*deltaY;
    CGFloat toY =  preFrame.origin.y + deltaY;
    CGFloat toX = preFrame.origin.x + deltaX;
    
    CGFloat newW = preFrame.size.width - deltaW;
    if (newW<playerMinWidth + delta) {
        newW = playerMinWidth + delta;
    }else if(newW>viewWidth){
        newW = viewWidth;
    }
    CGFloat newH = preFrame.size.height - deltaH;
    if (newH>viewHeight) {
        newH = viewHeight;
    }else if(newH< viewHeight - (newW/pRatio+tabBarHeight+delta)){
        newH =  viewHeight - (newW/pRatio+tabBarHeight+delta);
    }
    if(toY<0){
        toY = 0;
    }else if(toY>=viewHeight-((newW-delta)/pRatio+tabBarHeight +delta)){
        toY=viewHeight-((newW-delta)/pRatio+tabBarHeight+delta);
        [_btnExpandLess setHidden:YES];

    }
    deltaY = toY - preFrame.origin.y;
    if(toX>viewWidth - playerMinWidth - delta ){
        toX = viewWidth - playerMinWidth - delta;
    }else if(toX<0){
        toX = 0;
    }
//    self.view.frame = CGRectMake(toX,toY, newW, newH);
    CGRect playerFrame = _moviePlayerController.view.frame;
    CGFloat plX = playerFrame.origin.x;
    plX+=direction*1.5f;
    if (plX>=30) {
        plX = 30;
    }else if(plX<0){
        plX = 0;
    }
    self.view.frame = CGRectMake(toX,toY, newW, newW/ratio);
    CGFloat plW = newW-plX;
    if (plW<playerMinWidth) {
        plW = playerMinWidth;
    }
    _moviePlayerController.view.frame =CGRectMake(plX,marginTop +plX, plW, plW/pRatio);

    CGFloat alpha  = _infoView.alpha;
    if (velectity.y>0) {
        alpha=alpha-0.02f;
        alpha = alpha<0?0:alpha;
    }else{
        alpha=alpha+0.02f;
        alpha=alpha>1?1:alpha;
    }
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
//    _moviePlayerController.view.frame = CGRectMake(movieFrame.origin.x+deltaX, movieFrame.origin.y+deltaY, newW,newW/pRatio);
//    _bgHeadrView.frame = CGRectMake(headerFrame.origin.x+(toX-preFrame.origin.x), headerFrame.origin.y+(toY-preFrame.origin.y) , headerFrame.size.width, headerFrame.size.height);
//
//    _infoView.frame = CGRectMake(infoFrame.origin.x+(toX-preFrame.origin.x), toY+newW/pRatio, infoFrame.size.width, infoFrame.size.height);
//      _tabviewPanel.frame= CGRectMake(tabFrame.origin.x+(toX-preFrame.origin.x), toY+newW/pRatio+infoFrame.size.height, tabFrame.size.width, tabFrame.size.height);
//    _scrollView.frame= CGRectMake(scrollFrame.origin.x+(toX-preFrame.origin.x), toY+newW/pRatio+infoFrame.size.height +tabFrame.size.height, scrollFrame.size.width, scrollFrame.size.height);
//
    
//    _bgHeadrView.frame = CGRectMake(headerFrame.origin.x, headerFrame.origin.y , headerFrame.size.width, headerFrame.size.height);
    
    _infoView.frame = CGRectMake(plX, playerFrame.origin.y+newW/pRatio, infoFrame.size.width, infoFrame.size.height);
    _tabviewPanel.frame= CGRectMake(plX, playerFrame.origin.y+newW/pRatio+infoFrame.size.height, tabFrame.size.width, tabFrame.size.height);
    _scrollView.frame= CGRectMake(plX, playerFrame.origin.y+newW/pRatio+infoFrame.size.height +tabFrame.size.height, scrollFrame.size.width, scrollFrame.size.height);
    
//    _movieIndicator.frame =CGRectMake(toX,toY, newW, newH);
//    _btnPlay.center = _moviePlayerController.view.center;
//    _btnPlay.transform = CGAffineTransformMakeScale(newW/viewWidth,newW/viewWidth);
//    CGSize size = [_movieIndicator intrinsicContentSize];
//    _movieIndicator.frame = CGRectMake(plX+(newW-size.width)/2, playerFrame.origin.y + (newW/pRatio - size.height)/2 + plX, size.width, size.height);
//    _movieIndicator.center = self.moviePlayerController.view.center;

    //makeviewtransparent
    if(preFrame.origin.y>viewHeight/2){
        alpha = 0.f;
    }
    _bgHeadrView.alpha = alpha;
    _infoView.alpha = alpha;
    _scrollView.alpha = alpha;
    _tabviewPanel.alpha = alpha;
}
-(void)closeLoginView{
    [self.view bringSubviewToFront:_commentView];
    [_commentView setFrame:CGRectMake(10, infoMarginTop + viewHeight/4+30, viewWidth, viewHeight - infoMarginTop -210)];
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
    _btnTabComment.alpha = 1.0f;
     _btnTabInfo.alpha = 0.5f;
     _btnTabRelative.alpha = 0.5f;
    [UIView animateWithDuration:0.5f animations:^{
        CGRect fr =  _commentView.frame;
        [_relateView setFrame:CGRectMake(-viewWidth, fr.origin.y, fr.size.width, fr.size.height)];
        [_overviewView setFrame:CGRectMake(-2*viewWidth, fr.origin.y, fr.size.width, fr.size.height)];
        [_commentView setFrame:CGRectMake(0, fr.origin.y, fr.size.width, fr.size.height)];
        [_tabViewHightLight setFrame:CGRectMake(btnTabWidth*2+btnTabWidth/4, btnTabHeight-2, btnTabWidth/2, 2)];
        
    }];
}
-(void)pressInfoTab:(id)button{
    _currentTab = TAB_INFO;
    _btnTabComment.alpha = 0.5f;
    _btnTabInfo.alpha = 1.0f;
    _btnTabRelative.alpha = 0.5f;
    [UIView animateWithDuration:0.5f animations:^{
        CGRect fr =  _overviewView.frame;
        [_relateView setFrame:CGRectMake(viewWidth, fr.origin.y, fr.size.width, fr.size.height)];
        [_overviewView setFrame:CGRectMake(0, fr.origin.y, fr.size.width, fr.size.height)];
        [_commentView setFrame:CGRectMake(2*viewWidth, fr.origin.y, fr.size.width, fr.size.height)];
        [_tabViewHightLight setFrame:CGRectMake(btnTabWidth/4, btnTabHeight-2, btnTabWidth/2, 2)];
        
    }];
}
-(void)pressRelateTab:(id)button{
    
    _currentTab    = TAB_RELATIVE;
    _btnTabComment.alpha = 0.5f;
    _btnTabInfo.alpha = 0.5f;
    _btnTabRelative.alpha = 1.0f;
    [UIView animateWithDuration:0.5f animations:^{
        CGRect fr =  _relateView.frame;
        [_relateView setFrame:CGRectMake(0, fr.origin.y, fr.size.width, fr.size.height)];
        [_overviewView setFrame:CGRectMake(-viewWidth, fr.origin.y, fr.size.width, fr.size.height)];
        [_commentView setFrame:CGRectMake(viewWidth, fr.origin.y, fr.size.width, fr.size.height)];
        [_tabViewHightLight setFrame:CGRectMake(btnTabWidth+btnTabWidth/4, btnTabHeight-2, btnTabWidth/2, 2)];
    }];
}
-(void)pressCloseMoviePlayerView : (id)button{
//    [self ]
//    [self.moviePlayerViewController.moviePlayer stop];
    [self.moviePlayerController stop];
    [self dismissMoviePlayerViewControllerAnimated];

}
-(void)pressPlay : (id)button{
    
//    [[self navigationController] setNavigationBarHidden:YES animated:YES];
//    
//    [self.view addSubview:_moviePlayerController.view];
//
//    [self.moviePlayerController setContentURL:movieURL];
//    [self.moviePlayerController prepareToPlay];
//    [_btnPlay setHidden:YES];
    [self.moviePlayerController play];
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
   // [self dismissViewControllerAnimated:YES completion:nil];
   // [self.moviePlayerController stop];
//    [self removeView];
    [self removeView];
//    [removeDelegate removeController];
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

    if(_moviePlayerController.playbackState == MPMoviePlaybackStateInterrupted){
        //[player.view removeFromSuperview];
        //[self.ctrStyleView removeFromSuperview];
    
    }else if(_moviePlayerController.playbackState == MPMoviePlaybackStatePlaying){
//        [_btnPlay setHidden:YES];
        [_movieIndicator stopAnimating];
        [_movieIndicator setHidden:YES];
        if(originSize){
        [_btnExpandLess setHidden:NO];
            if(hasControl==YES){
                [self performSelector:@selector(showExpandLessButton) withObject:nil afterDelay:5.f];
            }
        }
//        [_movieIndicator removeFromSuperview];
        
        hasControl = YES;
    }else if(_moviePlayerController.playbackState == MPMoviePlaybackStatePaused){
//        [_btnPlay setHidden:NO];
        hasControl = YES;
        [_btnExpandLess setHidden:NO];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showExpandLessButton) object:nil];
    }else if(_moviePlayerController.playbackState == MPMoviePlaybackStateStopped){
//        [_btnPlay setHidden:NO];
    }
    NSLog(@"stageChanged %d",player.playbackState);
}
-(void)addMovieControl:(NSNotification *)notificaton{
//    [self.view bringSubviewToFront:self.ctrStyleView];
    isFullScreen = YES;
    NSLog(@"fullscreen_xxx");
}
-(void)willExitFullScreenMode:(NSNotification *)notificaton{
    //    [self.view bringSubviewToFront:self.ctrStyleView];
    isFullScreen = NO;
    NSLog(@"fullscreen_xxx");
}
-(void)moviePlayerReadyDisPlay:(NSNotification*)notification{
    if(_moviePlayerController.readyForDisplay == YES){
        [_movieIndicator stopAnimating];
        [_movieIndicator setHidden:YES];
        [_btnExpandLess setHidden:NO];

    }
}
-(void)moviePlayerLoadStateChanged:(NSNotification*)notification{
    NSLog(@"State changed to: %d\n", _moviePlayerController.loadState);
    if(_moviePlayerController.loadState == MPMovieLoadStatePlayable){
        [_movieIndicator stopAnimating];
        [_movieIndicator setHidden:YES];
        [_btnExpandLess setHidden:NO];
        if(self.moviePlayerController.playbackState!=MPMoviePlaybackStatePlaying){
//            [_btnPlay setHidden:NO];

        }
    }else if(_moviePlayerController.loadState == MPMovieLoadStateStalled){
       // [_movieIndicator setHidden:NO];
       // [_movieIndicator startAnimating];
        [_btnExpandLess setHidden:NO];

    }else if(_moviePlayerController.loadState == MPMovieLoadStateUnknown){
    
       // [_movieIndicator setHidden:NO];
       // [_movieIndicator startAnimating];

    }
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
        playerHeight = viewHeight/4 + viewHeight/8;
    }else{
        //panelWidth = PANEL_WIDTH;
        playerHeight = viewHeight/4 + viewWidth/16;
        
    }
}
-(void)removeView{
    
//    
//    [self.moviePlayerController stop];
//    [self.view removeFromSuperview];
    [self.moviePlayerController     stop];
//    [self.view remov];
    [self.view removeFromSuperview];

//    [removeDelegate removeController];

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
    NSLog(@"***** Connection failed");
    int statusCode = [((NSHTTPURLResponse *)response) statusCode];
    if (statusCode == 404)
    {
        [connection cancel];  // stop connecting; no more delegate messages
        NSLog(@"didReceiveResponse statusCode with %i", statusCode);
        UILabel *alert = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 60, 30)];
        alert.text = @"LINK DIED";
        alert.backgroundColor = [UIColor whiteColor];
        [self.moviePlayerController.view addSubview:alert];
    }
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
                    NSArray *listLink= [json objectForKey:@"movie_links"];
                    NSMutableArray *episoder = [[NSMutableArray alloc] init];
                    NSLog(@"LinkfilmARR %@ %d",listLink,listLink.count);
                    if([listLink count]>0){
                        movieURL =[NSURL URLWithString:[listLink objectAtIndex:0 ]];
                        NSLog(@"Linkfilm %@",movieURL);
//                        [_moviePlayerViewController.moviePlayer setContentURL:movieURL];
//                        [_moviePlayerViewController.moviePlayer prepareToPlay];
                    }
                    
                   // NSDictionary *serverlist = [json objectForKey:@"movie_links_server"];
                   // NSLog(@"serverlist %@",[serverlist objectForKey:@"server_2"]);
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [_tbSearch reloadData];
                        for(int i = 0; i < listLink.count;i++){
                            NSString *epiUrl = @"";
//                            if(i%3==0){
//                                epiUrl = [NSString stringWithFormat:@"%@x",[listLink objectAtIndex:i]];
//
//                            }else{
//                                epiUrl = [listLink objectAtIndex:i];
//                            }
                            epiUrl = [listLink objectAtIndex:i];

                            Episoder *epi = [[Episoder alloc] initWithString:epiUrl];
                            [episoder addObject:epi];

                        }
                        [_relateView setDataArrayEpsolider2:episoder];
                        _infoDetail = [[FilmInfoDetails alloc] initWithData:json];
                        [_infoView bindDataToView:_infoDetail];
                        [_overviewView bindDataToView:_infoDetail.name desc:_infoDetail.desc];
//                        [self.moviePlayerViewController .moviePlayer setContentURL:movieURL];
//                        [self.moviePlayerViewController.moviePlayer prepareToPlay];
                        [self.moviePlayerController setContentURL:movieURL];
                        [self.moviePlayerController prepareToPlay];
//                        [_btnPlay setUserInteractionEnabled:YES];
                        [self saveFilmHistory];
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
//    [self pressPlay:nil];
    
}
-(void)playMovieWithData:(SearchResultItem *)item{
    filmInfo = item;
    _infoView.thumbnail.image = nil;
    [self btnMovePanelLeft:nil];
    [self prepareFilmData:item];
}
-(void)playMovieAtIndex:(NSString *)url{
    movieURL = [NSURL URLWithString:url];
//    [self.moviePlayerViewController .moviePlayer setContentURL:movieURL];
//    [self.moviePlayerViewController.moviePlayer prepareToPlay];
//    NSLog(@"movieURL %@",movieURL);
//    _movieIndicator.frame = CGRectMake((viewWidth-size.width)/2, marginTop + (playerHeight- size.height)/2, size.width, size.height);
//    [_btnPlay setHidden:YES];
    NSLog(@"playVideoWithURL%@",url);
    [self.view bringSubviewToFront:_movieIndicator];
    [_movieIndicator setFrame:CGRectMake(0, 0, viewWidth, _moviePlayerController.view.frame.size.height)];
    [_movieIndicator setCenter:CGPointMake(viewWidth/2, playerHeight/2)];
    [_movieIndicator setHidden:NO];
    [_movieIndicator startAnimating];
    [self.moviePlayerController stop];
    [self.moviePlayerController setContentURL:movieURL];
    [self.moviePlayerController prepareToPlay];
//    [self pressPlay:nil];

}
/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationHandlers
{
    MPMoviePlayerController *player = [self moviePlayerController];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:player];
}

/* Delete the movie player object, and remove the movie notification observers. */
-(void)deletePlayerAndNotificationObservers
{
    [self removeMovieNotificationHandlers];
    [self setMoviePlayerController:nil];
}

@end
