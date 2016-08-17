//
//  ListFilmSingleViewController.m
//  SlideMenu
//
//  Created by Apple on 6/2/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import "ListFilmSingleViewController.h"
#import "ListFilmCell.h"
#import "PlayVideoViewController.h"
#import "ColorSchemeHelper.h"
#import "AppDelegate.h"
#import <RealReachability.h>
#define NUMBER_COLUMN 3
const NSString *API_URL_LIST_FILM_SINGLE = @"http://www.phimb.net/api/list/538c7f456122cca4d87bf6de9dd958b5/home/";
@interface ListFilmSingleViewController () <RequestImageDelegate>
{
    CGFloat viewWidth;
    CGFloat viewHeight;
    CGFloat marginTop;
    NSMutableArray *filmData;
    CGFloat boxW;
    NSMutableData *receivedData;
    NSInteger paramPage;
}
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIView *bgHeader;
@property (strong,nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (assign, nonatomic) ReachabilityStatus curStatus;
@end
@implementation ListFilmSingleViewController
@synthesize curStatus;
-(id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}
-(void)initFilmData{
    filmData = [[NSMutableArray alloc] init];
}
-(void)initRefreshControl{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.listFilm addSubview:self.refreshControl];
    self.listFilm.alwaysBounceVertical = YES;
}
-(void) initHeader{

    _bgHeader.backgroundColor = [ColorSchemeHelper sharedNationHeaderColor];
   
    _lbTitle.text = @"Single";
    _lbTitle.textAlignment = NSTextAlignmentCenter;
    _lbTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
    _lbTitle.textColor = [UIColor whiteColor];
}
-(void)initListFilmView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(boxW  , boxW*3/2 + 40)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    _listFilm.collectionViewLayout = flowLayout;
    [_listFilm registerClass:[ListFilmCell class] forCellWithReuseIdentifier:@"cvCell"];
    //    _listFilm.collectionViewLayout = flowLayout;
    //    _listFilm.frame = ;
    _listFilm.dataSource = self;
    _listFilm.delegate = self;
    _listFilm.alwaysBounceVertical = YES;
    _listFilm.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_listFilm];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    curStatus = RealStatusNotReachable;
    viewHeight = self.view.frame.size.height;
    viewWidth = self.view.frame.size.width;
    paramPage = 1;

    
    [self callWebService];
  
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        // portrait
        boxW =self.view.frame.size.width/NUMBER_COLUMN-30/NUMBER_COLUMN;
    } else {
        boxW =self.view.frame.size.height/NUMBER_COLUMN-30/NUMBER_COLUMN;
        // landscape
    }
    
    [self initFilmData];
    marginTop =  64;
    [self initHeader];
    [self initListFilmView];
    [self initRefreshControl];

    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    //
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicator.center = self.view.center;
    _activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:_activityIndicator];
    [_activityIndicator stopAnimating];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kRealReachabilityChangedNotification
                                               object:nil];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[SlideNavigationController sharedInstance].lastControlelr = 2;
    [self styleNavBar];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)styleNavBar {
    // 1. hide the existing nav bar
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    
//    // 2. create a new nav bar and style it
//    UINavigationBar *newNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64.0)];
//    [newNavBar setTintColor:[UIColor whiteColor]];
//    
//    // 3. add a new navigation item w/title to the new nav bar
//    UINavigationItem *newItem = [[UINavigationItem alloc] init];
//    newItem.title = @"Paths";
//    [newNavBar setItems:@[newItem]];
//    
//    // 4. add the nav bar to the main view
//    [self.view addSubview:newNavBar];
  
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - CollectionView
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Adjust cell size for orientation
    
    return CGSizeMake(boxW , boxW*3/2 + 40);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return filmData.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *cellIdentifier = @"cvCell";
    
    ListFilmCell *cell = (ListFilmCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if(cell==nil){
        
        cell = [[ListFilmCell alloc] initWithFrame:CGRectMake(0, 0, boxW, boxW*3)];
    }
    cell.imgDelegate = self;
    [cell setContentView:[filmData objectAtIndex:indexPath.row]  atIndex:indexPath.row single:YES];
    
    //    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    //
    //    [titleLabel setText:cellData];
    //    [cell.contentView addSubview:titleLabel];
    if(indexPath.row == filmData.count -1 && filmData.count%10==0){
        paramPage++;
        [self callWebService];
    }
    NSLog(@"numberOfITem %d",filmData.count);
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    [[SlideNavigationController sharedInstance] changedRightToList];
    if ( [((AppDelegate *)[[UIApplication sharedApplication]delegate]) canClick]) {
        SearchResultItem *item = [filmData objectAtIndex:indexPath.row];
        //    UIViewController *topVc =  [AppDelegate topMostController];
        //    UIView *view = [((AppDelegate *)[[UIApplication sharedApplication]delegate]).window  viewWithTag:99];
        [((AppDelegate *)[[UIApplication sharedApplication]delegate]) showPlayer:item inView:self.view];
    }



    
}
-(void)setImageAtIndex:(NSInteger)index image:(UIImage *)img{
    SearchResultItem *item = [filmData objectAtIndex:index];
    item.hasData = YES;
    item.thumbnail = img;
    [filmData replaceObjectAtIndex:index withObject:item];
    SearchResultItem *new = [filmData objectAtIndex:index];
    NSLog(@"xxxx %d",new.hasData);
}
- (void)refresh:(UIRefreshControl *)refreshControl {
    // Do your job, when done:
    [self.listFilm reloadData];
    
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

//- (void)reloadData
//{
//    // Reload table data
//    [self.listFilm reloadData];
//    
//    // End the refreshing
//    if (self.refreshControl) {
//        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"MMM d, h:mm a"];
//        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
//        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
//                                                                    forKey:NSForegroundColorAttributeName];
//        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
//        self.refreshControl.attributedTitle = attributedTitle;
//        
//        [self.refreshControl endRefreshing];
//    }
//}
#pragma mark - call php api
-(void)callWebService{
    NSLog(@"call API");
    NSString *ext= @"phim-bo/";
    NSString *WS_URL = [NSString stringWithFormat:@"%@%@%d",API_URL_LIST_FILM_SINGLE,ext,paramPage];
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
    NSLog(@"***** Succeeded! Received %dbytes of data",[receivedData length]);
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
               // [filmData removeAllObjects];
                NSMutableArray *arrs =[[NSMutableArray alloc] init];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSLog(@"json %d  %@",json.count,json);
                    NSLog(@"json array %d  ",wrapper.count);
                    for(int i = 0; i < wrapper.count;i++){
                        NSDictionary *avatars = [wrapper objectAtIndex:i];
                        NSLog(@"xxx : %@",avatars);
                        SearchResultItem *item= [[SearchResultItem alloc] initWithData:avatars];
                        //
                        [arrs addObject:item];

//                        [_listFilm performBatchUpdates:^{
//                            [filmData addObject:item ];
//                            NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:filmData.count-1 inSection:0];
//                            NSLog(@"insertRowAtIndex : %d  ",indexPath.row);
//
//                            [_listFilm insertItemsAtIndexPaths:@[indexPath]];
//                        } completion:^(BOOL finished){
//                            [_listFilm reloadData];
//                        }];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        for(int i = 0; i < arrs.count;i++){
                            
                            [_listFilm performBatchUpdates:^{
                                [filmData addObject:[arrs objectAtIndex:i] ];
                                NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:filmData.count-1 inSection:0];
                                NSLog(@"insertRowAtIndex : %d  ",indexPath.row);
                                [_listFilm insertItemsAtIndexPaths:@[indexPath]];
                            } completion:^(BOOL finished){
                                //[_listFilm reloadData];
                            }];
                        }
                        //
                        [_activityIndicator stopAnimating];
                    });
                });
            }
            
        });
    });
    
    
}
- (void)networkChanged:(NSNotification *)notification
{
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    if (status != curStatus) {
        curStatus = status;
        NSLog(@"currentStatus:%@",@(status));
        if (status == RealStatusViaWiFi || status == RealStatusViaWWAN) {
            [self callWebService];
            
        }
    }
}
@end