//
//  TabCommentView.m
//  SlideMenu
//
//  Created by Apple on 6/4/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import "TabCommentView.h"
#import "FBLoginDialogViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
//#import <FB>
#define FACEBOOK_COMMENT_URL @"https://www.giaiphapcong.vn/resources/"
@interface TabCommentView() <UIWebViewDelegate>
{
    CGFloat viewWidh;
    CGFloat viewHeight;
    int count ;
    NSTimer *_timer;
}
//@property(nonatomic,retain)UIWebView *webview;
@property (nonatomic, retain) NSString *accessToken;
@property(nonatomic,retain)UIActivityIndicatorView  *FbActive;
@property (strong, nonatomic) FBSDKLoginButton *loginButton ;
@property (strong, nonatomic) NSArray *readPermision;
@end

@implementation TabCommentView
@synthesize loginButton;
@synthesize accessToken,webview,FbActive,webDelegate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrameX:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        count = 0;
        _readPermision = @[ @"public_profile",@"email",@"user_friends"];
        viewWidh =frame.size.width;
        viewHeight = frame.size.height;
        [self initViews];
    }
    return self;
}

-(void)initViews{
//    loginButton = [[FBSDKLoginButton alloc] init];
//    loginButton.frame = CGRectMake(10, 0, 300, 50);
//    loginButton.readPermissions = _readPermision;
//    loginButton.center = CGPointMake(viewWidh/2, viewHeight/2);
//    [self addSubview:loginButton];
//    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//    [login logInWithReadPermissions:_readPermision handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//        if (error) {
//            // Process error
//        } else if (result.isCancelled) {
//            // Handle cancellations
//            NSLog(@"LoginCanceled");
//        } else {
//            // If you ask for multiple permissions at once, you
//            // should check if specific permissions missing
//            NSLog(@"LoginSuccessed");
//            [self initFacebookcommentBox];
//            if ([result.grantedPermissions containsObject:@"email"]) {
//                // Do work
//            }
//        }
//    }];
    //[self initFacebookcommentBox];
    
//    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//        login.loginBehavior = FBSDKLoginBehaviorWeb;
//    
//    [login logInWithReadPermissions:nil handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//        if (error || result.isCancelled) {
//          
//        }
//    }];
//    NSHTTPCookie *cookie;
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (cookie in [storage cookies]) {
//        [storage deleteCookie:cookie];
//    }
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [self fbLoginPage:nil];
    [self initFacebookcommentBox];
    [self requestFilmComment:1];
}
-(void)initFacebookcommentBox{
  ////    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"phimb" ofType:@"html" inDirectory:@"www"]];
//    
////    [webview loadRequest:[NSURLRequest requestWithURL:url]];
//    NSURL *url = [NSURL URLWithString:@"https://www.facebook.com/mrdocco88"];
    webview = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, viewWidh, viewHeight) ];
    [self addSubview:webview];
    self.webview.delegate =self;
}
-(void)requestFilmComment : (NSInteger )filmId{
    
////    NSString *fullURL = [NSString stringWithFormat:@"http://sukienmienbac.com.vn/fbcomment.php?id=%d",filmId];
//    
    NSString *fullURL = [NSString stringWithFormat:@"%@phimb.html?id=%d",FACEBOOK_COMMENT_URL,filmId];
    NSURL *url = [NSURL URLWithString:fullURL];
    [webview loadRequest:[NSURLRequest requestWithURL:url]];
//    UIScrollView *scroll = [UIScrollView alloc] initWithFrame:CGRectMake(0, 40, viewWidh, _webview.con)


}
-(void)showFacebookCommentBox{

//     if (![FBSDKAccessToken currentAccessToken]) {
//         [webview setHidden:YES ];
//         [self.loginButton setHidden:NO];
//     }else{
//         [webview setHidden:NO ];
//         [self.loginButton setHidden:YES];
//
//     }
}
-(void)openFacebookAuthentication
{
    NSArray *permission = [NSArray arrayWithObjects:_readPermision, nil];
    
//    FBSession *session = [[FBSession alloc] initWithPermissions:permission];
//    
//    [FBSession setActiveSession: [[FBSession alloc] initWithPermissions:permission] ];
//    
//    [[FBSession activeSession] openWithBehavior:FBSessionLoginBehaviorForcingWebView completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//        
//        switch (status) {
//            case FBSessionStateOpen:
//                [self getMyData];
//                break;
//            case FBSessionStateClosedLoginFailed: {
//                // prefer to keep decls near to their use
//                // unpack the error code and reason in order to compute cancel bool
//                NSString *errorCode = [[error userInfo] objectForKey:FBErrorLoginFailedOriginalErrorCode];
//                NSString *errorReason = [[error userInfo] objectForKey:FBErrorLoginFailedReason];
//                BOOL userDidCancel = !errorCode && (!errorReason || [errorReason isEqualToString:FBErrorLoginFailedReasonInlineCancelledValue]);
//                
//                
//                if(error.code == 2 && ![errorReason isEqualToString:@"com.facebook.sdk:UserLoginCancelled"]) {
//                    UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:kFBAlertTitle
//                                                                           message:kFBAuthenticationErrorMessage
//                                                                          delegate:nil
//                                                                 cancelButtonTitle:kOk
//                                                                 otherButtonTitles:nil];
//                    [errorMessage performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
//                    errorMessage = nil;
//                }
//            }
//                break;
//                // presently extension, log-out and invalidation are being implemented in the Facebook class
//            default:
//                break; // so we do nothing in response to those state transitions
//        }
//    }];
//    permission = nil;
}
-(void)fbLoginPage:(UIButton *)sender1
{
    
    
    NSString   *facebookClientID =@"861434543930983";
    NSString   *redirectUri = @"http://www.facebook.com/connect/login_success.html";
    NSString  *extended_permissions=@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins,email";
    
    NSString *url_string = [NSString stringWithFormat:@"https://graph.facebook.com/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@&type=user_agent&display=touch", facebookClientID, redirectUri, extended_permissions];
    NSURL *url = [NSURL URLWithString:url_string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    CGRect webFrame =CGRectMake(0, 100, viewWidh, viewHeight);
    webFrame.origin.y = 0;
    UIWebView *aWebView = [[UIWebView alloc] initWithFrame:webFrame];
    [aWebView setDelegate:self];
    aWebView.backgroundColor = [UIColor grayColor];
    self.webview = aWebView;
    self.FbActive = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.FbActive.color=[UIColor darkGrayColor];
    self.FbActive.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [self.FbActive startAnimating];
    
    [webview loadRequest:request];
    [self.webview addSubview:self.FbActive];
    [self addSubview:webview];
    
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView;{

}
- (void)webViewDidFinishLoad:(UIWebView *)_webView {
//    
//    /**
//     * Since there's some server side redirecting involved, this method/function will be called several times
//     * we're only interested when we see a url like:  http://www.facebook.com/connect/login_success.html#access_token=..........
//     */
//    
//    //get the url string
//    [self.FbActive stopAnimating];
//    NSString *url_string = [((_webView.request).URL) absoluteString];
//    
//    //looking for "access_token="
//    NSRange access_token_range = [url_string rangeOfString:@"access_token="];
//    
//    //looking for "error_reason=user_denied"
//    NSRange cancel_range = [url_string rangeOfString:@"error_reason=user_denied"];
//    
//    //it exists?  coolio, we have a token, now let's parse it out....
//    if (access_token_range.length > 0) {
//        
//        //we want everything after the 'access_token=' thus the position where it starts + it's length
//        int from_index = access_token_range.location + access_token_range.length;
//        NSString *access_token = [url_string substringFromIndex:from_index];
//        
//        //finally we have to url decode the access token
//        access_token = [access_token stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        
//        //remove everything '&' (inclusive) onward...
//        NSRange period_range = [access_token rangeOfString:@"&"];
//        
//        //move beyond the .
//        access_token = [access_token substringToIndex:period_range.location];
//        
//        //store our request token....
//        self.accessToken = access_token;
//        
//        //remove our window
//        //      UIWindow* window = [UIApplication sharedApplication].keyWindow;
//        //      if (!window) {
//        //          window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//        //      }
//        
//        [self.webview removeFromSuperview];
//        self.webview=nil;
//        
//        
//        
//        //tell our callback function that we're done logging in :)
//        //      if ( (callbackObject != nil) && (callbackSelector != nil) ) {
//        //          [callbackObject performSelector:callbackSelector];
//        //      }
//        
//        //the user pressed cancel
//        
//    }
//    else if (cancel_range.length > 0)
//    {
//        //remove our window
//        //      UIWindow* window = [UIApplication sharedApplication].keyWindow;
//        //      if (!window) {
//        //          window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//        //      }
//        
//        [self.webview removeFromSuperview];
//        self.webview=nil;
//        
//        //tell our callback function that we're done logging in :)
//        //      if ( (callbackObject != nil) && (callbackSelector != nil) ) {
//        //          [callbackObject performSelector:callbackSelector];
//        //      }
//        
//    }
//    [self getuserdetailes];
    if (count==10) {

   // NSString *userName = [self.webview stringByEvaluatingJavaScriptFromString:@"testAPI()"];
    
      
//    [self setFrame:CGRectMake(10, 10, viewWidh-20, viewHeight*4)];
//    [self.webview setFrame:self.frame];
        [self performSelector:@selector(checkStatus) withObject:nil afterDelay:1.0f];
        count++;
    }
//    self br
}
-(void)checkStatus{
  NSInteger resStatus =  [[self.webview stringByEvaluatingJavaScriptFromString:@"testLoginAPI()"] integerValue];
    if (resStatus==0) {
        [webview setHidden:YES];
        UIButton *btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 100, 100) ];
        [btnLogin setTitle:@"Login" forState:UIControlStateNormal ];
        [btnLogin addTarget:self action:@selector(doShowLoginView:) forControlEvents:UIControlEventTouchUpInside];
        btnLogin.backgroundColor = [UIColor redColor];
        [self addSubview:btnLogin];
    }else if(resStatus == 1){
    [webview setHidden:NO];
        [self bringSubviewToFront:webview];
        [webDelegate closeLoginView];
    }
    NSLog(@"testAPI%d",resStatus);

}
-(void)checkLoginSucess{
    NSInteger resStatus =  [[self.webview stringByEvaluatingJavaScriptFromString:@"testLoginAPI()"] integerValue];
    if (resStatus==0) {
        [webview setHidden:YES];
        UIButton *btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 100, 100) ];
        [btnLogin setTitle:@"Login" forState:UIControlStateNormal ];
        [btnLogin addTarget:self action:@selector(doShowLoginView:) forControlEvents:UIControlEventTouchUpInside];
        btnLogin.backgroundColor = [UIColor redColor];
        [self addSubview:btnLogin];
    }else if(resStatus == 1){
     
        if(_timer)
        {
            [_timer invalidate];
            _timer = nil;
        }
        [webview setHidden:NO];
        [self bringSubviewToFront:webview];
        [webDelegate closeLoginView];
    }
    NSLog(@"closeloginviewx%d",resStatus);
}
-(void)doShowLoginView : (id)button{
//    [webview setHidden:NO];
//    [self bringSubviewToFront:webview];
    [webDelegate showLoginView];
    
   _timer =  [ NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkLoginSucess) userInfo:nil repeats:YES];
    
}

