//
//  TabRelateView.m
//  SlideMenu
//
//  Created by Apple on 5/30/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import "TabRelateView.h"
#import "ListFilmCell.h"
#import "EpisodeViewCell.h"
#import "RecipeCollectionHeaderView.h"
#define RELATE_CELL_SIZE 30
@interface TabRelateView() <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *filmData;
    NSMutableArray *server2Data;
    CGFloat boxW;
    NSIndexPath *currentSelected;
    int curRow;
}
@property (strong, nonatomic) UILabel *lbServer1;
@property (strong, nonatomic) UILabel *lbServer2;
//@property (strong,nonatomic) NSMutableDictionary *episodeData;
@property (strong, nonatomic) UICollectionView *listphim1;
@property (strong, nonatomic) UICollectionView *listphim2;

@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@end

@implementation TabRelateView
@synthesize playvideoDelegate;
-(id)initWithData:(NSMutableDictionary *)dic frame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
//        _episodeData = dic;
        _viewWidth =frame.size.width;
        _viewHeight = frame.size.height;
        boxW = frame.size.width/3;
        self.backgroundColor = [UIColor whiteColor];
        [self initData];
        [self _init];
    }
    return self;

}
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _viewWidth =frame.size.width;
        _viewHeight = frame.size.height;
        boxW = frame.size.width/3;
//        self.backgroundColor = [UIColor purpleColor];
        [self initData];
        [self _init];
    }
    return self;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)_init{
    curRow = 0;
    currentSelected = nil;
    [self initRelateFilmCollection];
    [self initIndicator];
   
}
-(void)initData{
//_episodeData = [[NSMutableDictionary alloc] init];
    filmData = [[NSMutableArray alloc] init];
    server2Data = [[NSMutableArray alloc] init];
}
-(void)initIndicator{
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.frame = CGRectMake(0, 0, _viewHeight, _viewHeight);
    _indicator.center = CGPointMake(_viewWidth/2, _viewHeight/2);
    _indicator.backgroundColor = [UIColor clearColor];
    _indicator.hidesWhenStopped = YES;
    [_indicator startAnimating];
    [self addSubview:_indicator];
}
-(void)initRelateFilmCollection{
    _tbServes = [[UITableView alloc] initWithFrame:CGRectMake(70, 5, _viewWidth - 80, _viewHeight - 10)];
    _tbServes.delegate = self;
    _tbServes.dataSource = self;
    [_tbServes registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tapphimcell"];
    _tbServes.alwaysBounceVertical = YES;
    _tbServes.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tbServes.separatorStyle = UITableViewRowActionStyleDefault;
    _lbServer1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 60, 40)];
    _lbServer1.font = [UIFont systemFontOfSize:12];
    _lbServer2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5 + 40, 60, 40)];
    _lbServer2.font = [UIFont systemFontOfSize:12];
    _lbServer1.text = @"Server 1";
    _lbServer2.text = @"Server 2";
    _lbServer1.hidden = YES;
    _lbServer2.hidden = YES;
    [self addSubview:_lbServer1];
    [self addSubview:_lbServer2];
    [self addSubview:_tbServes];
  
}
#pragma mark-

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numberOfSection = 0;
    if (filmData && filmData.count > 0) {
        numberOfSection++;
    }
    if (server2Data && server2Data.count > 0) {
        numberOfSection++;
    }
    if (numberOfSection == 1) {
        _lbServer1.hidden = NO;
    }
    if (numberOfSection == 2) {
        _lbServer1.hidden = NO;
        _lbServer2.hidden = NO;
    }
    return numberOfSection;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tapphimcell" forIndexPath:indexPath];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(RELATE_CELL_SIZE   , RELATE_CELL_SIZE)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
