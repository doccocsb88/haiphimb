//
//  FilmHomeViewController.m
//  SlideMenu
//
//  Created by Apple on 5/29/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import "FilmHomeViewController.h"
#import "ListFilmViewController.h"
#import "SearchViewController.h"
#import "Genre.h"
#import "ColorSchemeHelper.h"
#import "ListFilmCell.h"
#import "PlayVideoViewController.h"
#import "UserDataViewController.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
@interface FilmHomeViewController ()
{
    NSMutableDictionary *filmData;
    NSArray *paramData;
    CGFloat marginTop;
//    NSMutableArray *filmData;
    CGFloat boxW;
    NSMutableData *receivedData;
    CGSize viewSize;
    NSInteger paramPage;
    NSInteger tabIndex;
//    CGFloat tabHeight;
    UIView *tabHightLight;

}
@property (nonatomic,strong) Genre *genre;
@property (nonatomic ,strong) NSString *urlAPI;
@property (weak, nonatomic) IBOutlet UIView *bgHeader;
@property (nonatomic,strong) UserDataViewController *historyView;
//@property (strong,nonatomic) UIButton *btnTabMostView;
//@property (strong,nonatomic) UIButton *btnTabNew;
//@property (strong,nonatomic) UIButton *btnTabSet;


@end

