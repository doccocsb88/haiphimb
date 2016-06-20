//
//  TabInfoView.m
//  SlideMenu
//
//  Created by Apple on 5/30/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import "TabInfoView.h"
#import "ColorSchemeHelper.h"
@interface TabInfoView(){
    CGFloat thumbH ;
    CGFloat thumbW ;
    CGFloat lbHeight;
}
@end
@implementation TabInfoView
@synthesize thumbnail = _thumbnail;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWidthData:(FilmInfoDetails *)data frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        _filmInfo = data;
        _viewWidth =frame.size.width;
        _viewHeight = frame.size.height;
        
        [self _init];
    }
    
    return self;
}
-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _filmInfo = [[FilmInfoDetails alloc] init];
        _viewWidth =frame.size.width;
        _viewHeight = frame.size.height;
        [self _init];
    }
    
    return self;
}
-(void)_init{
    CGFloat ratio  = 462.f/692.f;
    thumbH = _viewHeight - 10;
    thumbW = thumbH*ratio;
     if(thumbH > 160){
         lbHeight = 23;
     }
     else if(thumbH > 140){
        lbHeight = 16;
    }else{
        lbHeight = 13;
    }
    NSLog(@"filmInfoTextH %f",lbHeight);
    [self initThumbnail];
    [self initFilmInfo];
}
-(void)initThumbnail{
  
    _thumbnail = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    _thumbnail.frame = CGRectMake(5, 5, thumbW, thumbH);
    _thumbnail.contentMode = UIViewContentModeScaleToFill;
    _thumbnail.layer.cornerRadius = 8.f;
    _thumbnail.clipsToBounds = YES;
    _thumbnail.layer.borderWidth = 1.f;
    _thumbnail.layer.borderColor = [[ColorSchemeHelper sharedThumbnailBorderColor] CGColor];
    [self addSubview:_thumbnail];
    //
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.frame = _thumbnail.frame;
//    _indicator.center = _thumbnail.center;
    [_indicator startAnimating];
    _indicator.hidesWhenStopped = YES;
    [self addSubview:_indicator];
}
-(void)initFilmInfo{
    CGFloat rH = lbHeight-3;
    CGFloat lbWidth = _viewWidth -thumbW - 20;
    CGFloat lbMarginLeft =  thumbW + 15;
    UIFont *mediulFont  = [UIFont systemFontOfSize:14.f];
    UIFont *titlefont= [UIFont systemFontOfSize:15.f];
    _filmTitleVi = [[UILabel alloc] initWithFrame:CGRectMake(lbMarginLeft, 5, lbWidth, lbHeight)];
    _filmTitleVi.font = titlefont;
    _filmTitleVi.text = [NSString stringWithFormat:@"%@",_filmInfo.name];
    _filmTitleVi.textColor = [ColorSchemeHelper sharedMovieInfoTitleColor];
    _filmTitleVi.font = mediulFont;
    _filmTitleEn = [[UILabel alloc] initWithFrame:CGRectMake(lbMarginLeft, lbHeight+=rH, lbWidth, lbHeight)];
    _filmTitleEn.font = titlefont;
    _filmTitleEn.attributedText = [self createAtributedString:@"Movie : " andString:_filmInfo.subname];
    //quality
    _lbTitleQuality = [[UILabel alloc] initWithFrame:CGRectMake(lbMarginLeft, lbHeight+=rH, lbWidth, lbHeight)];
    _lbTitleQuality.attributedText = [self createAtributedString:@"Status : " andString:[NSString stringWithFormat:@"%d",_filmInfo.total]];
    [self addSubview:_lbTitleQuality];
    //director
    _lbTitleDirector = [[UILabel alloc] initWithFrame:CGRectMake(lbMarginLeft, lbHeight+=rH, lbWidth, lbHeight)];
    _lbTitleDirector.attributedText = [self createAtributedString:@"Director : " andString:_filmInfo.director];
    [self addSubview:_lbTitleDirector];
    //stars
    _lbTitleActor = [[UILabel alloc] initWithFrame:CGRectMake(lbMarginLeft, lbHeight+=rH, lbWidth, lbHeight)];
    _lbTitleActor.attributedText = [self createAtributedString:@"Star : " andString:_filmInfo.star];
    [self addSubview:_lbTitleActor];
    //genre
    _lbTitleCategory = [[UILabel alloc] initWithFrame:CGRectMake(lbMarginLeft, lbHeight+=rH, lbWidth, lbHeight)];
    _lbTitleCategory.attributedText = [self createAtributedString:@"Genre : " andString:_filmInfo.cate];
    [self addSubview:_lbTitleCategory];
    //nation
    _lbTitleNation = [[UILabel alloc] initWithFrame:CGRectMake(lbMarginLeft, lbHeight+=rH, lbWidth, lbHeight)];
    _lbTitleNation.attributedText = [self createAtributedString:@"Nation : " andString:_filmInfo.country];
    [self addSubview:_lbTitleNation];
    [self addSubview:_filmTitleVi];
    [self addSubview:_filmTitleEn];
    /**/
}
-(void)bindDataToView : (FilmInfoDetails *)data{
    _filmInfo = data;
    _filmTitleVi.text = [NSString stringWithFormat:@"%@",_filmInfo.name];
    //subname
//    _filmTitleEn.text = [NSString stringWithFormat:@"Movie : %@",_filmInfo.subname];
    _filmTitleEn.attributedText = [self createAtributedString:@"Movie : " andString:_filmInfo.subname];
    //quality
//    _lbTitleQuality.text = [NSString stringWithFormat:@"Status : %d",_filmInfo.total];
    _lbTitleQuality.attributedText = [self createAtributedString:@"Status : " andString:[NSString stringWithFormat:@"%d",_filmInfo.total]];
    //director
//    _lbTitleDirector.text =[NSString stringWithFormat: @"Director : %@",_filmInfo.director];
    _lbTitleDirector.attributedText = [self createAtributedString:@"Director : " andString:_filmInfo.director];
    //stars
//    _lbTitleActor.text = [NSString stringWithFormat:@"Stars : %@",_filmInfo.star];
    _lbTitleActor.attributedText = [self createAtributedString:@"Star : " andString:_filmInfo.star];
    //genre
//    _lbTitleCategory.text = [NSString stringWithFormat:@"Genre : %@",_filmInfo.cate];
    _lbTitleCategory.attributedText = [self createAtributedString:@"Genre : " andString:_filmInfo.cate];
    //nation
//    _lbTitleNation.text = [NSString stringWithFormat: @"Nation : %@",_filmInfo.country];
    _lbTitleNation.attributedText = [self createAtributedString:@"Nation : " andString:_filmInfo.country];
    //
    if (_thumbnail.image==nil) {
       
    NSURL *imageURL = [NSURL URLWithString:_filmInfo.img];
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                _thumbnail.image = [UIImage imageWithData:imageData];
                [_indicator stopAnimating];
            });
        });
    }
}
-(NSAttributedString *)createAtributedString:(NSString *)strA andString:(NSString *)strB{
    UIFont *arialFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11.0];
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: arialFont forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:strA attributes: arialDict];
    [aAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:(NSMakeRange(0, strA.length))];

    UIFont *VerdanaFont = [UIFont fontWithName:@"HelveticaNeue" size:10.0];
    NSDictionary *verdanaDict = [NSDictionary dictionaryWithObject:VerdanaFont forKey:NSFontAttributeName];
    NSMutableAttributedString *vAttrString = [[NSMutableAttributedString alloc]initWithString: strB attributes:verdanaDict];
    [vAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:(NSMakeRange(0, strB.length))];
    
    [aAttrString appendAttributedString:vAttrString];
    return aAttrString;
}
-(void)setInfoThumbnail:(UIImage *)thumbnail{
    if (thumbnail!=nil) {
        _thumbnail.image = thumbnail;
        [_indicator stopAnimating];
    }
}
@end
