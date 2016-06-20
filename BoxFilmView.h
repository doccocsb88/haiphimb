//
//  BoxFilmView.h
//  SlideMenu
//
//  Created by Apple on 5/30/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoxFilmView : UIView
@property (strong, nonatomic) UIImageView *thumbnail;
@property (strong, nonatomic) UILabel *filmNameVi;
@property (strong, nonatomic) UILabel *filmNameEn;
-(id)initWithStyle: (CGFloat) width height: (CGFloat) height;
@end
