//
//  HomeMenuViewCell.m
//  phimb
//
//  Created by Apple on 6/11/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import "HomeMenuViewCell.h"
@interface HomeMenuViewCell(){
    CGFloat viewWidth;
    CGFloat viewHeight;
    UIView *separate;
}
@end
@implementation HomeMenuViewCell
@synthesize icon,lbText;
- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGSize)frame{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        viewHeight = frame.height;
        viewWidth = frame.width;
        [self initViews];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   
    // Configure the view for the selected state
}
-(void)initViews{
    UIFont *font = [UIFont systemFontOfSize:14.f];
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, viewHeight, viewHeight-10)];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview:icon];
    
    lbText = [[UILabel alloc] initWithFrame:CGRectMake(20 + viewHeight, 0, viewWidth - viewHeight-20, viewHeight)];
    lbText.font = font;
    lbText.textColor = [UIColor blackColor];
    
    //
    separate = [[UIView alloc] initWithFrame:CGRectMake(10, viewHeight-1, viewWidth,0.5f)];
    separate.backgroundColor = [UIColor grayColor];
    [separate setHidden:YES];
    [self addSubview:separate];
    [self addSubview:lbText];
//    self.backgroundColor = [UIColor grayColor];
}
-(void)SetContentView:(NSString *)text image:(NSString *)imageName{
    lbText.text =text;
    UIImage *img  = [UIImage imageNamed:imageName];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    icon.image = img;
}
-(void)SetContentView:(NSString *)text image:(NSString *)imageName separate:(BOOL)has{
    lbText.text =text;
    UIImage *img  = [UIImage imageNamed:imageName];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    icon.image = img;
    [separate setHidden:!has];

}

@end
