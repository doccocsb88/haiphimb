//
//  HomeViewController.m
//  phimb
//
//  Created by Apple on 6/10/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeMenuViewController.h"
#import "FilmHomeViewController.h"
#import "UIDevice-Hardware.h"
#import "UserDataViewController.h"
#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2
//#define RIGHT_PANEL_TAG 3

#define CORNER_RADIUS 4

#define SLIDE_TIMING .25
#define PANEL_WIDTH 60
@interface HomeViewController () <HomeControllerDelegate,UIGestureRecognizerDelegate>


@property (nonatomic, strong) FilmHomeViewController *CenterXViewController;
@property (nonatomic, strong) HomeMenuViewController *leftPanelViewController;
@property (nonatomic, assign) BOOL showingLeftPanel;
@property (nonatomic, assign) CGFloat panelWidth;
//@property (nonatomic, strong) RelateFilmViewController *rightPanelViewController;
@property (nonatomic, assign) BOOL showingRightPanel;
@property (nonatomic, assign) BOOL showPanel;
@end

@implementation HomeViewController
@synthesize panelWidth;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *deviceString =[[UIDevice currentDevice] platformString];
    if ([deviceString containsString:@"iPad"]) {
        panelWidth = self.view.frame.size.width - 320;
    }else{
        panelWidth = PANEL_WIDTH;
        
    }
    [self setupViews];
//    UserDataViewController *vc = [[UserDataViewController alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        // portrait
        panelWidth = PANEL_WIDTH;
        
    } else {
        // landscape
        panelWidth = self.view.frame.size.width - (self.view.frame.size.height - 60);
        
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
//-(void)movePanelLeft:(NSString *)cate{
//    UIView *childView = [self getRightView];
//    [self.rightPanelViewController loadRelateFilm:cate];
//    [self.view sendSubviewToBack:childView];
//    
//    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//        _CenterXViewController.view.frame = CGRectMake(-self.view.frame.size.width + panelWidth, 0, self.view.frame.size.width, self.view.frame.size.height);
//    }
//                     completion:^(BOOL finished) {
//                         if (finished) {
//                             
//                             _CenterXViewController.rightButton.tag = 0;
//                         }
//                     }];
//    
//}
//-(void)movePanelLeft {
//    UIView *childView = [self getRightView];
//    [self.view sendSubviewToBack:childView];
//    
//    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//        _CenterXViewController.view.frame = CGRectMake(-self.view.frame.size.width + panelWidth, 0, self.view.frame.size.width, self.view.frame.size.height);
//    }
//                     completion:^(BOOL finished) {
//                         if (finished) {
//                             
//                             _CenterXViewController.homeMenu.tag = 0;
//                         }
//                     }];
//}
-(void)movePanelRight {
    UIView *childView = [self getLeftView];
    [self.view sendSubviewToBack:childView];

    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _CenterXViewController.view.frame = CGRectMake(self.view.frame.size.width - panelWidth, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             _CenterXViewController.homeMenu.tag = 0;
                         }
                     }];
}
-(void)setupViews{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.CenterXViewController = [storyboard instantiateViewControllerWithIdentifier:@"filmhomevc"];
    //    self.CenterXViewController.indexTagView = indexTab;
    self.CenterXViewController.view.tag = CENTER_TAG;
    self.CenterXViewController.homeDelegate = self;
    [self.view addSubview:self.CenterXViewController.view];
    [self addChildViewController:_CenterXViewController];
    [_CenterXViewController didMoveToParentViewController:self];
//    [self.CenterXViewController prepareFilmData:self.filmData];
    
}
-(void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset {
    if (value) {
        [_CenterXViewController.view.layer setCornerRadius:CORNER_RADIUS];
        [_CenterXViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [_CenterXViewController.view.layer setShadowOpacity:0.8];
        [_CenterXViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
        
    } else {
        [_CenterXViewController.view.layer setCornerRadius:0.0f];
        [_CenterXViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}


-(void)movePanelToOriginalPosition {
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _CenterXViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self resetMainView];
                         }
                     }];
}
-(void)resetMainView {
    // remove left and right views, and reset variables, if needed
        if (_leftPanelViewController != nil) {
            [self.leftPanelViewController.view removeFromSuperview];
            self.leftPanelViewController = nil;
            _CenterXViewController.homeMenu.tag = 1;
            self.showingLeftPanel = NO;
        }
//    if (_rightPanelViewController != nil) {
//        [self.rightPanelViewController.view removeFromSuperview];
//        self.rightPanelViewController = nil;
//        _CenterXViewController.rightButton.tag = 1;
//        self.showingRightPanel = NO;
//    }
    // remove view shadows
    [self showCenterViewWithShadow:NO withOffset:0];
}
-(UIView *)getLeftView {
    // init view if it doesn't already exist
    if (_leftPanelViewController == nil)
    {
        // this is where you define the view for the left panel
        //		self.leftPanelViewController = [[LeftPanelViewController alloc] initWithNibName:@"LeftPanelViewController" bundle:nil];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle: nil];
        self.leftPanelViewController = (HomeMenuViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"HomeMenuViewController"];
//        self.leftPanelViewController.indexTagView = indexTab;
        self.leftPanelViewController.view.tag = LEFT_PANEL_TAG;
        self.leftPanelViewController.delegate = _CenterXViewController;

        [self.view addSubview:self.leftPanelViewController.view];


        [_leftPanelViewController didMoveToParentViewController:self];

        _leftPanelViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }

    self.showingLeftPanel = YES;

    // setup view shadows
    [self showCenterViewWithShadow:YES withOffset:-2];

    UIView *view = self.leftPanelViewController.view;
    return view;
}

@end
