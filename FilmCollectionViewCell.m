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
const NSString *API_URL_HOME_FILM = @"http://www.phimb.net/api/list/538c7f456122cca4d87bf6de9dd958b5/home/";
@interface FilmCollectionViewCell()
{
    CGFloat marginTop;
    NSMutableArray *filmData;
    CGFloat boxW;
    NSMutableData *receivedData;
    Genre *paramCat;
    NSInteger paramPage;
}
@property (nonatomic, strong) UIView *separatorView;



@property (nonatomic) CGFloat actualWidth;
@property (nonatomic) CGFloat actualHeight;

@end
@implementation FilmCollectionViewCell
@synthesize homeDeleage;

- (void)awakeFromNib {
    // Initialization code
    [self _init];
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        // portrait
        self.actualHeight = self.frame.size.height;
        self.actualWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
        boxW = self.actualWidth / 3 - 30/3;
    } else {
        self.actualHeight = self.frame.size.width;
        self.actualWidth = CGRectGetHeight([UIScreen mainScreen].bounds);
        boxW = self.actualWidth / 3 - 30/3;
        // landscape
    }
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
-(void)initFilmData{
    filmData = [[NSMutableArray alloc] init];
    paramPage = 1;
}

- (void)_init {
    
    //Init views
    self.separatorView = [[UIView alloc] init];
    //initHeader
    [self initFilmData];
    [self initHeader];
    [self initListFilmView];
    //Asign
    [self.contentView addSubview:self.separatorView];
    
    //Configure views
   
    
    self.separatorView.backgroundColor = [ColorSchemeHelper sharedSeparatorColor];
    
    //Configure for self
    UIColor *selectedColor = [ColorSchemeHelper sharedSelectedCellColor];
    UIImage *selectedImage = [ImageHelper imageWithColor:selectedColor andSize:CGSizeMake(1, 1)];
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:selectedImage];
    
    
    [self setDefaultFrameForSubviews];
    //[self forTesting];
}
-(void)initHeader{
    UIView *headerBg= [[UIView alloc] initWithFrame:CGRectMake(0, 0, _actualWidth, 30)];
    headerBg.backgroundColor = [UIColor grayColor];
    _titleCatFilm = [[UILabel alloc] init];
    _titleCatFilm.frame = CGRectMake(0, 0, _actualWidth-50, 30);
    _titleCatFilm.text =paramCat.title;
    [headerBg addSubview:_titleCatFilm];
    //viewmore
    _btnViewMore = [[UIButton alloc] init];
    _btnViewMore.frame = CGRectMake(_actualWidth-50, 0, 50, 30);
//    _btnViewMore.contentMode = UIViewContentModeScaleAspectFit;
    _btnViewMore.backgroundColor = [UIColor greenColor];
    UIImageView *moreView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_more_detail.png"]];
    moreView.frame = CGRectMake(10, 0, 30, 30);
    moreView.contentMode = UIViewContentModeScaleAspectFit;
    [_btnViewMore addSubview:moreView];
    
    [_btnViewMore addTarget:self
               action:@selector(pressViewMore:)
     forControlEvents:UIControlEventTouchUpInside];
    [headerBg addSubview:_btnViewMore];
    [headerBg setHidden:YES];
    [self.contentView addSubview:headerBg];
}
-(void)initListFilmView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(boxW  , boxW*3/2)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    
  
    [_listFilm registerClass:[ListFilmCell class] forCellWithReuseIdentifier:@"cvCell"];
    //    _listFilm.collectionViewLayout = flowLayout;
    //    _listFilm.frame = ;
    _listFilm.dataSource = self;
    _listFilm.delegate = self;
    
    _listFilm.backgroundColor = [UIColor whiteColor];
    
}

- (void)_initWithHeight:(CGFloat)height width:(CGFloat)width {
    self.actualHeight = height;
    self.actualWidth = width;
    boxW = self.actualWidth / 3 - 30/3;
}



- (void)setDefaultFrameForSubviews {
    

}
-(void)setContentView:(Genre *)param {
    paramCat = param;
    _titleCatFilm.text = paramCat.title;
    [filmData removeAllObjects];
    [_listFilm reloadData];
    [self callWebService];
}
-(void)setContentView:(Genre *)param withData:(NSArray *)data{
    paramCat = param;
    _titleCatFilm.text = paramCat.title;
    [filmData removeAllObjects];
    [_listFilm reloadData];

//    [filmData addObjectsFromArray:data];
//    for (int i = 0; i < data.count; i++) {
//        [filmData replaceObjectAtIndex:i withObject:[data objectAtIndex:i]];
//    }
    [self callWebService];

}
- (void)updateTitle:(NSString *)title {
    // self.titleLabel.text = [NSString stringWithFormat:@"%@",title];
//    self.titleCatFilm.text =title;
}
- (void)pressViewMore: (id)button{
    [self.homeDeleage pushListFilmController];
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
        
        cell = [[ListFilmCell alloc] initWithFrame:CGRectMake(0, 0, boxW, boxW*3/2 +40)];
    }
    cell.imgDelegate = self;
    
    [cell setContentView:[filmData objectAtIndex:indexPath.row] atIndex:indexPath.row];
    
        //    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    //
    //    [titleLabel setText:cellData];
    //    [cell.contentView addSubview:titleLabel];
    if(indexPath.row == filmData.count -1 && filmData.count%10==0){
        paramPage++;
        [self callWebService];
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
#pragma mark - call php api
-(void)callWebService{
    NSLog(@"call API");
    NSString *WS_URL = [NSString stringWithFormat:@"%@%@%d",API_URL_HOME_FILM,paramCat.key,paramPage];

    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:WS_URL]
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:60.0];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"API URLxxxx %@",WS_URL);
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
                        
                    });
                });
            }
            
        });
    });
    
    
}

@end
