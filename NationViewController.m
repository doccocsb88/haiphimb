//
//  NationViewController.m
//  phimb
//
//  Created by becauseyoulive1989 on 4/25/16.
//  Copyright © 2016 com.haiphone. All rights reserved.
//

#import "NationViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "MainViewController.h"
#import "NationFilmViewController.h"
#import "LeftPanelViewController.h"
#import "RightPanelViewController.h"
#import "UIDevice-Hardware.h"
#import "Reachability.h"
// import it in your header or implementation file.

#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2
#define RIGHT_PANEL_TAG 3

#define CORNER_RADIUS 4

#define SLIDE_TIMING .25
#define PANEL_WIDTH 60
@interface NationViewController () <NationFilmDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) NationFilmViewController *CenterXViewController;
@property (nonatomic, strong) LeftPanelViewController *leftPanelViewController;
@property (nonatomic, assign) BOOL showingLeftPanel;
@property (nonatomic, assign) CGFloat panelWidth;
@property (nonatomic, strong) RightPanelViewController *rightPanelViewController;
@property (nonatomic, assign) BOOL showingRightPanel;
@property (nonatomic, assign) BOOL showPanel;
@property (nonatomic, assign) CGPoint preVelocity;
@property (assign,nonatomic) NSInteger indexTab;
@property (nonatomic) UIDeviceOrientation currentDeviceOrientation;

@end

@implementation NationViewController
@synthesize indexTab;
@synthesize panelWidth;
-(void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    indexTab = self.view.tag;
    NSString *deviceString =[[UIDevice currentDevice] platformString];
    if ([deviceString containsString:@"iPad"]) {
        panelWidth = self.view.frame.size.width - 320;
    }else{
        panelWidth = PANEL_WIDTH;
        
    }
    NSLog(@"deviceName %@",[[UIDevice currentDevice] platformString]);
    //    [self setupNetwork];
    [self setupView];
    self.currentDeviceOrientation = [[UIDevice currentDevice] orientation];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
//    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
//        // portrait
//        panelWidth = PANEL_WIDTH;
//        
//    } else {
//        // landscape
//        panelWidth = self.view.frame.size.width - (self.view.frame.size.height - 60);
//        
//    }
}
#pragma mark -
#pragma mark View Will/Did Appear

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSInteger index  = [self.tabBarController selectedIndex];
    NSLog(@"selectedIndexTab %d",index);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ([[UIDevice currentDevice] isGeneratingDeviceOrientationNotifications]) {
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    }
}
#pragma mark -
#pragma mark View Will/Did Disappear

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSInteger index  = [self.tabBarController selectedIndex];
    
    NSLog(@"selectedIndexTabZ %d",index);
    
}


- (void)deviceDidRotate:(NSNotification *)notification
{
    self.currentDeviceOrientation = [[UIDevice currentDevice] orientation];
    // Do what you want here
    UIDeviceOrientation currentOrientation = [[UIDevice currentDevice] orientation];
    
    // Ignore changes in device orientation if unknown, face up, or face down.
    if (!UIDeviceOrientationIsValidInterfaceOrientation(currentOrientation)) {
        return;
    }
    
    BOOL isLandscape = UIDeviceOrientationIsLandscape(currentOrientation);
    BOOL isPortrait = UIDeviceOrientationIsPortrait(currentOrientation);
}

#pragma mark - Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation    {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.tbFilm.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
         NSLog(@"width : %f height: %f",self.view.frame.size.width,self.view.frame.size.height);
    }else if (toInterfaceOrientation == UIInterfaceOrientationPortrait){
        NSLog(@"width : %f height: %f",self.view.frame.size.width,self.view.frame.size.height);
          self.tbFilm.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
}

#pragma mark -
#pragma mark Setup View
-(void)passedGenreIndex:(NSInteger)index{
    NSLog(@"testPassValue");
    [_CenterXViewController loadListFilm:index];
}
-(void)setupView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.CenterXViewController = [storyboard instantiateViewControllerWithIdentifier:@"nationfilmvc"];
    //    self.CenterXViewController.indexTagView = indexTab;
    self.CenterXViewController.view.tag = CENTER_TAG;

    self.CenterXViewController.delegate = self;
    [self.view addSubview:self.CenterXViewController.view];
    [self addChildViewController:_CenterXViewController];
    [_CenterXViewController didMoveToParentViewController:self];
    
    [self setupGestures];
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

