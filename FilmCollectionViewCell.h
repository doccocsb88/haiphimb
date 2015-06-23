//
//  FilmCollectionViewCell.h
//  SlideMenu
//
//  Created by Apple on 5/29/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoxFilmView.h"
#import "ListFilmCell.h"
#import "Genre.h"
//@protocol ViewListFilmDelegate <NSObject>
//@required
//-(void)pushListFilmController;
//@end
@protocol HomeFilmDelegate <NSObject>
@optional
-(void)pushListFilmController:(Genre*)genre;
//-(void)pushListFilmController;

-(void)loadThumbnailDidFetch : (NSArray *)data forCate : (NSString *)cate;
-(void)presentPlayMovieController : (SearchResultItem *)item;
@end
@interface FilmCollectionViewCell : UITableViewCell <UICollectionViewDataSource,UICollectionViewDelegate,RequestImageDelegate>

@property (nonatomic, retain) id <HomeFilmDelegate> homeDeleage;
@property (nonatomic,assign) BOOL hasData;
@property (strong, nonatomic) UILabel *titleCatFilm;
@property (strong , nonatomic) UIButton *btnViewMore;
@property (strong, nonatomic) UICollectionView *listFilm;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height width:(CGFloat)width;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height width:(CGFloat)width withCate : (NSString *)cat;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height width:(CGFloat)width withGenre : (Genre *)cat;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height width:(CGFloat)width withGenre : (Genre *)cat view:(int)indexView;
-(void)didSelectItemAtPoint:(CGPoint)point;
-(void)updateTitle:(NSString *)title;
-(void)setContentView : (Genre *)param;
-(void)setContentView : (Genre *)param indexView:(NSInteger)index;
-(void)setContentView : (Genre *)param withData : (NSArray *)data;
@end
