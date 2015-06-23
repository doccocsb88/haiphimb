//
//  NationDetailViewController.h
//  phimb
//
//  Created by Apple on 6/16/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Genre.h"
#import "FilmCollectionViewCell.h"
#import "PlayVideoViewController.h"
@protocol NationDetailDelegate <NSObject>
-(void)presentPlayerFromNation:(SearchResultItem *)item;
-(void)closePlayerFromNation;
@end

@interface NationDetailViewController :  UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,NSURLConnectionDataDelegate,HomeFilmDelegate>
@property (strong,nonatomic)id<NationDetailDelegate>delegate;
@property (strong,nonatomic) UICollectionView *listFilm;
- (void)callWebService;
-(id)initWithGenre:(Genre *)genre;
-(void)reloadData:(Genre *)genre;

@end
