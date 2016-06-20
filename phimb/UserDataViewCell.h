//
//  UserDataViewCell.h
//  phimb
//
//  Created by Apple on 6/11/15.
//  Copyright (c) 2015 com.haiphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDataFilm.h"
@interface UserDataViewCell : UITableViewCell
@property (strong,nonatomic)UIActivityIndicatorView *indicator;
@property (strong,nonatomic)UIImageView *thumbnail;
@property (strong,nonatomic)UILabel *lbname;
@property (strong,nonatomic)UILabel *lbstart;
@property (strong,nonatomic)UILabel *lbtotal;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame;
-(void)setContent:(UserDataFilm *)userData;
@end
