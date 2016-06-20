//
//  SearchResultViewCell.h
//  SlideMenu
//
//  Created by Apple on 6/1/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultItem.h"
@protocol SearchCellImgDelegate <NSObject>

@required
-(void)setImageAtIndex : (NSInteger )index image : (UIImage *)img;

@end

@interface SearchResultViewCell : UITableViewCell
@property (strong,nonatomic) id<SearchCellImgDelegate> searchCellDelegate;
@property (strong, nonatomic) UIImageView *img;
@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UILabel *subname;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame : (CGRect)frame;
-(void) setContentView: (SearchResultItem *)value;
-(void) setContentView : (SearchResultItem *)item atIndex:(NSInteger)index;

@end