@implementation FilmHomeViewController 
@synthesize homeDelegate;
- (void)viewDidLoad {
   
    [super viewDidLoad];
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
//    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"searchviewcontroller"];
    //SearchViewController *vc = [[SearchViewController alloc] init];
   // [SlideNavigationController sharedInstance].rightMenu = vc;
    /**/
    _sliderHeight =0;//(self.view.frame.size.height - 64)/4;
    viewSize = self.view.frame.size;
    tabIndex = 0;
    marginTop = 64;
//    tabHeight = 30;
    [self initNotification];
    [self initDatas];
    [self initViews];
    self.view.backgroundColor = [UIColor purpleColor];
    // Do any additional setup after loading the view.
//    UIScrollView *scr=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, _sliderHeight)];
////
//    scr.tag = 1;
//    scr.autoresizingMask=UIViewAutoresizingFlexibleWidth;
//    [self.view addSubview:scr];
//    [self setupScrollView:scr];
//    UIPageControl *pgCtr = [[UIPageControl alloc] initWithFrame:CGRectMake(0, scr.frame.size.height - 36, self.view.frame.size.width, 36)];
//    [pgCtr setTag:12];
//    pgCtr.numberOfPages=10;
//    pgCtr.autoresizingMask=UIViewAutoresizingNone;
//    [self.view addSubview:pgCtr];
//    scr.contentSize = CGSizeMake(scr.contentSize.width,1.0f);

}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self.historyView refreshHistoryData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return YES;
}
-(void)initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doTabOnView:)
                                                 name:@"playmovieTouch" object:nil];

}
- (void)doTabOnView:(NSNotification *) notification{
    NSDictionary *userInfo = notification.userInfo;
    NSSet *touches = [userInfo objectForKey:@"touchesKey"];
    CGPoint location = [[touches anyObject] locationInView:self.view];
//    NSLog(<#NSString *format, ...#>)
    [self findViewAtPoint:location];
    NSLog(@"reciveTouchEvent %f :%f",location.x,location.y);
}
-(void)findViewAtPoint:(CGPoint)point{
    if (point.y>marginTop && point.y< marginTop+20) {
        //click ontab
         CGFloat tabW = viewSize.width/3;
        int tab = point.x /tabW;
        switch (tab) {
//            case 0:
//                [_btnTabNew sendActionsForControlEvents: UIControlEventTouchUpInside];
//
//                break;
//            case 1:
//                [_btnTabMostView sendActionsForControlEvents: UIControlEventTouchUpInside];
//
//                break;
//            case 2:
//                [_btnTabSet sendActionsForControlEvents: UIControlEventTouchUpInside];
//
//                break;
            default:
                break;
        }
    }else if(point.y > marginTop+20){
//        CGPoint cpoint  = _filmCollection.contentOffset;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:_filmCollection didSelectRowAtIndexPath:indexPath atPoint:CGPointMake(point.x, point.y-marginTop)] ;
//        [_filmCollection ]
//        _filmCollection did
    }

}
-(void)initDatas{
    filmData = [[NSMutableDictionary alloc] init];
    NSArray *lstKey = @[
            [[Genre alloc] initWithTitle:@"PHIM BỘ MỚI CẬP NHẬT" withKey:@"new/"],
            [[Genre alloc] initWithTitle:@"PHIM XEM NHIỀU" withKey:@"carousel/"],
            [[Genre alloc] initWithTitle:@"PHIM BỘ ĐÃ HOÀN THÀNH" withKey:@"phim-bo-da-hoan-thanh/"]];
        paramData = [[NSArray alloc] initWithArray:lstKey ];
}
-(void) initViews{

    
    [self initHistoryView];
    [self initNavigatorView];
    [self initTableFilmCollection];
    [self initTabs];

}
-(void)initTabs{
//    CGFloat tabW = viewSize.width/3;
//    UIView *tabPanel = [[UIView alloc] initWithFrame:CGRectMake(0, _sliderHeight, viewSize.width, tabHeight)];
//    tabPanel.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:tabPanel];
//    UIFont *font  = [UIFont systemFontOfSize:13.f];
//    _btnTabNew = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tabW, tabHeight)];
//    _btnTabNew.tag = 0;
//    _btnTabNew.titleLabel.font = font;
//    [_btnTabNew setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_btnTabNew setTitle:@"Mới" forState:UIControlStateNormal];
//    [_btnTabNew addTarget:self action:@selector(pressedTab:) forControlEvents:UIControlEventTouchUpInside];
    //
//    _btnTabMostView = [[UIButton alloc] initWithFrame:CGRectMake(tabW, 0, tabW, tabHeight)];
//    _btnTabMostView.tag = 1;
//    _btnTabMostView.titleLabel.font = font;
//    [_btnTabMostView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_btnTabMostView setTitle:@"Xem nhiều" forState:UIControlStateNormal];
//    [_btnTabMostView addTarget:self action:@selector(pressedTab:) forControlEvents:UIControlEventTouchUpInside];
    //
//    _btnTabSet = [[UIButton alloc] initWithFrame:CGRectMake(tabW*2, 0, tabW, tabHeight)];
//    _btnTabSet.tag = 2;
//    _btnTabSet.titleLabel.font = font;
//    [_btnTabSet setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_btnTabSet setTitle:@"Phim bộ" forState:UIControlStateNormal];
//    [_btnTabSet addTarget:self action:@selector(pressedTab:) forControlEvents:UIControlEventTouchUpInside];
    //
//    tabHightLight = [[UIView alloc] initWithFrame:CGRectMake(tabW/4, tabHeight-2, tabW/2, 2)];
//    tabHightLight.backgroundColor = [ColorSchemeHelper sharedNationHeaderColor];
//    [tabPanel addSubview:tabHightLight];
//    //
////    [tabPanel addSubview:_btnTabMostView];
//    [tabPanel addSubview:_btnTabNew];
////    [tabPanel addSubview:_btnTabSet];
//    [tabPanel.layer setCornerRadius:0];
//    [tabPanel.layer setShadowColor:[UIColor blackColor].CGColor];
//    [tabPanel.layer setShadowOpacity:0.3];
//    [tabPanel.layer setShadowOffset:CGSizeMake(2, 2)];
//    [self.homeContainer addSubview:tabPanel];
}

-(void)initHistoryView{
    _historyView = [[UserDataViewController alloc] initWithFrame:CGRectMake(viewSize.width, 64, viewSize.width, viewSize.height-64)];
    _historyView.delegate = self;
    [_historyView setHidden:YES];
    [self.view addSubview:_historyView];
    
}
-(void)initNavigatorView{
  
    _bgHeader.backgroundColor = [ColorSchemeHelper sharedNationHeaderColor];
    
    [self.view addSubview:_bgHeader];
    _homeMenu = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 50, 44)];