//    flowLayout.headerReferenceSize = CGSizeMake(_viewWidth, 20);
    if (indexPath.row == 0) {
        if (_listphim1) {
            [_listphim1 removeFromSuperview];
            _listphim1 = nil;
        }
        if (_listphim1 == nil) {
            _listphim1 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth - 70  , 40) collectionViewLayout:flowLayout];
            [_listphim1 registerNib:[UINib nibWithNibName:@"EpisodeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"episodeViewCell"];
            [_listphim1 registerNib:[UINib nibWithNibName:@"CollectionHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeaderView"];
            //    _listRelateFilm.collectionViewLayout = flowLayout;
            //    _listFilm.frame = ;
            _listphim1.tag = indexPath.row;
            _listphim1.dataSource = self;
            _listphim1.delegate = self;
            _listphim1.backgroundColor = [UIColor clearColor];
            [_listphim1 setShowsHorizontalScrollIndicator:NO];
            [cell.contentView addSubview:_listphim1];
        }
       

    }else if(indexPath.row == 1){
        if (_listphim2) {
            [_listphim2 removeFromSuperview];
            _listphim2 = nil;
        }
        if (_listphim2 == nil) {
            _listphim2 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth - 70  , 40) collectionViewLayout:flowLayout];
            [_listphim2 registerNib:[UINib nibWithNibName:@"EpisodeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"episodeViewCell"];
            [_listphim2 registerNib:[UINib nibWithNibName:@"CollectionHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeaderView"];
            //    _listRelateFilm.collectionViewLayout = flowLayout;
            //    _listFilm.frame = ;
            _listphim2.tag = indexPath.row;
            _listphim2.dataSource = self;
            _listphim2.delegate = self;
            _listphim2.backgroundColor = [UIColor clearColor];
            [_listphim2 setShowsHorizontalScrollIndicator:NO];
            [cell.contentView addSubview:_listphim2];
        }
    }
   
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    /*int count = 0;
    NSArray *allKey = [_episodeData allKeys];
    NSInteger leng = _episodeData.count;
    for(int i = 0; i < leng;i++){
        NSString *key = [allKey objectAtIndex:i];
        NSLog(@"xxkey : %@ - %@",key,[_episodeData objectForKey:key]);

        if([[_episodeData objectForKey:key] isKindOfClass:[NSArray class]]){
            count++;
        }else{
            NSString *strLink = [_episodeData objectForKey:key];
            [_episodeData removeObjectForKey:key];

            strLink = [strLink stringByReplacingOccurrencesOfString:@" " withString:@""];
            strLink = [strLink stringByReplacingOccurrencesOfString:@"(" withString:@""];
            strLink = [strLink stringByReplacingOccurrencesOfString:@")" withString:@""];
            NSArray *arr = [strLink componentsSeparatedByString:@","];
            if(arr.count>0){
                [_episodeData setObject:arr forKey:key];
            }
            NSLog(@"xxxxKey %@",arr);
        }
    }
    
    return count;
     */
//    NSInteger numberOfSection = 0;
//    if (filmData && filmData.count > 0) {
//        numberOfSection++;
//    }
//    if (server2Data && server2Data.count > 0) {
//        numberOfSection++;
//    }
//    return numberOfSection;
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    /*
    NSArray *allKey = [_episodeData allKeys];
    
    NSArray *links = [_episodeData objectForKey:[allKey objectAtIndex:section]];
    return links.count;
    
    
    return 0;
    */
    if ([self tableView:self.tbServes numberOfRowsInSection:0] == 1) {
        if (filmData && filmData.count > 0) {
            return filmData.count;
        }
        if (server2Data && server2Data.count > 0) {
            return server2Data.count;
        }
        return 0;
    }
    int index = (int)collectionView.tag;
    if (index == 0) {
        return filmData.count;
    }else{
        return server2Data.count;

    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"episodeViewCell";
    
    EpisodeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if(cell==nil){
        
        cell = [[EpisodeViewCell alloc] initWithFrame:CGRectMake(0, 0, RELATE_CELL_SIZE, RELATE_CELL_SIZE)];
    }
    int index = (int)collectionView.tag;
   
        if (currentSelected.row == indexPath.row && currentSelected.section == indexPath.section) {
            NSLog(@"epsider : begin");

             if (index == curRow) {
                 [cell setEpsisodeContent:indexPath.row +1 status:2];//watching
                 NSLog(@"epsider : wathching");
             }else{
                 [cell setEpsisodeContent:indexPath.row +1 status:3];//none
                 NSLog(@"epsider : none");
             }
        }else{
            
            [cell setEpsisodeContent:indexPath.row +1 status:3];//none
            NSLog(@"epsider : failed: %d -- %d",currentSelected.section,currentSelected.item);

//            if (index == curRow) {
//                [cell setEpsisodeContent:indexPath.row +1 status:2];//watching
//            }else{
//                [cell setEpsisodeContent:indexPath.row +1 status:3];//none
//                
//            }
        }
   
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    int index = (int)collectionView.tag;

    if(currentSelected.row != indexPath.row || index != curRow){
//    NSIndexPath *preIndexPath  = [NSIndexPath indexPathForItem:currentSelected.row inSection:currentSelected.section];
    currentSelected = indexPath;
        if (index !=  curRow) {
          
            curRow = index;
        }
        if (_listphim1) {
            [_listphim1 reloadData];
        }
        if (_listphim2) {
            [_listphim2 reloadData];
        }
//    [self.listRelateFilm reloadItemsAtIndexPaths:@[indexPath,preIndexPath]];
    
        if ([playvideoDelegate respondsToSelector:@selector(playMovieAtIndex:epside:)]) {
            NSString *url = nil;
            if ([self tableView:self.tbServes numberOfRowsInSection:0] == 1) {
                if (filmData && filmData.count > 0) {
                    url = [filmData objectAtIndex:indexPath.row];
                }
                if (server2Data && server2Data.count > 0) {
                    url = [server2Data objectAtIndex:indexPath.row];
                }
            }else if([self tableView:self.tbServes numberOfRowsInSection:0] == 2){
                if (indexPath.section == 0) {
                    url = [filmData objectAtIndex:indexPath.row];
                }else if(indexPath.section == 1){
                    url = [server2Data objectAtIndex:indexPath.row];
                }
            }
            if (url) {
                [playvideoDelegate playMovieAtIndex:url epside:indexPath];

            }
        }
    }
}


//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
// 
//    UICollectionReusableView *reusableview = nil;
//    
//    if (kind == UICollectionElementKindSectionHeader) {
//        RecipeCollectionHeaderView *sectionHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeaderView" forIndexPath:indexPath];
//        NSString *title = [[NSString alloc]initWithFormat:@"Server #%i", indexPath.section + 1];
//        sectionHeaderView.title.text = title;
////        UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
////        sectionHeaderView.backgroundImage.image = headerImage;
////        if ([_listRelateFilm numberOfItemsInSection:indexPath.section] == 0) {
////            sectionHeaderView.frame = CGRectMake(0, 0, _viewWidth, 0);
////            sectionHeaderView.backgroundColor = [UIColor clearColor];
////        }
//        sectionHeaderView.backgroundColor = [UIColor whiteColor];
//        sectionHeaderView.title.textColor = [UIColor blackColor];
//        reusableview = sectionHeaderView;
//    }
//    
//    if (kind == UICollectionElementKindSectionFooter) {
//        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
//        
//        reusableview = footerview;
//    }
//    
//    return reusableview;
//}
//-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewCell *cell= [_listRelateFilm cellForItemAtIndexPath:indexPath];
//    cell.layer.backgroundColor = [[UIColor redColor] CGColor];
//    cell.layer.cornerRadius = RELATE_CELL_SIZE/2;
//    cell.clipsToBounds = YES;
//    cell.layer.borderWidth =.5f;
//    cell.layer.borderColor = [[UIColor redColor] CGColor];
//    
//    cell.backgroundColor = [UIColor redColor];
//
//
//
//}
//-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewCell *cell= [_listRelateFilm cellForItemAtIndexPath:indexPath];
//    cell.layer.backgroundColor = [[UIColor blueColor] CGColor];
//    cell.layer.cornerRadius = RELATE_CELL_SIZE/2;
//    cell.clipsToBounds = YES;
//    cell.layer.borderWidth =.5f;
//    cell.layer.borderColor = [[UIColor redColor] CGColor];
//
//    cell.backgroundColor = [UIColor whiteColor];
//    
//
//}
//-(void)setDataArrayEpsolider:(NSMutableDictionary *)dic{
//    _episodeData  = dic;
//    //[UIView animateWithDuration:0 animations:^{
//        [_listRelateFilm reloadData];
//    //} completion:^(BOOL finished) {
//        //Do something after that...
//        [self initEpsoliderLabel];
//    [self bringSubviewToFront:_indicator];
//        [_indicator stopAnimating];
////        [_indicator setHidden:YES];
//   // }];
//    
//}
-(void)setDataArrayEpsolider2:(NSArray *)data server2:(NSArray *)servers currentIndexPath:(NSIndexPath *)curIndexPath
{
    currentSelected = curIndexPath;
    [filmData removeAllObjects];
    [server2Data removeAllObjects];

     if (data && [data isKindOfClass:[NSArray class]]) {
         [filmData addObjectsFromArray:data];
     }
    
    if (servers && [servers isKindOfClass:[NSArray class]]) {
        [server2Data addObjectsFromArray:servers];
    }
    
    //
    [self.tbServes reloadData];
    [_indicator stopAnimating];
    [_indicator setHidden:YES];
    NSLog(@"BindDataToEpsi");
}
-(void)initEpsoliderLabel{
//    NSInteger len = _listRelateFilm.numberOfSections;
//    NSArray *allKey = [_episodeData allKeys];
//    for(int i = 0; i < len;i++){
//        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(_viewWidth/2 - 30,0, 60, 30)];
//        
//        lb.text = [allKey objectAtIndex:i];
//        lb.font = [UIFont systemFontOfSize:13.f];
//        [self addSubview:lb];
//    
//    }

}
@end
