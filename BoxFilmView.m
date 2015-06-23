//
//  BoxFilmView.m
//  SlideMenu
//
//  Created by Apple on 5/30/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import "BoxFilmView.h"
#define BOXFILM_MARGIN 3

@interface BoxFilmView()
@property (nonatomic) CGFloat actualWidth;
@property (nonatomic) CGFloat actualHeight;

@end
@implementation BoxFilmView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithStyle: (CGFloat) width height: (CGFloat) height{
    self = [super init];
    if(self){
        _actualWidth = width;
        _actualHeight = height;
        [self initViews];
    }
    return self;
}
-(void)initViews{
    [self initThumbnail];
    [self initFilmTitle];
}
-(void)initThumbnail{
    _thumbnail = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filmthumbnail.jpg"]];
    _thumbnail.frame = CGRectMake(BOXFILM_MARGIN, BOXFILM_MARGIN, _actualWidth - BOXFILM_MARGIN*2, _actualHeight - 40);
    
    [self addSubview:_thumbnail];
}
-(void)initFilmTitle{
    _filmNameVi = [[UILabel alloc] initWithFrame:CGRectMake(0, _actualHeight - 40, _actualWidth, 20)];
    _filmNameVi.text = @"Tieu de film";
    _filmNameVi.font = [UIFont systemFontOfSize:15.f];
    [self addSubview:_filmNameVi];
    
    _filmNameEn = [[UILabel alloc] initWithFrame:CGRectMake(0, _actualHeight - 20, _actualWidth, 20)];
    _filmNameEn.text = @"Tieu de film";
    _filmNameEn.font = [UIFont systemFontOfSize:15.f];
    _filmNameEn.textColor = [UIColor grayColor];
    [self addSubview:_filmNameEn];
}
@end
