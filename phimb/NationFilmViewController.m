//
//  NationFilmViewController.m
//  phimb
//
//  Created by becauseyoulive1989 on 4/25/16.
//  Copyright © 2016 com.haiphone. All rights reserved.
//

#import "NationFilmViewController.h"
#import "Animal.h"
#import "PlayVideoViewController.h"
#import "ColorSchemeHelper.h"
#import "Reachability.h"
#import "MainPlayMoViewController.h"
#import "NationViewCell.h"
#import "FilmViewController.h"
#import "AppDelegate.h"
#define NUMBER_COLUMN 3
#define GENRE_TAB  40
#define NATION_TAB 44
const NSString *API_URL_GENRE_FILMz = @"http://www.phimb.net/api/list/538c7f456122cca4d87bf6de9dd958b5/catx/";
const NSString *API_URL_NATION_FILMz = @"http://www.phimb.net/api/list/538c7f456122cca4d87bf6de9dd958b5/country/";

@interface NationFilmViewController () <UITableViewDelegate,UITableViewDataSource,NationFilmCellDelegate,FilmViewDelegate>
{
    CGFloat marginTop;
    NSMutableArray *filmData;
    CGFloat boxW;
    NSMutableData *receivedData;
    CGSize viewSize;
    NSInteger paramPage;
    NSArray *nationDatas;
    NSArray *genreDatas;
    NSMutableDictionary *dataArray;
}
@property (weak, nonatomic) IBOutlet UIView *bgHeader;
@property (weak, nonatomic)  IBOutlet UITableView *tbFilm;
@property (nonatomic,strong) UIRefreshControl *refreshControl;
@property (nonatomic,strong) UIActivityIndicatorView *indicator;
@property (nonatomic,strong)     UILabel *lbTitleView ;
@property (nonatomic,strong) Genre *genre;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic ,strong) NSString *urlAPI;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic,assign) NSInteger genreIndex;
@property (strong, nonatomic) FilmViewController *filmViewController;
@end

@implementation NationFilmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    [self initFilmData];
    [self initParams];
    [self callWebService];
    [self setupNetwork];
    [self initHeader];
    [self initRefreshControl];
    [self initIndicator];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-
-(void)setupViews{
   
    [self.tbFilm registerNib:[UINib nibWithNibName:@"NationViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"nationcell"];
    self.tbFilm.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tbFilm];
    
}
-(void)initIndicator{
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.center = self.view.center;
    _indicator.frame = CGRectMake(0, 64, viewSize.width, viewSize.height);
    _indicator.backgroundColor = [UIColor whiteColor];
    _indicator.hidesWhenStopped = YES;
    //    [_indicator startAnimating];
    [self.view addSubview:_indicator];
}
#pragma mark - setup network
-(void)setupNetwork{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
    
}
/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    //    if (reachability == self.hostReachability)
    //    {
    //        [self configureTextField:self.remoteHostStatusField imageView:self.remoteHostImageView reachability:reachability];
    //        NetworkStatus netStatus = [reachability currentReachabilityStatus];
    //        BOOL connectionRequired = [reachability connectionRequired];
    //
    //        //self.summaryLabel.hidden = (netStatus != ReachableViaWWAN);
    //        NSString* baseLabelText = @"";
    //
    //        if (connectionRequired)
    //        {
    //            baseLabelText = NSLocalizedString(@"Cellular data network is available.\nInternet traffic will be routed through it after a connection is established.", @"Reachability text if a connection is required");
    //        }
    //        else
    //        {
    //            baseLabelText = NSLocalizedString(@"Cellular data network is active.\nInternet traffic will be routed through it.", @"Reachability text if a connection is not required");
    //        }
    //       // self.summaryLabel.text = baseLabelText;
    //    }
    //
    if (reachability == self.internetReachability)
    {
        //[self configureTextField:self.internetConnectionStatusField imageView:self.internetConnectionImageView reachability:reachability];
        [self configureNetworkView:reachability];
    }
    
    //    if (reachability == self.wifiReachability)
    //    {
    //        [self configureNetworkView:reachability];
    //
    ////        [self configureTextField:self.localWiFiConnectionStatusField imageView:self.localWiFiConnectionImageView reachability:reachability];
    //    }
}
- (void)configureNetworkView:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
    NSString* statusString = @"";
    NSLog(@"NetStatus%d",netStatus);
    switch (netStatus)
    {
        case NotReachable:        {
            statusString = NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
            //imageView.image = [UIImage imageNamed:@"stop-32.png"] ;
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
             */
            connectionRequired = NO;
            break;
        }
            
        case ReachableViaWWAN:        {
            statusString = NSLocalizedString(@"Reachable WWAN", @"");
            // imageView.image = [UIImage imageNamed:@"WWAN5.png"];
            break;
        }
        case ReachableViaWiFi:        {
            statusString= NSLocalizedString(@"Reachable WiFi", @"");
            // imageView.image = [UIImage imageNamed:@"Airport.png"];
            break;
        }
    }
    
    if (connectionRequired)
    {
        NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
        statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
    }
    if(netStatus== NotReachable){
        //        UIAlertView *alert  =[[UIAlertView alloc] initWithTitle:@"NetWork" message:statusString delegate:self cancelButtonTitle:@"Try" otherButtonTitles:@"Cancel ", nil ];
        //        [alert show];
        [self.view bringSubviewToFront:_indicator];
        [self.indicator setHidden:NO];
        [self.indicator startAnimating];
    }else{
        [self.indicator stopAnimating];
        
        if(filmData.count==0){
            [self callWebService];
        }else{
            [self.tbFilm reloadData];
        }
        
    }
    //textField.text= statusString;
}

