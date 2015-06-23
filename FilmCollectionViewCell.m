//
//  FilmCollectionViewCell.m
//  SlideMenu
//
//  Created by Apple on 5/29/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import "FilmCollectionViewCell.h"
#import "ColorSchemeHelper.h"
#import "ImageHelper.h"
#import "ListFilmCell.h"
#import "PlayVideoViewController.h"
#import "SearchResultViewCell.h"

#define SEPARATOR_HEIGHT 1
 NSString * const API_URL_HOME_FILM = @"http://www.phimb.net/api/list/538c7f456122cca4d87bf6de9dd958b5/home/";
 NSString * const API_URL_NATION2_FILM = @"http://www.phimb.net/api/list/538c7f456122cca4d87bf6de9dd958b5/country/";
 NSString * const API_URL_SERIES_FILM = @"http://www.phimb.net/api/list/538c7f456122cca4d87bf6de9dd958b5/catx/";

@interface FilmCollectionViewCell()
{
    CGFloat headerH;
    CGFloat marginTop;
    NSMutableArray *filmData;
    CGFloat boxW;
    NSMutableData *receivedData;
    Genre *paramCat;
    NSInteger paramPage;
    NSInteger indexView;
}
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic,strong) NSString *urlAPI ;


@property (nonatomic) CGFloat actualWidth;
@property (nonatomic) CGFloat actualHeight;

@end
@implementation FilmCollectionViewCell
@synthesize homeDeleage;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height width:(CGFloat)width  {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//         Initialization code
        [self _initWithHeight:height width:width];
    }
    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height width:(CGFloat)width withCate:(NSString *)cat{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //         Initialization code
        [self _initWithHeight:height width:width];
        //paramCat = cat;
        
    }
    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height width:(CGFloat)width withGenre:(Genre *)cat{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //         Initialization code
        [self _initWithHeight:height width:width];
        paramCat = cat;
        
    }
    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height width:(CGFloat)width withGenre:(Genre *)cat view:(int)_indexView{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //         Initialization code
        indexView = _indexView;
        [self _initWithHeight:height width:width];
        paramCat = cat;
        
    }
    return self;
}
-(void)initFilmData{
    filmData = [[NSMutableArray alloc] init];
    paramPage = 1;
}

- (void)_init {
    
    //Init views
    if(indexView==1){
        _urlAPI = API_URL_HOME_FILM;
    }else if(indexView==2){
        _urlAPI = [NSString stringWithFormat:API_URL_NATION2_FILM];

    }else if(indexView==3){
        _urlAPI = [NSString stringWithFormat:API_URL_SERIES_FILM];
    }
    self.separatorView = [[UIView alloc] init];
//    [self initHeader];
    [self initFilmData];
    [self initListFilmView];
    //Asign
    [self.contentView addSubview:self.separatorView];
    
    //Configure views
   
    
    self.separatorView.backgroundColor = [ColorSchemeHelper sharedSeparatorColor];
    
    //Configure for self
//    UIColor *selectedColor = [ColorSchemeHelper sharedSelectedCellColor];
//    UIImage *selectedImage = [ImageHelper imageWithColor:selectedColor andSize:CGSizeMake(1, 1)];
//    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:selectedImage];
    
    
    [self setDefaultFrameForSubviews];
    if(indexView==2){
        [self initHeader];
    }

    //[self forTesting];
}
-(void)initHeader{
    UIView *headerBg= [[UIView alloc] initWithFrame:CGRectMake(0, 0, _actualWidth, 30)];
    headerBg.backgroundColor = [ColorSchemeHelper sharedNationHeaderColor];
    _titleCatFilm = [[UILabel alloc] init];
    _titleCatFilm.frame = CGRectMake(5, 0, _actualWidth-55, 30);
    _titleCatFilm.textColor = [UIColor whiteColor];
    _titleCatFilm.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0];
    _titleCatFilm.text =paramCat.title;
    [headerBg addSubview:_titleCatFilm];
    //viewmore
    _btnViewMore = [[UIButton alloc] init];
    _btnViewMore.frame = CGRectMake(_actualWidth-50, 0, 50, 30);
//    _btnViewMore.contentMode = UIViewContentModeScaleAspectFit;
    _btnViewMore.backgroundColor = [ColorSchemeHelper sharedNationHeaderColor];
    UIImageView *moreView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_more_detail.png"]];
    moreView.frame = CGRectMake(10, 0, 30, 30);
    moreView.contentMode = UIViewContentModeScaleAspectFit;
    [_btnViewMore addSubview:moreView];
    
    [_btnViewMore addTarget:self
               action:@selector(pressViewMore:)
     forControlEvents:UIControlEventTouchUpInside];
    [headerBg addSubview:_btnViewMore];
    [headerBg setHidden:NO];
    [self.contentView addSubview:headerBg];
}
-(void)initListFilmView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(boxW  , boxW*3/2)];
    if (indexView==1){
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    }else if (indexView==2){
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

    }
    [flowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    _listFilm = [[UICollectionView alloc] initWithFrame:CGRectMake(0, headerH, _actualWidth, _actualHeight - 30) collectionViewLayout:flowLayout];
    [_listFilm registerClass:[ListFilmCell class] forCellWithReuseIdentifier:@"cvCell"];
    //    _listFilm.collectionViewLayout = flowLayout;
    //    _listFilm.frame = ;
    _listFilm.dataSource = self;
    _listFilm.delegate = self;
    
    _listFilm.backgroundColor = [UIColor whiteColor];
    [self addSubview:_listFilm];
      if (indexView==1){
          [self initRefreshControl];
      }
}
-(void)initRefreshControl{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor whiteColor];
    //    self.refreshControl.tintColor = [UIColor whiteColor];
    refreshControl.tintColor = [UIColor blackColor];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.listFilm addSubview:refreshControl];
    self.listFilm.alwaysBounceVertical = YES;
}


