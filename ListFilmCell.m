//
//  CollectionViewCell.m
//  SlideMenu
//
//  Created by Apple on 5/30/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import "ListFilmCell.h"
#import "ColorSchemeHelper.h"
#import "ImageUtils.h"
#import "UIDevice-Hardware.h"
#define BOXFILM_MARGIN 3
#define BOXFILM_MARGIN_LEFT 0
#define HOZ_BOXFILM_MARGIN_LEFT 20
#define ROUNDED_RADIUS 7.0f
#define LAYOUT_STYLE_HORIZOL 1
#define LAYOUT_STYLE_VERTICAL 2
@interface ListFilmCell()
@property (nonatomic) CGFloat actualWidth;
@property (nonatomic) CGFloat actualHeight;

@end
@implementation ListFilmCell
@synthesize imgDelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _actualWidth = frame.size.width;
        _actualHeight = frame.size.height;
        [self initViews];
    }
    return self;
}
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
    _layoutStyle = LAYOUT_STYLE_VERTICAL;
    [self initThumbnail];
    [self initFilmTitle];
    [self initIndicator];
}
-(void)initThumbnail{
    if (_layoutStyle == LAYOUT_STYLE_VERTICAL) {
        _thumbnail = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _thumbnail.contentMode = UIViewContentModeScaleAspectFill;
        _thumbnail.frame = CGRectMake(BOXFILM_MARGIN_LEFT, BOXFILM_MARGIN, _actualWidth - BOXFILM_MARGIN_LEFT*2, _actualHeight - 40);
        CALayer * l = [_thumbnail layer];
        [l setBorderColor: [[ColorSchemeHelper sharedThumbnailBorderColor] CGColor]];
        [l setBorderWidth: 1.0];

        [l setMasksToBounds:YES];
        [l setCornerRadius:ROUNDED_RADIUS];
    }else{
        _thumbnail= [[UIImageView alloc] initWithFrame:CGRectMake(HOZ_BOXFILM_MARGIN_LEFT, 10, 40, 60)];
        _thumbnail.contentMode = UIViewContentModeScaleAspectFill;
        _thumbnail.image = [UIImage imageNamed:@""];
    }
    
    [self.contentView addSubview:_thumbnail];
}
-(void)initFilmTitle{
    if (_layoutStyle == LAYOUT_STYLE_VERTICAL) {
        _filmNameVi = [[UILabel alloc] initWithFrame:CGRectMake(0, _actualHeight - 30, _actualWidth, 30)];
        _filmNameVi.text = @"Tieu de film";
        _filmNameVi.font = [UIFont systemFontOfSize:12.f];
        _filmNameVi.lineBreakMode = NSLineBreakByWordWrapping;
        _filmNameVi.numberOfLines = 0;
        _filmNameVi.textColor = [ColorSchemeHelper sharedMovieInfoTitleColor];
        _filmNameVi.textAlignment = NSTextAlignmentCenter;
    }else if(_layoutStyle == LAYOUT_STYLE_HORIZOL){
        _filmNameVi = [[UILabel alloc] initWithFrame:CGRectMake(HOZ_BOXFILM_MARGIN_LEFT+50, 15, _actualWidth - 70, 20)];
        [_filmNameVi setText:@"name"];
        _filmNameVi.adjustsFontSizeToFitWidth = NO;
        _filmNameVi.lineBreakMode = NSLineBreakByTruncatingTail;

    }

        [self.contentView addSubview:_filmNameVi];
    /*
    _filmNameEn = [[UILabel alloc] initWithFrame:CGRectMake(0, _actualHeight - 20, _actualWidth, 20)];
    _filmNameEn.text = @"Tieu de film";
    _filmNameEn.font = [UIFont systemFontOfSize:15.f];
    _filmNameEn.textColor = [UIColor grayColor];
    [self.contentView addSubview:_filmNameEn];
     */
//    if (_layoutStyle ==  LAYOUT_STYLE_VERTICAL) {
    UIFont *font = [UIFont systemFontOfSize:10];
    NSString *deviceString =[[UIDevice currentDevice] platformString];
    if ([deviceString containsString:@"iPad"]) {
        _lbSotap = [[UILabel alloc] initWithFrame:CGRectMake(_actualWidth - 55, 10, 50, 20)];
        font = [UIFont systemFontOfSize:15];
    }else{
        _lbSotap = [[UILabel alloc] initWithFrame:CGRectMake(_actualWidth - 40, 10, 35, 16)];

    }
        _lbSotap.text = @"a";
        _lbSotap.textAlignment = NSTextAlignmentCenter;
        _lbSotap.backgroundColor = [UIColor redColor];
        _lbSotap.layer.cornerRadius = 2.0;
        _lbSotap.layer.masksToBounds = YES;
        _lbSotap.textColor = [UIColor whiteColor];
        _lbSotap.font = font;
        [self.contentView addSubview:_lbSotap];
//    }
}
-(void)initIndicator{
        _indicator = [[UIActivityIndicatorView alloc]
                  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //    _indicator.frame = _img.frame;
    _indicator.center=_thumbnail.center;
    //    _indicator.backgroundColor = [UIColor grayColor];
    [_indicator startAnimating];
    _indicator.hidesWhenStopped = YES;
    [self.contentView addSubview:_indicator];
}
-(void)setContentView : (SearchResultItem *)item atIndex:(NSInteger)index;
{
    _filmNameVi.text = item.name;
    _lbSotap.text = item.total;
    //[NSString stringWithFormat:@"lkalkdl; lajld fj ladjf %@",item.name];
    if (item.hasData==NO) {
        NSLog(@"setContentForFilmCell:: %d-%d",index,item.hasData);
        _thumbnail.alpha = 0.f;
        [_indicator setHidden:NO];
        [_indicator startAnimating];
        NSString  *photoUrl = item.img;
//        if(index%3==0){
//            photoUrl = @"http://i997.photobucket.com/albums/af92/mrdocco716/funnychicken.jpeg";
//        }
        NSURL *imageURL = [NSURL URLWithString:photoUrl];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            _thumbnail.alpha =0.f;
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                
                [_indicator stopAnimating];
//                [_indicator removeFromSuperview];
                if (imageData) {
//                    UIImage *img  = [ImageUtils drawText:@"HAIDEPTRAI" inImage:[UIImage imageWithData:imageData] atPoint:CGPointMake(_actualWidth/2, _actualHeight/2)];
                    _thumbnail.image = [UIImage imageWithData:imageData];
                }else{
                    _thumbnail.contentMode = UIViewContentModeScaleAspectFit;
                    _thumbnail.image = [UIImage imageNamed:@"img_notfound.png"];

                }
                [imgDelegate setImageAtIndex:index image: _thumbnail.image];
                [UIView animateWithDuration:.3f animations:^{
                    _thumbnail.alpha = 1.0f;
                }];
            });
        });
    }else{
        _thumbnail.contentMode = UIViewContentModeScaleToFill;
//        UIImage *img  = [ImageUtils drawText:@"HAIDEPTRAI" inImage:item.thumbnail atPoint:CGPointMake(_actualWidth/2, _actualHeight/2)];
        _thumbnail.image = item.thumbnail;
        [_indicator stopAnimating];

    }

}