-(void)initHeader{

        _bgHeader.backgroundColor = [ColorSchemeHelper sharedNationHeaderColor];
        

    
    _lbTitleView = [[UILabel alloc] initWithFrame:CGRectMake(50, 20+8, viewSize.width-100, 30)];
    [self.view addSubview:_lbTitleView];
    _lbTitleView.text = _genre.title;
    _lbTitleView.textColor = [UIColor whiteColor];
    _lbTitleView.textAlignment = NSTextAlignmentCenter;
    _lbTitleView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
    _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 50, 55)];
    _leftButton.tag = 1;
    UIImageView *leftMenu = [[UIImageView alloc] initWithFrame:CGRectMake(5,7, 30, 30)];
    leftMenu.contentMode =  UIViewContentModeScaleAspectFit;
    leftMenu.image = [UIImage imageNamed:@"left_menu.png"];
    [_leftButton addSubview:leftMenu];
    
    [_leftButton addTarget:self action:@selector(btnMovePanelRight:) forControlEvents:UIControlEventTouchUpInside];
    _leftButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:11.f];
    [self.view addSubview:_leftButton];
    
}
-(void)initRefreshControl{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tbFilm addSubview:self.refreshControl];
    self.tbFilm.alwaysBounceVertical = YES;
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    // Do your job, when done:
    [self.tbFilm reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}
#pragma mark Default System Code
-(id)init{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
    
}
-(id)initWithTag:(NSInteger)tag{
    self = [super init];
    if (self) {
        _indexTagView = tag;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)loadListFilm:(NSInteger)index{
    _genreIndex = index;
    if (_indexTagView == GENRE_TAB) {
        //        _urlAPI = [NSString stringWithFormat:@"%@",API_URL_GENRE_FILM];
        _genre = [genreDatas objectAtIndex:_genreIndex];
        
    }else if(_indexTagView == NATION_TAB){
        //        _urlAPI = [NSString stringWithFormat:@"%@",API_URL_NATION_FILM];
        _genre = [nationDatas objectAtIndex:_genreIndex];
    }
    
    _lbTitleView.text = _genre.title;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self resetListFilmView];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self callWebService];
        });
    });
    
}
-(void)resetListFilmView{
    paramPage = 1;
    [filmData removeAllObjects];
    [self.tbFilm reloadData];
}
#pragma mark -
#pragma mark Button Actions

-(IBAction)btnMovePanelRight:(id)sender {
    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
            [_delegate movePanelToOriginalPosition];
            break;
        }
            
        case 1: {
            [_delegate movePanelRight];
            break;
        }
            
        default:
            break;
    }
}

-(IBAction)btnMovePanelLeft:(id)sender {
    NSLog(@"PlayMovie:btnMovePanelLeft");
    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
            [_delegate movePanelToOriginalPosition];
            break;
        }
            
        case 1: {
            [_delegate movePanelLeft];
            break;
        }
            
        default:
            break;
    }
}



#pragma mark -
#pragma mark Delagate Method for capturing selected image

/*
 note: typically, you wouldn't create "duplicate" delagate methods, but we went with simplicity.
 doing it this way allowed us to show how to use the #define statement and the switch statement.
 */

- (void)imageSelected:(UIImage *)image withTitle:(NSString *)imageTitle withCreator:(NSString *)imageCreator
{
    // only change the main display if an animal/image was selected
    if (image)
    {
        //        self.mainImageView.image = image;
        //        self.imageTitle.text = [NSString stringWithFormat:@"%@", imageTitle];
        //        self.imageCreator.text = [NSString stringWithFormat:@"%@", imageCreator];
    }
}

