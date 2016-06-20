//
//  TabRelateView.h
//  SlideMenu
//
//  Created by Apple on 5/30/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PlayMovieDelegate <NSObject>
@required
-(void)playMovieAtIndex : (NSString *)url;
@end

@interface TabRelateView : UIView <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, weak) id<PlayMovieDelegate> playvideoDelegate;

@property (strong, nonatomic) UICollectionView *listRelateFilm;
@property (nonatomic) CGFloat viewWidth;
@property (nonatomic) CGFloat viewHeight;
-(id)initWithData : (NSDictionary *)dic frame : (CGRect) frame;
//-(void)setDataArrayEpsolider : (NSDictionary *)dic;
-(void)setDataArrayEpsolider2: (NSArray *)data;
@end
