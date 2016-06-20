//
//  EpisodeViewCell.h
//  phimb
//
//  Created by Apple on 6/6/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#define STATUS_EPISODE_WATCHED 1
#define STATUS_EPISODE_WATCHING 2
#define STATUS_EPISODE_NONE 3


@interface EpisodeViewCell : UICollectionViewCell
@property (assign,nonatomic) NSInteger statusEpisode;
@property (assign,nonatomic) NSInteger epsisode;
@property (weak,nonatomic) IBOutlet  UILabel *lbEpisode;
-(id)initWithFrame: (CGRect)frame label:(NSInteger )epsisode status:(NSInteger )status;
-(void)setBackgroundcolorByStatus : (NSInteger)status;
-(void)setEpsisodeContent: (NSInteger )epsi status:(NSInteger)status;
@end
