//
//  RelateFilmViewController.m
//  phimb
//
//  Created by Apple on 6/7/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import "RelateFilmViewController.h"
#import "ColorSchemeHelper.h"
const NSString *API_URL_RELATE_FILM = @"http://www.phimb.net/api/list/538c7f456122cca4d87bf6de9dd958b5/relate/";

@interface RelateFilmViewController ()
{
    NSMutableArray *filmData;
    NSMutableData *receivedData;
    NSInteger paramPage;
    NSString *paramOder;
    CGFloat viewWidth;
    CGFloat viewHeight;
    CGFloat leftMargin;
    CGFloat boxW;
}
@end

@implementation RelateFilmViewController
@synthesize  delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor  = [UIColor whiteColor];
    leftMargin = self.view.frame.size.width - viewWidth;
    viewHeight = self.view.frame.size.height - 64;
    boxW = viewWidth/3 - 30/3;
    paramOder = @"Not found";
    [self initFilmData];
    [self initHeader];
    [self initListFilm];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)initFilmData{
    paramPage = 1;
    filmData = [[NSMutableArray alloc] init];
//    for(int i = 0; i < 10; i ++){
//        [filmData addObject:@"aa"];
//    }

}
-(void)initHeader{
    UIView *bgHeader= [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - viewWidth, 0, viewWidth, 64) ];
    bgHeader.backgroundColor = [ColorSchemeHelper sharedNationHeaderColor];
    [self.view addSubview:bgHeader];
    UILabel *title= [[UILabel alloc] initWithFrame:CGRectMake(0, 20, viewWidth, 44)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"Phim lien quan";
    [bgHeader addSubview:title];
}
-(void)initListFilm{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(boxW  , boxW*3/2)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    _listRelatefilm = [[UICollectionView alloc] initWithFrame:CGRectMake(leftMargin, 64, viewWidth, viewHeight)  collectionViewLayout:flowLayout];
    _listRelatefilm.backgroundColor = [UIColor whiteColor];
    [_listRelatefilm registerClass:[ListFilmCell class] forCellWithReuseIdentifier:@"rlCell"];
    _listRelatefilm.delegate = self;
    _listRelatefilm.dataSource = self;
    [self.view addSubview:_listRelatefilm];
}
#pragma mark uicolelctionview delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return filmData.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"rlCell";

    ListFilmCell *cell = (ListFilmCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if(cell==nil){
        
        cell = [[ListFilmCell alloc] initWithFrame:CGRectMake(0, 0, boxW, boxW*3)];
    }
    cell.imgDelegate = self;
    [cell setContentView:[filmData objectAtIndex:indexPath.row] atIndex:indexPath.row];
    if (indexPath.row ==filmData.count-1 && filmData.count%10==0) {
        paramPage++;
        [self callWebService];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchResultItem *item= [filmData objectAtIndex:indexPath.row];
    [delegate playMovieWithData:item];
}
#pragma mark initviewcontrolelr
-(id)initWithWidth:(CGFloat)width{
    self = [super init];
    if(self){
        viewWidth = width;
        
    }
    return self;
}

-(void)loadRelateFilm:(NSString *)cate{
    if(![paramOder isEqualToString:cate]){
        paramPage = 1;
    paramOder = cate;
    [self callWebService];
    }

}
-(void)setImageAtIndex:(NSInteger)index image:(UIImage *)img{
    
    SearchResultItem *item = [filmData objectAtIndex:index];
    item.thumbnail = img;
    item.hasData = YES;
    [filmData replaceObjectAtIndex:index withObject:item];

}
#pragma mark - call php api
-(void)callWebService{
    NSLog(@"call API");
    
    NSString *WS_URL = [NSString stringWithFormat:@"%@%@/%d",API_URL_RELATE_FILM,paramOder,paramPage*10];
    //    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:WS_URL]];
    //
    //    [request setHTTPMethod:@"GET"];
    //    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:WS_URL]
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:60.0];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"API URL Relate : %@",WS_URL);
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
    NSLog(@"***** Succeeded! Received %ld bytes of data",[receivedData length]);
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
                            
                            [_listRelatefilm performBatchUpdates:^{
                                [filmData addObject:[arrs objectAtIndex:i] ];
                                NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:filmData.count-1 inSection:0];
                                NSLog(@"insertRowAtIndex : %d",indexPath.row);
                                
                                [_listRelatefilm insertItemsAtIndexPaths:@[indexPath]];
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