-(void)getuserdetailes
{
    NSString *action=@"me";
    
    NSString *url_string = [NSString stringWithFormat:@"https://graph.facebook.com/%@?", action];
    
    //tack on any get vars we have...
    
    NSDictionary *get_vars=nil;
    
    if ( (get_vars != nil) && ([get_vars count] > 0) ) {
        
        NSEnumerator *enumerator = [get_vars keyEnumerator];
        NSString *key;
        NSString *value;
        while ((key = (NSString *)[enumerator nextObject])) {
            
            value = (NSString *)[get_vars objectForKey:key];
            url_string = [NSString stringWithFormat:@"%@%@=%@&", url_string, key, value];
            
        }//end while
    }//end if
    
    if (accessToken != nil)
    {
        
        //now that any variables have been appended, let's attach the access token....
        url_string = [NSString stringWithFormat:@"%@access_token=%@", url_string, self.accessToken];
        url_string = [url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",url_string);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url_string]];
        
        NSError *err;
        NSURLResponse *resp;
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&err];
        NSString *stringResponse = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"%@",stringResponse);
        NSError* error;
        NSDictionary *FBResResjson = [NSJSONSerialization
                                      JSONObjectWithData:response//1
                                      options:kNilOptions
                                      error:&error];
        NSLog(@"%@",FBResResjson);
        
        
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    // Get the specific point that was touched
    CGPoint point = [touch locationInView:self];
    NSLog(@"X location: %f", point.x);
    NSLog(@"Y Location: %f",point.y);
}
@end
