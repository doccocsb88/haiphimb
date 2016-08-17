//
//  ListFilmViewController.m
//  SlideMenu
//
//  Created by Apple on 5/30/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import "ListFilmViewController.h"
#import "ListFilmCell.h"
#import "PlayVideoViewController.h"
#import "AppDelegate.h"
#define NUMBER_COLUMN 3
const NSString *API_URL_LIST_FILM = @"http://www.phimb.net/api/list/538c7f456122cca4d87bf6de9dd958b5/home/";
@interface ListFilmViewController ()
{
    CGFloat marginTop;
    NSMutableArray *filmData;
    CGFloat boxW;
    NSMutableData *receivedData;

}
@end

@implementation ListFilmViewController
-(id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}
-(void)initFilmData{
    filmData = [[NSMutableArray alloc] init];
}
-(void) initHeader{
    UILabel *title= [[UILabel alloc] initWithFrame:CGRectMake(0, marginTop, 100, 30)];
    title.text = @"film hot";
    [self.view addSubview:title];
    
}
-(void)initListFilmView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(boxW  , boxW*3/2)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];

    _listFilm = [[UICollectionView alloc] initWithFrame:CGRectMake(0, marginTop+30, self.view.frame.size.width, self.view.frame.size.height - marginTop - 30) collectionViewLayout:flowLayout];
    [_listFilm registerClass:[ListFilmCell class] forCellWithReuseIdentifier:@"cvCell"];
//    _listFilm.collectionViewLayout = flowLayout;
//    _listFilm.frame = ;
    _listFilm.dataSource = self;
    _listFilm.delegate = self;
    
    _listFilm.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_listFilm];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self callWebService];
    boxW =self.view.frame.size.width/NUMBER_COLUMN-30/NUMBER_COLUMN;
    [self initFilmData];
    marginTop =  64;
    [self initHeader];
    [self initListFilmView];

    self.view.backgroundColor = [UIColor redColor];
    NSLog(@"tabbarIndex %ld",self.tabBarController.selectedIndex);
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // [SlideNavigationController sharedInstance].lastControlelr = 2;
    [self styleNavBar];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)styleNavBar {
    // 1. hide the existing nav bar
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    // 2. create a new nav bar and style it
    UINavigationBar *newNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64.0)];
    [newNavBar setTintColor:[UIColor whiteColor]];
    
    // 3. add a new navigation item w/title to the new nav bar
    UINavigationItem *newItem = [[UINavigationItem alloc] init];
    newItem.title = @"Paths";
    [newNavBar setItems:@[newItem]];
    
    // 4. add the nav bar to the main view
    [self.view addSubview:newNavBar];
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
    [cell setContentView:[filmData objectAtIndex:indexPath.row] atIndex:indexPath.row];
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    
//    [titleLabel setText:cellData];
//    [cell.contentView addSubview:titleLabel];

    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [[SlideNavigationController sharedInstance] changedRightToList];
    if ( [((AppDelegate *)[[UIApplication sharedApplication]delegate]) canClick]) {

    SearchResultItem *item = [filmData objectAtIndex:indexPath.row];
    [((AppDelegate *)[[UIApplication sharedApplication]delegate]) showPlayer:item inView:self.view];

    }
}

#pragma mark - call php api
-(void)callWebService{
    NSLog(@"call API");
    NSString *ext= @"new/";
    NSString *WS_URL = [NSString stringWithFormat:@"%@%@",API_URL_LIST_FILM,ext];
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
                [filmData removeAllObjects];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSLog(@"json %ld  %@",json.count,json);
                    NSLog(@"json array %ld",wrapper.count);
                    for(int i = 0; i < wrapper.count;i++){
                        NSDictionary *avatars = [wrapper objectAtIndex:i];
                        NSLog(@"xxx : %@",avatars);
                        SearchResultItem *item= [[SearchResultItem alloc] initWithData:avatars];
                        [filmData addObject:item ];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_listFilm reloadData];
                    });
                });
            }
            
        });
    });
    
    
}

@end
