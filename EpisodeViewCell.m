//
//  EpisodeViewCell.m
//  phimb
//
//  Created by Apple on 6/6/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import "EpisodeViewCell.h"
@interface EpisodeViewCell()
{
    CGRect _frame;
}
@end
@implementation EpisodeViewCell
-(void)awakeFromNib{
    [super awakeFromNib];
    CGFloat cellSize = 15.0;
    self.lbEpisode.layer.cornerRadius = cellSize;
    self.lbEpisode.layer.masksToBounds = YES;
    self.lbEpisode.clipsToBounds = YES;
}
-(id)initWithFrame:(CGRect)frame label:(NSInteger)epsisode status:(NSInteger)status{
    self =[super initWithFrame:frame];
    if(self){
        _frame = frame;
        self.epsisode = epsisode;
        self.statusEpisode = status;
        [self initViews];
        [self setBackgroundcolorByStatus:status];
    }
    return self;

}
-(void)initViews{
    CGFloat cellSize = _frame.size.width/2;

    self.lbEpisode.text = [NSString stringWithFormat:@"%d",self.epsisode];
  

}
-(void)setBackgroundcolorByStatus : (NSInteger)status{
    switch (status) {
        case 1:
            self.lbEpisode.backgroundColor = [UIColor redColor];
                        break;
        case 2:
            self.lbEpisode.backgroundColor = [UIColor redColor];
            self.lbEpisode.layer.borderWidth = 0.5f;
            self.lbEpisode.layer.borderColor = [UIColor redColor].CGColor;
            self.lbEpisode.textColor = [UIColor whiteColor];
       
            break;
        case 3:
            self.lbEpisode.backgroundColor = [UIColor whiteColor];
            self.lbEpisode.layer.borderWidth = 0.5f;
            self.lbEpisode.layer.borderColor = [UIColor redColor].CGColor;
            self.lbEpisode.textColor = [UIColor blackColor];
            break;
 
    }
}
-(void)setEpsisodeContent: (NSInteger )epsi status:(NSInteger)status{
    [self.lbEpisode setText:[NSString stringWithFormat:@"%d",epsi]];
    self.epsisode = epsi;
    [self setBackgroundcolorByStatus:status];

}
@end
