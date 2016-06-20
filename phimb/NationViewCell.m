//
//  NationViewCell.m
//  phimb
//
//  Created by becauseyoulive1989 on 4/25/16.
//  Copyright © 2016 com.haiphone. All rights reserved.
//

#import "NationViewCell.h"
#import "PhimbAPI.h"
#import "ColorSchemeHelper.h"
#import "FilmViewCell.h"
#import "SearchResultItem.h"
@interface NationViewCell() <UICollectionViewDataSource,UICollectionViewDelegate,NSURLConnectionDataDelegate>
{
    NSMutableArray *dataArray;
    NSMutableData *receivedData;
    NSMutableArray *filmData;
}
@property (strong, nonatomic) void (^complete)(NSString *json);
@end
@implementation NationViewCell 

- (void)awakeFromNib {
    // Initialization code
    filmData = [[NSMutableArray alloc] init];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 0);
    CGFloat itemSize = CGRectGetWidth([UIScreen mainScreen].bounds) /3;
    flowLayout.itemSize = CGSizeMake(self.frame.size.height*2/3  - 40, self.frame.size.height - 45) ;
    [self.clFilm registerNib:[UINib nibWithNibName:@"FilmViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"filmcell"];
    [self.clFilm setCollectionViewLayout:flowLayout];
    self.clFilm.delegate = self;
    self.clFilm.dataSource = self;
    self.clFilm.backgroundColor = [UIColor whiteColor];
    self.btnViewMore.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.clFilm.showsHorizontalScrollIndicator = NO;
    self.backgroundColor =  [ColorSchemeHelper sharedNationHeaderColor];
//
    [self.btnViewMore addTarget:self action:@selector(pressedViewMore:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setcontentView:(NSString *)header jsonData:(NSString *)json atIndex:(NSInteger)index{
    
    self.lbTitle.text = header;
    self.btnViewMore.tag = index;
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    [self pareJsonToData:data];
}
-(void)setcontentView:(NSString *)header nationCode:(NSString *)nationCode complete:(void (^)(NSString *))complete atIndex:(NSInteger)index{
    self.lbTitle.tag = index;
    self.lbTitle.text = header;
    [self callWebService:nationCode];
    self.complete = complete;
}
#pragma mark-
#pragma mark-collectionDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (dataArray) {
        return dataArray.count;
    }
    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FilmViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"filmcell" forIndexPath:indexPath];
    SearchResultItem *item = [dataArray objectAtIndex:indexPath.row];
//    cell.thumbnail.image  = item.thumbnail;
    [cell setContentView:item];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
-(void)pressedViewMore:(UIButton *)btn{
    [self.delegate pressedViewMore:btn.tag];
}

#pragma mark
-(void)callWebService:(NSString *)key{
    NSLog(@"call API");
    NSString *WS_URL = [NSString stringWithFormat:@"%@%@",API_URL_NATION_FILM,key];
    
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
    [self pareJsonToData:receivedData];
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
-(void)pareJsonToData:(NSData *)receiveString{
    NSLog(@"pareDAta");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Background work
        NSString *receivedDataString = [[NSString alloc] initWithData:receiveString encoding:NSUTF8StringEncoding];
        NSError* error;
        
        NSDictionary* json =     [NSJSONSerialization JSONObjectWithData: [receivedDataString dataUsingEncoding:NSUTF8StringEncoding]
                                                                 options: NSJSONReadingMutableContainers
                                                                   error: &error];
        self.complete(receivedDataString);
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
                        
                        dataArray = [[NSMutableArray alloc] initWithArray:arrs];
                        [self.clFilm reloadData];
                        
                    });
                });
            }
            
        });
    });
    
    
}
@end
