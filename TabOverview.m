//
//  TabOverview.m
//  SlideMenu
//
//  Created by Apple on 6/2/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import "TabOverview.h"
@interface TabOverview()
{
    CGFloat viewWidh;
    CGFloat viewHeight;
}
@property (strong, nonatomic) UIScrollView *scroll ;
@property (strong,nonatomic) NSString *mvname;
@property (strong,nonatomic) NSString *mvdescription;
@end
@implementation TabOverview

-(id)initWithInfo:(NSString *)name descriotion:(NSString *)desc frame :(CGRect)frame{
    self = [super initWithFrame:frame] ;
    if(self){
        viewHeight = frame.size.height;
        viewWidh =frame.size.width;
        _mvname = name;
        _mvdescription = desc;
        [self initViews];
//        self.backgroundColor = [UIColor yellowColor];
    }
    return self;

}
-(void)initViews{
    _title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, viewWidh-20,20 )];
//    _title.text = @"Nội dung phim";
    _title.font = [UIFont systemFontOfSize:10.f];
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    _title.attributedText = [[NSAttributedString alloc] initWithString:@"Nội dung phim"
                                                             attributes:underlineAttribute];
//    _title.backgroundColor = [UIColor greenColor];
    [self addSubview:_title];
    
    _movieName = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, viewWidh-20, 20)];
    _movieName.text =@"";
    _movieName.font = [UIFont systemFontOfSize:12.f];
//    _movieName.backgroundColor = [UIColor greenColor];
    [self addSubview:_movieName];
    
    _movieDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidh-20, viewHeight)];
    _movieDescription.numberOfLines = 0;
    [_movieDescription sizeToFit];
    _movieDescription.text =@"";
    _movieDescription.backgroundColor = [UIColor whiteColor];
    _movieDescription.font = [UIFont systemFontOfSize:11.f];
    _movieDescription.backgroundColor = [UIColor greenColor];
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 50, viewWidh-20, viewHeight - 70)];
    
    [_scroll addSubview:_movieDescription];
    [self addSubview:_scroll];
//    self.layer.masksToBounds = NO;
//    self.layer.cornerRadius = 8; // if you like rounded corners
//    self.layer.shadowOffset = CGSizeMake(-5, 5);
//    self.layer.shadowRadius = 5;
//    self.layer.shadowOpacity = 0.5;

}
-(void)bindDataToView : (NSString *)name desc : (NSString *)desc{
//    UILabel *oldlb= [_m]
    [_movieDescription removeFromSuperview];
    UILabel *testLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,0, viewWidh-20,20 )]; // RectMake(xPos,yPos,Max Width I want, is just a container value);
  
    testLabel.tag= 11;
    testLabel.font = [UIFont systemFontOfSize:11.f];
    testLabel.text = [NSString stringWithFormat:@"      %@",desc];
    testLabel.numberOfLines = 0; //will wrap text in new line
    [testLabel sizeToFit];
    
    [_scroll addSubview:testLabel];
    _scroll.contentSize =CGSizeMake(viewWidh -20, testLabel.frame.size.height +20);
//    _movieName.text =name;
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    _movieName.attributedText = [[NSAttributedString alloc] initWithString:name
                                                            attributes:underlineAttribute];
    _movieDescription = testLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