//    [_homeMenu setTitle:@"Menu" forState:UIControlStateNormal];
    _homeMenu.tag = 1;
    [_bgHeader addSubview:_homeMenu];
    UIImageView *leftMenu = [[UIImageView alloc] initWithFrame:CGRectMake(5,7, 30, 30)];
    leftMenu.contentMode =  UIViewContentModeScaleAspectFit;
    leftMenu.image = [UIImage imageNamed:@"left_menu.png"];
    [_homeMenu addSubview:leftMenu];
    [_homeMenu addTarget:self action:@selector(btnMovePanelRight:) forControlEvents:UIControlEventTouchUpInside];
    //initTitle
    _homeTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, viewSize.width-120, 44)];
    _homeTitle.textColor = [UIColor whiteColor];
    _homeTitle.textAlignment = NSTextAlignmentCenter;
    _homeTitle.text = @"Home";
    _homeTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
    [self.view addSubview:_homeTitle];
    
}
-(void)initTableFilmCollection{
 
}
- (void)setupScrollView:(UIScrollView*)scrMain {
    // we have 10 images here.
    // we will add all images into a scrollView &amp; set the appropriate size.
    /*
    for (int i=1; i<=10; i++) {
        // create image
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"boa%d.jpg",i]];
        // create imageView
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake((i-1)*scrMain.frame.size.width, 0, scrMain.frame.size.width, _sliderHeight)];
        // set scale to fill
        imgV.contentMode=UIViewContentModeScaleAspectFill;
        // set image
        [imgV setImage:image];
        // apply tag to access in future
        imgV.tag=i+1;
        // add to scrollView
        [scrMain addSubview:imgV];
    }
    // set the content size to 10 image width
    [scrMain setContentSize:CGSizeMake(scrMain.frame.size.width*10, scrMain.frame.size.height)];
    // enable timer after each 2 seconds for scrolling.
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
     */
}
- (void)scrollingTimer {
    // access the scroll view with the tag
    /*
    UIScrollView *scrMain = (UIScrollView*) [self.view viewWithTag:1];
    // same way, access pagecontroll access
    UIPageControl *pgCtr = (UIPageControl*) [self.view viewWithTag:12];
    // get the current offset ( which page is being displayed )
    CGFloat contentOffset = scrMain.contentOffset.x;
    // calculate next page to display
    int nextPage = (int)(contentOffset/scrMain.frame.size.width) + 1 ;
    // if page is not 10, display it
    if( nextPage!=10 )  {
        [scrMain scrollRectToVisible:CGRectMake(nextPage*scrMain.frame.size.width, 0, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
        pgCtr.currentPage=nextPage;
        // else start sliding form 1 :)
    } else {
        [scrMain scrollRectToVisible:CGRectMake(0, 0, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
        pgCtr.currentPage=0;
    }
     */
}
#pragma mark - UITableView Methods - FilmCollection
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size.height - 64 - 50;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.row %2==0){
//
//        
//        UITableViewCell *cell = [[UITableViewCell alloc] init];
//        cell.textLabel.text = @"kjdkfjkdjf";
//        return cell;
//    }else{
        static NSString *simpleTableIdentifier = @"filmcell";
        FilmCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[FilmCollectionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier height:viewSize.height - _sliderHeight width:self.view.frame.size.width withGenre:[paramData objectAtIndex:indexPath.row % paramData.count]];
            cell.homeDeleage = self;

        }
    cell.homeDeleage = self;
    Genre *key = [paramData objectAtIndex:tabIndex];
    if([filmData objectForKey:key.key]==nil){
        [cell setContentView:key];

    }else{
        [cell setContentView:key withData:[filmData objectForKey:key]];
    }

    return cell;
