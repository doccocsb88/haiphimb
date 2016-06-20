//
//  FilmViewCell.h
//  phimb
//
//  Created by becauseyoulive1989 on 4/25/16.
//  Copyright © 2016 com.haiphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultItem.h"
@interface FilmViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
-(void)setContentView:(SearchResultItem *)item;
@end
