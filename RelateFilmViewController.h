//
//  RelateFilmViewController.h
//  phimb
//
//  Created by Apple on 6/7/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "ListFilmCell.h"
@protocol RelateFilmViewControllerDelegate <NSObject>

@required
-(void)playMovieWithData:(SearchResultItem *)item;
@end

@interface RelateFilmViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,RequestImageDelegate>
@property (strong, nonatomic) id<RelateFilmViewControllerDelegate> delegate;
@property (strong, nonatomic) UICollectionView *listRelatefilm;
-(id)initWithWidth:(CGFloat) width;
-(void)loadRelateFilm:(NSString *)cate;

@end