-(void)resetMainView {
    // remove left and right views, and reset variables, if needed
    if (_leftPanelViewController != nil) {
        [self.leftPanelViewController.view removeFromSuperview];
        self.leftPanelViewController = nil;
        _CenterXViewController.leftButton.tag = 1;
//        self.showingLeftPanel = NO;
    }
    if (_rightPanelViewController != nil) {
        [self.rightPanelViewController.view removeFromSuperview];
        self.rightPanelViewController = nil;
        _CenterXViewController.rightButton.tag = 1;
//        self.showingRightPanel = NO;
    }
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
        self.leftPanelViewController = (LeftPanelViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"LeftPanelViewController"];
        self.leftPanelViewController.indexTagView = indexTab;
        self.leftPanelViewController.view.tag = LEFT_PANEL_TAG;
        self.leftPanelViewController.delegate = _CenterXViewController;
        
        [self.view addSubview:self.leftPanelViewController.view];
        
        [self addChildViewController:_leftPanelViewController];
        [_leftPanelViewController didMoveToParentViewController:self];
        
        _leftPanelViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    self.showingLeftPanel = YES;
    
    // setup view shadows
    [self showCenterViewWithShadow:YES withOffset:-2];
    
    UIView *view = self.leftPanelViewController.view;
    return view;
}

-(UIView *)getRightView {
    // init view if it doesn't already exist
    if (_rightPanelViewController == nil)
    {
        /* setRightPanelNil
         // this is where you define the view for the right panel
         self.rightPanelViewController = [[RightPanelViewController alloc] initWithNibName:@"RightPanelViewController" bundle:nil];
         self.rightPanelViewController.view.tag = RIGHT_PANEL_TAG;
         self.rightPanelViewController.delegate = _CenterXViewController;
         
         [self.view addSubview:self.rightPanelViewController.view];
         
         [self addChildViewController:self.rightPanelViewController];
         [_rightPanelViewController didMoveToParentViewController:self];
         
         _rightPanelViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
         */
    }
    self.showingRightPanel = YES;
    
    // setup view shadows
    [self showCenterViewWithShadow:YES withOffset:2];
    
    UIView *view = self.rightPanelViewController.view;
    return view;
}

#pragma mark -


#pragma mark Swipe Gesture Setup/Actions
-(void)setupGestures {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    [_CenterXViewController.view addGestureRecognizer:panRecognizer];
}

-(void)movePanel:(id)sender {
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        UIView *childView = nil;
        
        if(velocity.x > 0) {
            if (!_showingRightPanel) {
                childView = [self getLeftView];
            }
        } else {
            if (!_showingLeftPanel) {
//                childView = [self getRightView];
            }
            
        }
        // make sure the view we're working with is front and center
        [self.view sendSubviewToBack:childView];
        [[sender view] bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        if(velocity.x > 0) {
            // NSLog(@"gesture went right");
        } else {
            // NSLog(@"gesture went left");
        }
        
        if (!_showPanel) {
            [self movePanelToOriginalPosition];
        } else {
            if (_showingLeftPanel) {
                [self movePanelRight];
            }  else if (_showingRightPanel) {
                //                [self movePanelLeft];
            }
        }
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        if(velocity.x > 0 || [sender view].frame.origin.x > 0) {
            // NSLog(@"gesture went right");
            
            
            // are we more than halfway, if so, show the panel when done dragging by setting this value to YES (1)
            _showPanel = abs([sender view].center.x - _CenterXViewController.view.frame.size.width/2) > _CenterXViewController.view.frame.size.width/2;
            
            // allow dragging only in x coordinates by only updating the x coordinate with translation position
            [sender view].center = CGPointMake([sender view].center.x + translatedPoint.x, [sender view].center.y);
            [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
            
            // if you needed to check for a change in direction, you could use this code to do so
            if(velocity.x*_preVelocity.x + velocity.y*_preVelocity.y > 0) {
                // NSLog(@"same direction");
            } else {
                // NSLog(@"opposite direction");
            }
            
            _preVelocity = velocity;
        } else {
            // NSLog(@"gesture went left");
        }
    }
}

#pragma mark -
#pragma mark Delegate Actions

-(void)movePanelLeft {
    UIView *childView = [self getRightView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _CenterXViewController.view.frame = CGRectMake(-self.view.frame.size.width + panelWidth, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             _CenterXViewController.rightButton.tag = 0;
                         }
                     }];
}

-(void)movePanelRight {
    UIView *childView = [self getLeftView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _CenterXViewController.view.frame = CGRectMake(self.view.frame.size.width - panelWidth, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             _CenterXViewController.leftButton.tag = 0;
                         }
                     }];
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

@end
