//
//  EpisodeViewCell.m
//  phimb
//
//  Created by Apple on 6/6/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import "EpisodeViewCell.h"

@implementation EpisodeViewCell
-(id)initWithFrame:(CGRect)frame label:(NSInteger)epsisode status:(NSInteger)status{
    self =[super initWithFrame:frame];
    if(self){
        self.epsisode = epsisode;
        self.statusEpisode = status;
        [self initViews];
        [self setBackgroundcolorByStatus:status];
    }
    return self;

}
-(void)initViews{
    
    self.lbEpisode.text = [NSString stringWithFormat:@"%d",self.epsisode];
}
-(void)setBackgroundcolorByStatus : (NSInteger)status{

    switch (status) {
        case 1:
            self.lbEpisode.backgroundColor = [UIColor redColor];
            self.lbEpisode.layer.cornerRadius = 15.f;
            self.lbEpisode.clipsToBounds = YES;
            break;
        case 2:
            self.lbEpisode.backgroundColor = [UIColor greenColor];
            self.lbEpisode.layer.cornerRadius = 15.f;
            self.lbEpisode.clipsToBounds = YES;
            break;
        case 3:
            self.lbEpisode.backgroundColor = [UIColor greenColor];
            self.lbEpisode.layer.cornerRadius = 15.f;
            self.lbEpisode.clipsToBounds = YES;
            break;
 
    }
}
-(void)setEpsisodeContent: (NSInteger )epsi status:(NSInteger)status{
    [self.lbEpisode setText:[NSString stringWithFormat:@"%d",epsi]];
    [self setBackgroundcolorByStatus:status];

}
@end
