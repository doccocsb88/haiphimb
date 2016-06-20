//
//  CollectionViewCell.h
//  SlideMenu
//
//  Created by Apple on 5/30/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultItem.h"
@protocol RequestImageDelegate <NSObject>

@required
-(void)setImageAtIndex : (NSInteger )index image : (UIImage *)img;

@end

@interface ListFilmCell : UICollectionViewCell
@property (assign,nonatomic) NSInteger layoutStyle;
@property (strong, nonatomic) UIImageView *thumbnail;
@property (strong, nonatomic) UILabel *filmNameVi;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong,nonatomic) id<RequestImageDelegate> imgDelegate;
//@property (strong, nonatomic) UILabel *filmNameEn;
-(id)initWithStyle: (CGFloat) width height: (CGFloat) height;
-(void)setContentView : (SearchResultItem *)item atIndex:(NSInteger)index;

@end
