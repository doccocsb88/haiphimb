//
//  NationViewController.m
//  phimb
//
//  Created by Apple on 6/16/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//
#import "ListFilmSingleViewController.h"
#import "NationViewController.h"
#import "Genre.h"
#import "ColorSchemeHelper.h"
#import "Reachability.h"
#import "MainPlayMoViewController.h"
#define NUMBER_COLUMN 3
#define GENRE_TAB  40
#define NATION_TAB 44


@interface NationViewController ()
{
    NSArray *nationDatas;
    NSMutableArray *allnationData;
    CGFloat boxW;
    NSMutableData *receivedData;
    CGSize viewSize;
    CGFloat     marginTop ;
    NSInteger paramPage;
}
@property (nonatomic,strong) UIRefreshControl *refreshControl;
@property (nonatomic,strong) UIActivityIndicatorView *indicator;
@property (nonatomic,strong)     UILabel *lbTitleView ;
@property (nonatomic,strong) Genre *genre;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic ,strong) NSString *urlAPI;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic,assign) NSInteger genreIndex;
@property (strong,nonatomic) NationDetailViewController *nationDetail;
@end

@implementation NationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDatas];
    [self initViews];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.playvideoController!=nil && self.playvideoController.isFullScreen==NO) {
        [self.playvideoController removeView];
        [self.playvideoController.view removeFromSuperview];
        self.playvideoController=nil;
        
    }


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
#pragma mark - init data
-(void)initDatas{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if (![language isEqualToString:@"vi"]) {
        nationDatas = @[
                        [Genre itemWithTitle:@"Hong Kong Movies" withKey:@"hong-kong"],
                        [Genre itemWithTitle:@"Korea Movies" withKey:@"han-quoc"],
                        [Genre itemWithTitle:@"Viet Nam Movies" withKey:@"viet-nam"],
                        [Genre itemWithTitle:@"China Movies" withKey:@"trung-quoc"],
                        [Genre itemWithTitle:@"US-UK Movies" withKey:@"my-chau-au"],
                        [Genre itemWithTitle:@"Taiwan Movies" withKey:@"dai-loan"],
                        [Genre itemWithTitle:@"Thailand Movies" withKey:@"thai-lan"],
                        [Genre itemWithTitle:@"Japan Movies" withKey:@"nhat"],
                        [Genre itemWithTitle:@"Philippines Movies" withKey:@"philippines"]
                        ];
    }else{
    nationDatas = @[
                    [Genre itemWithTitle:@"Phim Hồng Kong" withKey:@"hong-kong"],
                    [Genre itemWithTitle:@"Phim Hàn Quốc" withKey:@"han-quoc"],
                    [Genre itemWithTitle:@"Phim Việt Nam" withKey:@"viet-nam"],
                    [Genre itemWithTitle:@"Phim Trung Quốc" withKey:@"trung-quoc"],
                    [Genre itemWithTitle:@"Phim Mỹ - Châu Âu" withKey:@"my-chau-au"],
                    [Genre itemWithTitle:@"Phim Đài Loan" withKey:@"dai-loan"],
                    [Genre itemWithTitle:@"Phim Thái Lan" withKey:@"thai-lan"],
                    [Genre itemWithTitle:@"Phim Nhật" withKey:@"nhat"],
                    [Genre itemWithTitle:@"Phim Philippines" withKey:@"philippines"]
                    ];
    }
    allnationData = [[NSMutableArray alloc] init];
//    for (int i = 0;i< nationDatas.count; i++) {
//        [allnationData addObject:@""];
//    }
}
#pragma mark - init views
-(void)initViews{
    [self initParams];
    [self initHeader];
    [self initTable];

}
-(void)initParams{
    paramPage = 1;
    _genreIndex = 0;
    _genre = [nationDatas objectAtIndex:_genreIndex];
    
    viewSize = self.view.frame.size;
    boxW =self.view.frame.size.width/NUMBER_COLUMN-30/NUMBER_COLUMN;
    marginTop =  64;
    
}
-(void)initHeader{
    UIView *bgHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, 64)];

        bgHeader.backgroundColor = [ColorSchemeHelper sharedNationHeaderColor];
        
    
    [self.view addSubview:bgHeader];
    
    _lbTitleView = [[UILabel alloc] initWithFrame:CGRectMake(50, 20+8, viewSize.width-100, 30)];
    [self.view addSubview:_lbTitleView];
    _lbTitleView.text = @"Nation";
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
-(void)initTable{
    self.nationfilms = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+1, viewSize.width, viewSize.height-64)];
    self.nationfilms.delegate = self;
    self.nationfilms.dataSource = self;
    [self.view addSubview:self.nationfilms];
}
#pragma mark table delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return nationDatas.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return boxW*3/2 + 70;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"nation";
    FilmCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    Genre *key = [nationDatas objectAtIndex:indexPath.row];

    if (cell == nil) {
        cell = [[FilmCollectionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier height:boxW*3/2 + 70  width:self.view.frame.size.width withGenre:key view:2];
        cell.homeDeleage = self;
        
    }
    cell.homeDeleage = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor redColor];
    NSLog(@"*****------>%d",allnationData.count);
    if (indexPath.row< allnationData.count) {
       
    if ([allnationData objectAtIndex:indexPath.row] ==nil) {
        [cell setContentView:key];

    }else{
        NSLog(@"*****%@->%d",key.key,indexPath.row);
        NSArray *data =[allnationData objectAtIndex:indexPath.row];
        [cell setContentView:key withData:data];
    }
    }else{
        [cell setContentView:key];

    }
    return cell;


}
#pragma mark HomeDelegate