//    }
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    FilmCollectionViewCell *cell = (FilmCollectionViewCell*)[_filmCollection cellForRowAtIndexPath:indexPath];
//    NSLog(@"didselect--->1");
//    [cell didSelectItemAtPoint:CGPointMake(0, 0)];
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath atPoint:(CGPoint)point{
    FilmCollectionViewCell *cell = (FilmCollectionViewCell*)[_filmCollection cellForRowAtIndexPath:indexPath];
    NSLog(@"didselect--->1");
    [cell didSelectItemAtPoint:point];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)presentPlayMovieController:(SearchResultItem *)item{

   UIViewController *topVc =  [AppDelegate topMostController];
    if ([topVc isKindOfClass:[PlayVideoViewController class]]) {
        PlayVideoViewController *vc = (PlayVideoViewController*)topVc;
        [vc prepareFilmData:item];
        [vc scaleViewToOriginalSize];
    }else{
    PlayVideoViewController *vc = [[PlayVideoViewController alloc] initWithInfo:item];
    [vc prepareFilmData:item];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.view.backgroundColor = [UIColor clearColor];
    [self presentViewController:vc animated:YES completion:nil];
    }
    NSLog(@"didselect--->4");


}
-(void)pushListFilmController{
    NSLog(@"pushcontroller");
    ListFilmViewController *vc = [[ListFilmViewController alloc] init];
    [self.navigationController pushViewController: vc animated:YES];

}
-(void)loadThumbnailDidFetch:(NSArray *)data forCate:(NSString *)cate{
    
    
    if([filmData objectForKey:cate]==nil){
        [filmData setValue:data forKey:cate];
//      NSLog(@"didFetchArray");
//      NSArray *arrs = [filmData objectForKey:cate];
        NSLog(@"RecivedloadingDone%d",data.count);
        for(int i = 0; i < data.count;i++){
            SearchResultItem *item = [data objectAtIndex:i];
            NSLog(@"->%@",item.name);
        }
    }
    
    
}
-(int)getIndexOfCat : (NSString *)cate{
    int intdex = -1;
    for (int i = 0; i < paramData.count; i++) {
        NSString *cat = [paramData objectAtIndex:i];
        if([cat isEqualToString:cate]){
            intdex = i;
            break;
        }
    }
    return intdex;
}
#pragma mark - Action
-(void)showSearchViewController{
    SearchViewController *vc= [[SearchViewController alloc]init];
    [self presentViewController:vc
                       animated:YES
                     completion:nil];
    
}
#pragma Mark 
-(IBAction)btnMovePanelRight:(id)sender {
    UIButton *button = sender;
    NSLog(@"HomeMenuButton %d",button.tag);

    switch (button.tag) {
        case 0: {
            [homeDelegate movePanelToOriginalPosition];
            break;
        }
            
        case 1: {
            [homeDelegate movePanelRight];
            break;
        }
            
        default:
            break;
    }
}
-(IBAction)btnMovePanelLeft:(id)sender {
    UIButton *button = sender;
    
    switch (button.tag) {
        case 0: {
//            [_relateView setHidden:NO];
//            [_commentView setHidden:NO];
            [homeDelegate movePanelToOriginalPosition];
            break;
        }
            
        case 1: {
//            [_relateView setHidden:YES];
//            [_commentView setHidden:YES];
//            NSArray *cats = [self getListGenreKey:_infoDetail.cate];
            [homeDelegate movePanelLeft];
            break;
        }
            
        default:
            break;
    }
}
-(void)playHistoryMovie:(NSInteger)filmID{
    
    SearchResultItem *item = [[SearchResultItem alloc] init];
    item._id = filmID;
    PlayVideoViewController *vc = [[PlayVideoViewController alloc] initWithInfo:item];
    [vc prepareFilmData:item];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.view.backgroundColor = [UIColor whiteColor];
    
    [self presentViewController:vc animated:YES completion:nil];
}
-(void)didSelectMenu:(NSInteger)index type:(NSInteger)type{
    int selectIndex =0;
    if (type==2) {
        //Genre
        
        selectIndex = 1;
    }else if(type==1){
        //Nation
        selectIndex = 4;
    }
    [self.tabBarController setSelectedIndex:selectIndex];

    NSArray *lstview =  self.tabBarController.viewControllers;
    for (int i =0; i < lstview.count; i++) {
        NSLog(@"numberZZZZ %d",i);
        UIViewController *vc = [lstview objectAtIndex:i];
        if ([vc isKindOfClass:[MainViewController class]] && i==selectIndex) {
            MainViewController *zvc = (MainViewController *)vc;
            [zvc passedGenreIndex:index];
        }
    }
}
-(void)didSelectMenu:(NSInteger)index{
    [homeDelegate movePanelToOriginalPosition];

    if (index==3) {
       //HOme
        [UIView animateWithDuration:0.5f animations:^{
//            [self.historyView setHidden:YES];
            self.homeTitle.text = @"Home";
            self.historyView.frame = CGRectMake(viewSize.width, 64, viewSize.width, viewSize.height-64);
        } completion:^(BOOL finished){

        
        }];
    }else if(index==2){
        //Recent Viewed
        [UIView animateWithDuration:0.5f animations:^{
            //        self.view.frame = CGRectMake(viewSize.width, 0, viewSize.width, viewSize.height);
            self.homeTitle.text = @"Recent Viewed";
            self.historyView.dataType = 1;
            [self.historyView setHidden:NO];
            [self.view bringSubviewToFront:self.historyView];
            self.historyView.frame =CGRectMake(0, 64, viewSize.width, viewSize.height-64);
        } completion:^(BOOL finished){
            [self.historyView refreshHistoryData];

        }];
    }else if(index==1){
        [UIView animateWithDuration:0.5f animations:^{
            //        self.view.frame = CGRectMake(viewSize.width, 0, viewSize.width, viewSize.height);
            self.homeTitle.text = @"History";
            self.historyView.dataType = 2;
            [self.historyView setHidden:NO];
            [self.view bringSubviewToFront:self.historyView];
            self.historyView.frame =CGRectMake(0, 64, viewSize.width, viewSize.height-64);
        } completion:^(BOOL finished){
            [self.historyView refreshHistoryData];
        }];
    }else if(index==0){
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle: nil];
        LoginViewController *vc = (LoginViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:vc animated:YES completion:nil];

    }

}
//-(void)pressedTab:(id)sender{
//    UIButton *btn = sender;
//    if(tabIndex!=btn.tag){
//        CGFloat tabW = viewSize.width/3;
//        tabIndex = btn.tag;
//        [self.filmCollection reloadData];
////        [UIView animateWithDuration:0.3f animations:^{
////            tabHightLight.frame = CGRectMake(tabW*tabIndex+tabW/4, tabHeight-2, tabW/2, 2);
////        }];
//    }
//
//}
#pragma Mark - TouchNotification
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //    [[NSNotificationCenter defaultCenter] postNotificationName:KGModalGradientViewTapped object:nil];
    for (UITouch *aTouch in touches) {
        if (aTouch.tapCount >= 2) {
            // The view responds to the tap
            NSLog(@"HomemultiTouch");
        }else{
            NSLog(@"HomesingleTouch");
        }
    }
}
#pragma mark - call php api
-(void)callWebService{
    NSLog(@"call API");
    NSString *WS_URL = [NSString stringWithFormat:@"%@%@/%d",_urlAPI,_genre.key,paramPage];
    
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Background work
        NSString *receivedDataString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        NSError* error;
        
        NSDictionary* json =     [NSJSONSerialization JSONObjectWithData: [receivedDataString dataUsingEncoding:NSUTF8StringEncoding]
                                                                 options: NSJSONReadingMutableContainers
                                                                   error: &error];
        NSArray *wrapper= [NSJSONSerialization JSONObjectWithData:[receivedDataString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI
            
            
            //SearchResultItem *item = [[SearchResultItem alloc] initWithData:json];
            if(json){
                //[filmData removeAllObjects];
                NSMutableArray *arrs = [[NSMutableArray alloc] init];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSLog(@"json %d  %@",json.count,json);
                    NSLog(@"json array %d",wrapper.count);
                    for(int i = 0; i < wrapper.count;i++){
                        NSDictionary *avatars = [wrapper objectAtIndex:i];
                        NSLog(@"xxx : %@",avatars);
                        SearchResultItem *item= [[SearchResultItem alloc] initWithData:avatars];
                        [arrs addObject:item ];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_filmCollection reloadData];
                        
                        for(int i = 0; i < arrs.count;i++){
                            /*
                            [_listFilm performBatchUpdates:^{
                                [filmData addObject:[arrs objectAtIndex:i] ];
                                NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:filmData.count-1 inSection:0];
                                NSLog(@"insertRowAtIndex : %d",indexPath.row);
                                
                                [_listFilm insertItemsAtIndexPaths:@[indexPath]];
                            } completion:^(BOOL finished){
                                //[_listFilm reloadData];
                            }];
                             */
                        }
                        
                    });
                });
            }
            
        });
    });
    
    
}

@end
