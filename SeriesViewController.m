//
//  SeriesViewController.m
//  phimb
//
//  Created by becauseyoulive1989 on 6/6/16.
//  Copyright © 2016 com.haiphone. All rights reserved.
//

#import "SeriesViewController.h"
#import "ListFilmCell.h"
#import "FilmViewCell.h"
#import "Genre.h"
#import "PhimbAPI.h"
#import "ColorSchemeHelper.h"
#import "PlayVideoViewController.h"
#import "AppDelegate.h"
#import <RealReachability.h>
#define NUMBER_COLUMN 3
const NSString *API_URL_SERIES_FILM= @"http://www.phimb.net/api/list/538c7f456122cca4d87bf6de9dd958b5/home/";
@interface SeriesViewController () <UICollectionViewDataSource, UICollectionViewDelegate,NSURLConnectionDataDelegate,RequestImageDelegate>
{
    NSMutableArray *dataArray;
    NSMutableData *receivedData;
    NSInteger paramPage;
    CGFloat boxW;
}
@property (weak, nonatomic) IBOutlet UICollectionView *clFilms;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (strong, nonatomic) Genre *genre;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (assign, nonatomic) ReachabilityStatus curStatus;
@end

@implementation SeriesViewController
@synthesize curStatus;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view.
    curStatus = RealStatusUnknown;
    self.genre = [[Genre alloc] initWithTitle:@"Series" withKey:@"phim-le"];
    [self initData];
    [self setUp];
    [self initRefreshControl];
    [self callWebservide:self.genre];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initData{
    dataArray = [[NSMutableArray alloc] init];
}
-(void)setUp{
    paramPage = 1;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        // portrait
        boxW =self.view.frame.size.width/NUMBER_COLUMN- 10;
    } else {
        boxW =self.view.frame.size.height/NUMBER_COLUMN-10;
        // landscape
    }
    //setupHeader
    _headerView.backgroundColor = [ColorSchemeHelper sharedNationHeaderColor];
    
    _lbTitle.text = @"Series";
    _lbTitle.textAlignment = NSTextAlignmentCenter;
    _lbTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
    _lbTitle.textColor = [UIColor whiteColor];
    //
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(boxW  , boxW*3/2 + 40)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    self.clFilms.collectionViewLayout = flowLayout;
    [self.clFilms registerClass:[ListFilmCell class] forCellWithReuseIdentifier:@"filmcell"];
    self.clFilms.backgroundColor = [UIColor whiteColor];
}
-(void)initRefreshControl{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.clFilms addSubview:self.refreshControl];
    //    self.tbFilm.alwaysBounceVertical = YES;
}
#pragma mark-
#pragma mark-
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (dataArray) {
        return dataArray.count;
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"filmcell";
    
    ListFilmCell *cell = (ListFilmCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if(cell==nil){
        
        cell = [[ListFilmCell alloc] initWithFrame:CGRectMake(0, 0, boxW, boxW*3)];
    }
    cell.imgDelegate = self;
    [cell setContentView:[dataArray objectAtIndex:indexPath.row]  atIndex:indexPath.row];
    
    //    UILabel *titleLabel = [[UILabel alloc]
    if(indexPath.row == dataArray.count -1 && dataArray.count%10==0){
        paramPage++;
        [self callWebservide:self.genre];
    }
  
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ( [((AppDelegate *)[[UIApplication sharedApplication]delegate]) canClick]) {

    SearchResultItem *item = [dataArray objectAtIndex:indexPath.item];
    [((AppDelegate *)[[UIApplication sharedApplication]delegate]) showPlayer:item inView:self.view];
    }

}
-(void)setImageAtIndex:(NSInteger)index image:(UIImage *)img{
    SearchResultItem *item = [dataArray objectAtIndex:index];
    item.hasData = YES;
    item.thumbnail = img;
    [dataArray replaceObjectAtIndex:index withObject:item];
    SearchResultItem *new = [dataArray objectAtIndex:index];
    NSLog(@"xxxx %d",new.hasData);
}

-(void)callWebservide:(Genre *)genre{
    NSLog(@"call API");
    NSString *WS_URL = [NSString stringWithFormat:@"%@%@/%d",API_URL_SERIES_FILM,_genre.key,paramPage];
    
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
                            
                            [self.clFilms performBatchUpdates:^{
                                [dataArray addObject:[arrs objectAtIndex:i] ];
                                NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:dataArray.count-1 inSection:0];
                                NSLog(@"insertRowAtIndex : %d",indexPath.row);
                                
                                [self.clFilms insertItemsAtIndexPaths:@[indexPath]];
                            } completion:^(BOOL finished){
                                //[_listFilm reloadData];
                            }];
                        }
                        [_activityIndicator stopAnimating];
                    });
                });
            }
            
        });
    });
    
    
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    // Do your job, when done:
    [self.clFilms reloadData];
    
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
- (void)networkChanged:(NSNotification *)notification
{
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    if (status != curStatus) {
        curStatus = status;
        NSLog(@"currentStatus:%@",@(status));
        if (status == RealStatusViaWiFi || status == RealStatusViaWWAN) {
            [self callWebservide:self.genre];
            
        }
    }
    
}
@end
