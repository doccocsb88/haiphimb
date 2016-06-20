//
//  HomeMenuViewCell.h
//  phimb
//
//  Created by Apple on 6/11/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeMenuViewCell : UITableViewCell
@property (strong,nonatomic) UIImageView *icon;
@property (strong,nonatomic) UILabel *lbText;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGSize)frame;
-(void)SetContentView:(NSString *)text image:(NSString *)imageName;
-(void)SetContentView:(NSString *)text image:(NSString *)imageName separate:(BOOL)has;

@end
