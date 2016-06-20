//
//  UserDataViewCell.m
//  phimb
//
//  Created by Apple on 6/11/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import "UserDataViewCell.h"
#import "ColorSchemeHelper.h"
@interface UserDataViewCell(){
    CGFloat viewWidth;
    CGFloat viewHeight;
    CGFloat thumnailW;
    CGFloat margin;
}
@end
@implementation UserDataViewCell
@synthesize thumbnail,lbname,lbstart,lbtotal,indicator;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        viewHeight = frame.size.height;
        viewWidth = frame.size.width;
        margin = 10;
//        self setcontent
        [self initViews];
    }
    
    return self;

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)initViews{
    //init thumbanil
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(10, 5, viewWidth-20, viewHeight-10)];
    bg.backgroundColor = [ColorSchemeHelper sharedHistoryBgCellColor];
    [self addSubview:bg];
    thumnailW = 50;
    thumbnail = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, thumnailW, 70)];
    thumbnail.contentMode = UIViewContentModeScaleAspectFit;
    thumbnail.image = [UIImage imageNamed:@""];
    thumbnail.backgroundColor = [UIColor grayColor];
    [self addSubview:thumbnail];
    //
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.frame = thumbnail.frame;
    indicator.center = thumbnail.center;
    [indicator startAnimating];
    [indicator hidesWhenStopped];
    [self addSubview:indicator];
    //
    lbname = [[UILabel alloc] initWithFrame:CGRectMake(thumnailW + 20, viewHeight/4, viewWidth - thumnailW-30, 15)];
    lbname.textColor = [UIColor whiteColor];
    lbname.font = [UIFont systemFontOfSize:12.f];
    lbname.text = @"name";
    [self addSubview:lbname];
    lbstart = [[UILabel alloc] initWithFrame:CGRectMake(thumnailW +20, viewHeight/4 +15, viewWidth -thumnailW-30, 20)];
    lbstart.text =@"stars";
    lbstart.textColor =[UIColor grayColor];
    lbstart.font = [UIFont systemFontOfSize:12.f];
    [self addSubview:lbstart];
    
    lbtotal = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth - 20, 2, 16, 16)];
    lbtotal.text = @"1";
    lbtotal.textColor = [UIColor whiteColor];
    lbtotal.textAlignment = NSTextAlignmentCenter;
    lbtotal.font = [UIFont systemFontOfSize:12.f];
    lbtotal.backgroundColor = [UIColor redColor];
    lbtotal.layer.cornerRadius = 8.f;
    lbtotal.clipsToBounds = YES;
    [self addSubview:lbtotal];
    
}
-(void)setContent:(UserDataFilm *)userData{
    int total  =userData.info.total%100;
    lbtotal.text = [NSString stringWithFormat:@"%d",total];
    if (total==0) {
        [lbtotal setHidden:YES];
    }
    lbstart.text = userData.info.star;
    lbname.text = userData.info.name;
        NSURL *imageURL = [NSURL URLWithString:userData.info.img];
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
//                [_indicator stopAnimating];
//                [_indicator removeFromSuperview];
                if(imageData!=nil){
                    thumbnail.image = [UIImage imageWithData:imageData];
                    [indicator stopAnimating];
                }
//                [imgDelegate setImageAtIndex:1 image: _thumbnail.image];
            });
        });
}
@end
