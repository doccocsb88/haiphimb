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
#define RELATE_CELL_SIZE 30
@interface TabRelateView()
{
    NSMutableArray *filmData;
    CGFloat boxW;
    int currentSelected;
}

//@property (strong,nonatomic) NSMutableDictionary *episodeData;
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
        self.backgroundColor = [UIColor purpleColor];
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
    currentSelected = 0;
    [self initRelateFilmCollection];
    [self initIndicator];
   
}
-(void)initData{
//_episodeData = [[NSMutableDictionary alloc] init];
    filmData = [[NSMutableArray alloc] init];
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
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(RELATE_CELL_SIZE   , RELATE_CELL_SIZE)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];

    _listRelateFilm = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 5, _viewWidth - 20  , _viewHeight - 10) collectionViewLayout:flowLayout];
    [_listRelateFilm registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"epCell"];
//    _listRelateFilm.collectionViewLayout = flowLayout;
    //    _listFilm.frame = ;
    _listRelateFilm.dataSource = self;
    _listRelateFilm.delegate = self;
    _listRelateFilm.backgroundColor = [UIColor clearColor];
    [_listRelateFilm setShowsHorizontalScrollIndicator:NO];
    [self addSubview:_listRelateFilm];
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
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    /*
    NSArray *allKey = [_episodeData allKeys];
    
    NSArray *links = [_episodeData objectForKey:[allKey objectAtIndex:section]];
    return links.count;
    
    
    return 0;
    */
    return filmData.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"epCell";
    
    UICollectionViewCell *cell = (UICollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if(cell==nil){
        
        cell = [[UICollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, RELATE_CELL_SIZE, RELATE_CELL_SIZE)];
    }
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, RELATE_CELL_SIZE, RELATE_CELL_SIZE)];
    lb.tag = indexPath.row;
    lb.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    lb.textAlignment  = NSTextAlignmentCenter;
    [cell.contentView addSubview:lb];
    lb.layer.cornerRadius = RELATE_CELL_SIZE/2;
    lb.clipsToBounds = YES;
    lb.layer.borderWidth =.5f;
    lb.layer.borderColor = [[UIColor redColor] CGColor];
    if (indexPath.row==currentSelected) {
        lb.textColor = [UIColor whiteColor];
        lb.backgroundColor = [UIColor redColor];

    }else{
        lb.backgroundColor = [UIColor whiteColor];

    }
        return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSIndexPath *preIndexPath  = [NSIndexPath indexPathForItem:currentSelected inSection:indexPath.section];
    currentSelected = indexPath.row;

    [self.listRelateFilm reloadItemsAtIndexPaths:@[indexPath,preIndexPath]];


}
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
-(void)setDataArrayEpsolider2:(NSArray *)data{
    [filmData removeAllObjects];
    [filmData addObjectsFromArray:data];
    [_listRelateFilm reloadData];
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
