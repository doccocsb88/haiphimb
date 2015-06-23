//
//  TabInfoView.h
//  SlideMenu
//
//  Created by Apple on 5/30/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilmInfoDetails.h"
@interface TabInfoView : UIView
@property (nonatomic) CGFloat viewWidth;
@property (nonatomic) CGFloat viewHeight;
@property (strong,nonatomic) UIActivityIndicatorView *indicator;
@property (strong,nonatomic) UIImageView *thumbnail;
@property (strong, nonatomic) UILabel *filmTitleVi;
@property (strong, nonatomic) UILabel *filmTitleEn;
@property (strong, nonatomic) UILabel *lbTitleDirector;
@property (strong, nonatomic) UILabel *lbTitleActor;
@property (strong, nonatomic) UILabel *lbTitleCategory;
@property (strong, nonatomic) UILabel *lbTitleNation;
@property (strong, nonatomic) UILabel *lbTitleDuration;
@property (strong, nonatomic) UILabel *lbTitleQuality;
//
@property (strong, nonatomic) UILabel *lbDirector;
@property (strong, nonatomic) UILabel *lbActor;
@property (strong, nonatomic) UILabel *lbCategory;
@property (strong, nonatomic) UILabel *lbNation;
@property (strong, nonatomic) UILabel *lbDuration;
@property (strong,nonatomic)FilmInfoDetails *filmInfo;

-(id)initWidthData : (FilmInfoDetails *)data frame:(CGRect)frame;
-(void)bindDataToView: (FilmInfoDetails *)data;
-(void)setInfoThumbnail:(UIImage *)thumbnail;

@end
