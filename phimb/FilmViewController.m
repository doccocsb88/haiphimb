//
//  FilmViewController.m
//  phimb
//
//  Created by becauseyoulive1989 on 4/25/16.
//  Copyright © 2016 com.haiphone. All rights reserved.
//

#import "FilmViewController.h"
#import "PlayVideoViewController.h"
#import "FilmViewCell.h"
#import "AppDelegate.h"
#import "PhimbAPI.h"
#import <RealReachability.h>
@interface FilmViewController () <UICollectionViewDataSource,UICollectionViewDelegate,NSURLConnectionDataDelegate>
{
    NSMutableArray *dataArray;
    NSMutableData *receivedData;
    NSInteger paramPage;

}
@property (strong, nonatomic) UICollectionView *clFilm;
@property (assign, nonatomic) ReachabilityStatus curStatus;
@end
@implementation FilmViewController
@synthesize curStatus;
-(instancetype)initWithGenreKey:(Genre *)genre{
    self = [super init];
    if (self) {
        curStatus = RealStatusUnknown;
        paramPage = 1;
        dataArray = [[NSMutableArray alloc] init];
        self.genre = genre;
        self.view.backgroundColor = [UIColor whiteColor];
        [self callWebservide:self.genre];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(networkChanged:)
                                                     name:kRealReachabilityChangedNotification
                                                   object:nil];
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self setupViews];
}
-(void)setupViews{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemSize = CGRectGetWidth([UIScreen mainScreen].bounds) /3 - 10;
    NSString *deviceString =[[UIDevice currentDevice] platformString];
    if ([deviceString containsString:@"iPad"]) {
        itemSize = CGRectGetWidth([UIScreen mainScreen].bounds) /8 - 10;
    }
    flow.itemSize = CGSizeMake(itemSize, itemSize *3/2 + 40);
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.clFilm = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 50) collectionViewLayout:flow];
    
    self.clFilm.delegate = self;
    self.clFilm.dataSource = self;
    self.clFilm.backgroundColor = [UIColor whiteColor];
    [self.clFilm registerNib:[UINib nibWithNibName:@"FilmViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"filmcell"];
     [self.view addSubview:self.clFilm];
}
#pragma mark-
#pragma mark-tableDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (dataArray) {
        return dataArray.count;
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FilmViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"filmcell" forIndexPath:indexPath];

    SearchResultItem *item = [dataArray objectAtIndex:indexPath.row];
    [cell setContentView: item];
    if (indexPath.row == dataArray.count - 1) {
        paramPage ++;
        [self callWebservide:self.genre];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchResultItem *item = [dataArray objectAtIndex:indexPath.row];
        [self.delegate pressedItemAtIndex:item];
    NSLog(@"didselect--->4");
}
-(void)resetListFilm:(Genre *)genre{
    self.genre = genre;
    paramPage = 1;
    [dataArray removeAllObjects];
    [self.clFilm reloadData];
    [self callWebservide:genre];
}
-(void)callWebservide:(Genre *)genre{
    NSLog(@"call API");
    NSString *WS_URL = [NSString stringWithFormat:@"%@%@/%d",API_URL_NATION_FILM,_genre.key,paramPage];
    
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
                            
                            [self.clFilm performBatchUpdates:^{
                                [dataArray addObject:[arrs objectAtIndex:i] ];
                                NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:dataArray.count-1 inSection:0];
                                NSLog(@"insertRowAtIndex : %d",indexPath.row);
                                
                                [self.clFilm insertItemsAtIndexPaths:@[indexPath]];
                            } completion:^(BOOL finished){
                                //[_listFilm reloadData];
                            }];
                        }
                        
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
            [self callWebservide:self.genre];
            
        }
    }
    
}
@end