- (void)animalSelected:(Genre *)animal
{
    // only change the main display if an animal/image was selected
    if (animal)
    {
        //[self showAnimalSelected:animal];
    }
}
-(void)genreSelected:(Genre *)genre{
    [self btnMovePanelLeft:nil];
    if (![_genre.key isEqualToString:genre.key]) {
        _genre = genre;
        _lbTitleView.text = _genre.title;
        [self.filmViewController resetListFilm:self.genre];
    }
    
    
}

-(void)initParams{
    dataArray = [[NSMutableDictionary alloc] init];
    paramPage = 1;
    _genreIndex = 0;
    if (_indexTagView == GENRE_TAB) {
        _urlAPI = [NSString stringWithFormat:@"%@",API_URL_GENRE_FILMz];
        _genre = [genreDatas objectAtIndex:_genreIndex];
        
    }else if(_indexTagView == NATION_TAB){
        _urlAPI = [NSString stringWithFormat:@"%@",API_URL_NATION_FILMz];
        _genre = [nationDatas objectAtIndex:_genreIndex];
    }else{
        
        
    }
    viewSize = self.view.frame.size;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        // portrait
        boxW =self.view.frame.size.width/NUMBER_COLUMN-30/NUMBER_COLUMN;

    } else {
        boxW =self.view.frame.size.height/NUMBER_COLUMN-30/NUMBER_COLUMN;

        // landscape
    }
    marginTop =  64;
    
}
-(void)initFilmData{
    filmData = [[NSMutableArray alloc] init];
    genreDatas = @[
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
    
    nationDatas = @[
                       [Genre itemWithTitle:@"Hong Kong Movies" withKey:@"hong-kong"],
                       [Genre itemWithTitle:@"Korea Movies" withKey:@"han-quoc"],
                       [Genre itemWithTitle:@"Viet Nam Movies" withKey:@"viet-nam"],
                    [Genre itemWithTitle:@"China Movies" withKey:@"trung-quoc"],
                       [Genre itemWithTitle:@"US-UK Movies" withKey:@"my-chau-au"],
                    [Genre itemWithTitle:@"Taiwan Movies" withKey:@"dai-loan"],
                    [Genre itemWithTitle:@"Thailan Movies" withKey:@"thai-lan"],
                    [Genre itemWithTitle:@"Japan Movies" withKey:@"nhat"],
                    [Genre itemWithTitle:@"Philippines Movies" withKey:@"philippines"]
                    ];
}

#pragma mark-
#pragma mark-tabledelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return boxW *3/2 + 30;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (nationDatas) {
        return nationDatas.count;

    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nationcell" forIndexPath:indexPath];
    cell.delegate = self;
    Genre *genre = [nationDatas objectAtIndex:indexPath.row];
    NSString *json = [dataArray objectForKey:[NSString stringWithFormat:@"nation%ld",indexPath.row]] ;
    if (json != nil) {
        [cell setcontentView:genre.title jsonData:json atIndex:indexPath.row];
    }else{
    [cell setcontentView:genre.title nationCode:genre.key complete:^(NSString *json) {
        [dataArray setObject:json forKey:[NSString stringWithFormat:@"nation%ld",indexPath.row]];
    } atIndex:indexPath.row];
    }
    return cell;
}
-(void)pressedViewMore:(NSInteger)index{
    if ( self.filmViewController == nil) {
        self.filmViewController= [[FilmViewController alloc] initWithGenreKey:[nationDatas objectAtIndex:index]];
        self.filmViewController.delegate = self;

        self.filmViewController.view.frame = CGRectMake(self.view.frame.size.width, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 50);
        [self.view addSubview: self.filmViewController.view];
        [UIView animateWithDuration:1.0 animations:^{
            self.filmViewController.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 50);
        }];
    }
}
-(void)pressedItemAtIndex:(SearchResultItem *)item{
    UIViewController *topVc =  [AppDelegate topMostController];
    if ([topVc isKindOfClass:[PlayVideoViewController class]]) {
        PlayVideoViewController *vc = (PlayVideoViewController*)topVc;
        [vc prepareFilmData:item];
        [vc scaleViewToOriginalSize];
    }else{
        PlayVideoViewController *vc = [[PlayVideoViewController alloc] initWithInfo:item];
        [vc prepareFilmData:item];
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        vc.view.backgroundColor = [UIColor clearColor];
        [self presentViewController:vc animated:YES completion:nil];
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
                        //                        [_listFilm reloadData];
                        
                        for(int i = 0; i < arrs.count;i++){
                            
                           
//                            [self.tbFilm beginUpdates];
//                            [filmData addObject:[arrs objectAtIndex:i] ];
//                            NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:filmData.count-1 inSection:0];
//                            NSLog(@"insertRowAtIndex : %d",indexPath.row);
//                            
//                            [self.tbFilm insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//
//                            [self.tbFilm endUpdates];
                        }
                        
                    });
                });
            }
            
        });
    });
    
    
}

@end