-(void)setContentView:(SearchResultItem *)item atIndex:(NSInteger)index single:(BOOL)single{
    [self setContentView:item atIndex:index];
    if (single) {
//        CGSize width = [item.total sizeWithFont:self.lbSotap.font
//                                      constrainedToSize:CGSizeMake(100000, 20)
//                                              lineBreakMode:self.lbSotap.lineBreakMode   ];
//        
//        float widthIs =
//        [self.lbSotap.text
//         boundingRectWithSize:CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds])/3, self.lbSotap.frame.size.height)
//         options:NSStringDrawingUsesLineFragmentOrigin
//         attributes:@{ NSFontAttributeName:self.lbSotap.font }
//         context:nil]
//        .size.width;
//        CGRect frame = self.lbSotap.frame;
//        self.lbSotap.frame = CGRectMake(frame.origin.x, frame.origin.y, widthIs + 10, frame.size.height);
        self.lbSotap.hidden = single;
    }
}
//-(void)setContentView:(SearchResultItem *)item{
//    
//    
//    _filmNameVi.text = item.name;
//    NSURL *imageURL = [NSURL URLWithString:item.img];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // Update the UI
//            [_indicator stopAnimating];
//            [_indicator removeFromSuperview];
//            _thumbnail.image = [UIImage imageWithData:imageData];
//            [imgDelegate setImageAtIndex:1 image: _thumbnail.image];
//        });
//    });
//
//


//}
@end
