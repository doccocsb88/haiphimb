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
#define NUMBER_COLUMN 3
const NSString *API_URL_SERIES_FILM= @"http://www.phimb.net/api/list/538c7f456122cca4d87bf6de9dd958b5/cat/";
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

@end

@implementation SeriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.genre = [[Genre alloc] initWithTitle:@"Series" withKey:@"phim-bo"];
    [self initData];
    [self setUp];
    [self callWebservide:self.genre];

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
        boxW =self.view.frame.size.width/NUMBER_COLUMN-30/NUMBER_COLUMN;
    } else {
        boxW =self.view.frame.size.height/NUMBER_COLUMN-30/NUMBER_COLUMN;
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
    [flowLayout setItemSize:CGSizeMake(boxW  , boxW*3/2)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.clFilms.collectionViewLayout = flowLayout;
    [self.clFilms registerClass:[ListFilmCell class] forCellWithReuseIdentifier:@"filmcell"];
    self.clFilms.backgroundColor = [UIColor yellowColor];
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
                        
                    });
                });
            }
            
        });
    });
    
    
}

@end