- (void)_initWithHeight:(CGFloat)height width:(CGFloat)width {
    self.actualHeight = height;
    self.actualWidth = width;
    if(indexView==1){
        headerH = 0;

    }else {
        headerH = 30;

    }
    boxW = self.actualWidth / 3 - 30/3;
    [self _init];
}



- (void)setDefaultFrameForSubviews {
    

}
-(void)setContentView:(Genre *)param {
    paramCat = param;
    _titleCatFilm.text = paramCat.title;
    [self getAPIURL];
    [filmData removeAllObjects];
    [_listFilm reloadData];
    [self callWebService];
}
-(void)setContentView:(Genre *)param indexView:(NSInteger)index{
    indexView = index;
    paramCat = param;
    //_titleCatFilm.text = paramCat.title;

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        [self getAPIURL];
        [filmData removeAllObjects];
        [_listFilm reloadData];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
            [self callWebService];

            
        });
    });
}
-(void)getAPIURL{
    if(indexView==1){
        _urlAPI = [NSString stringWithFormat:API_URL_HOME_FILM];
    }else if(indexView==2){
        _urlAPI = [NSString stringWithFormat:API_URL_NATION2_FILM];
        
    }else if(indexView==3){
        _urlAPI = [NSString stringWithFormat:API_URL_SERIES_FILM];
    }
}
-(void)setContentView:(Genre *)param withData:(NSArray *)data{


    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread

        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
            paramCat = param;
            _titleCatFilm.text = paramCat.title;
            //    [filmData removeAllObjects];
//            [filmData removeAllObjects];
            filmData  = [[NSMutableArray alloc] initWithArray:data];
            [_listFilm reloadData];

        });
    });

}
- (void)updateTitle:(NSString *)title {
    // self.titleLabel.text = [NSString stringWithFormat:@"%@",title];
//    self.titleCatFilm.text =title;
}
- (void)pressViewMore: (id)button{
    
    [self.homeDeleage pushListFilmController:paramCat];
    NSLog(@"openViewDetail");
}
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
        
        cell = [[ListFilmCell alloc] initWithFrame:CGRectMake(0, headerH, boxW, boxW*3/2 +40)];
    }
    cell.imgDelegate = self;
    
    [cell setContentView:[filmData objectAtIndex:indexPath.row] atIndex:indexPath.row];
    
        //    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    //
    //    [titleLabel setText:cellData];
    //    [cell.contentView addSubview:titleLabel];
    if(indexPath.row == filmData.count -1 && filmData.count%10==0){
        if(indexView==1 || indexView ==3){
            paramPage++;
            [self callWebService];
        }
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    [[SlideNavigationController sharedInstance] changedRightToList];
    SearchResultItem *item = [filmData objectAtIndex:indexPath.row];
//    PlayVideoViewController *vc= [[PlayVideoViewController alloc] init];
//    [vc prepareFilmData:item];
//    //    [self.navigationController pushViewController:vc animated:YES];
//    NSLog(@"initFilmInfo %d %@ %@ %@ ",item._id,item.name,item.img,item.imglanscape);
    [homeDeleage presentPlayMovieController:item];
    NSLog(@"didselect--->3");

    
}
-(void)didSelectItemAtPoint:(CGPoint)point{
    CGPoint curPos = _listFilm.contentOffset;
    CGPoint actualPos = CGPointMake(curPos.x+point.x, curPos.y+point.y);
    int row = actualPos.y/(boxW*3/2 +40);
    int col = actualPos.x/boxW;
    int item = row*3 + col;
    NSLog(@"didselect--->2 item %d",item);

    [self collectionView:_listFilm didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]];

}
-(void)setImageAtIndex:(NSInteger)index image:(UIImage *)img{
    if(index < filmData.count){
    SearchResultItem *item = [filmData objectAtIndex:index];
    item.thumbnail = img;
    item.hasData = YES;
    [filmData replaceObjectAtIndex:index withObject:item];
    SearchResultItem *new = [filmData objectAtIndex:index];
    NSLog(@"setContentForFilmCell %d : %d",index,new.hasData);
    }
}
- (void)refresh:(UIRefreshControl *)refreshControl {
    // Do your job, when done:
    [self.listFilm reloadData];
    
    // End the refreshing
    if (refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor blackColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        refreshControl.attributedTitle = attributedTitle;
        
        [refreshControl endRefreshing];
    }
}

#pragma mark - call php api
-(void)callWebService{
    NSLog(@"call API");
    if (indexView==2 || indexView==3) {
        paramCat.key= [[NSString alloc] initWithFormat:@"%@/",paramCat.key];
    }
    NSString *WS_URL = [NSString stringWithFormat:@"%@%@%d",_urlAPI,paramCat.key,paramPage];

    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:WS_URL]
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:60.0];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"API URLHomexx %@",WS_URL);
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
                            
                            [_listFilm performBatchUpdates:^{
                                [filmData addObject:[arrs objectAtIndex:i] ];
                                NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:filmData.count-1 inSection:0];
                                NSLog(@"insertRowAtIndex : %d",indexPath.row);
                                
                                [_listFilm insertItemsAtIndexPaths:@[indexPath]];
                            } completion:^(BOOL finished){
                                //[_listFilm reloadData];
                            }];
                        }
                      
                            [homeDeleage loadThumbnailDidFetch:filmData forCate:paramCat.key];

                       
                    });
                });
            }
            
        });
    });
    
    
}

@end