-(void)loadThumbnailDidFetch:(NSArray *)data forCate:(NSString *)cate{
    //    dispatch_m
//    dispatch_async(dispatch_get_main_queue(), ^(void){
//        //Run UI Updates
//        NSInteger index = [self findIndexNation:cate];
//        if (index>=allnationData.count) {
//        
//            [allnationData addObject:data];
//        }
//        
//    });
   
}
-(NSInteger)findIndexNation:(NSString*)cate{
    for (int i = 0; nationDatas.count; i++) {
        Genre *genre = [nationDatas objectAtIndex:i];
        if ([genre.key isEqualToString:cate]) {
            return i;
        }
    }
    return -1;

}
-(void)presentPlayMovieController:(SearchResultItem *)item{
    if(self.playvideoController==nil)
    {
        [self showSecondController:item];
    }
    else
    {
        [self.playvideoController removeView];
        [self.playvideoController.view removeFromSuperview];
        self.playvideoController=nil;
        
        [self showSecondController:item];
        
    }
}
-(void)presentPlayerFromNation:(SearchResultItem *)item{
    [self presentPlayMovieController:item];
}
-(void)closePlayerFromNation{
    if (self.playvideoController!=nil && self.playvideoController.isFullScreen==NO) {
        [self.playvideoController removeView];
        [self.playvideoController.view removeFromSuperview];
        self.playvideoController=nil;
        
    }
}
#pragma mark -
#pragma mark -Important Methods

-(void)showSecondController:(SearchResultItem*)item
{
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
    
    self.playvideoController = [[PlayVideoViewController alloc] initWithInfo:item];
    //initial frame
    self.playvideoController.view.frame=CGRectMake(self.view.frame.size.width-50, self.view.frame.size.height-50, self.view.frame.size.width, self.view.frame.size.height);
    self.playvideoController.initialFirstViewFrame=self.view.frame;
    
    
    self.playvideoController.view.alpha=0;
    self.playvideoController.view.transform=CGAffineTransformMakeScale(0.2, 0.2);
    
    
    [self.view addSubview:self.playvideoController.view];
    self.playvideoController.onView=self.view;
    
    [UIView animateWithDuration:0.9f animations:^{
        self.playvideoController.view.transform=CGAffineTransformMakeScale(1.0, 1.0);
        self.playvideoController.view.alpha=1;
        
        self.playvideoController.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished){
        [self.playvideoController prepareFilmData:item];
    }];
    
}
-(void)pushListFilmController:(Genre *)genre{
    _genre = genre;
    _lbTitleView.text = _genre.title;
    if(self.nationDetail==nil){
        self.nationDetail= [[NationDetailViewController alloc] initWithGenre:_genre];
//         self.nationDetail.da
        _nationDetail.delegate = self;
        [self.nationDetail.view setFrame:CGRectMake(viewSize.width, 64, viewSize.width, viewSize.height)];
        [self.view addSubview:self.nationDetail.view];
    }
 
    [UIView animateWithDuration:0.5f animations:^{
        [self.nationfilms setAlpha:0.f];
        [self.nationDetail.view.layer removeAllAnimations];
        [self.nationDetail.view setFrame:CGRectMake(0, 64, viewSize.width, viewSize.height)];
    } completion:^(BOOL finished){
//        self.view
    
    }];

}
#pragma Mark
-(void)btnMovePanelRight:(id)sender {
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
-(void)setDelegate:(id<CenterHolderDelegate>)delegate{
    _delegate = delegate;
}
-(void)setLeftButtonTag:(int)tag{
    _leftButton.tag =tag;
}
-(void)setRightButtonTag:(int)tag{
    _rightButton.tag =tag;
}
-(void)genreSelected:(Genre *)genre{
    [self btnMovePanelLeft:nil];
    if (![_genre.key isEqualToString:genre.key]) {
        _genre = genre;
        _lbTitleView.text = _genre.title;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self pushListFilmController:genre];

            [self resetListFilmView];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self callWebService];
            });
        });
        
    }    
}
-(void)resetListFilmView{
    paramPage = 1;
    [self.nationDetail reloadData:_genre];
//    [na removeAllObjects];
//    [_listFilm reloadData];
}
-(void)loadListFilm:(NSInteger)index{
    Genre *genre = [nationDatas objectAtIndex:index];
    [self genreSelected:genre];
}
-(void)setImageAtIndex:(NSInteger)index image:(UIImage *)img{
}
-(void)callWebService{
}
@end
