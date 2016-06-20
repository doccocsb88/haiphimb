//
//  SearchResultViewCell.m
//  SlideMenu
//
//  Created by Apple on 6/1/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import "SearchResultViewCell.h"
#define search_cell_margin_left 20
@interface SearchResultViewCell(){
    CGFloat viewWidth;
    CGFloat viewHeight;
}
@end

@implementation SearchResultViewCell
@synthesize searchCellDelegate;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame : (CGRect)frame{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.frame = frame;
        viewWidth = frame.size.width;
        viewHeight = frame.size.height;
        [self initView];
    }
    return self;
}
-(void)initView{
//    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]
//                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    
//    activityView.center=self.view.center;
//    [activityView startAnimating];
//    [self.view addSubview:activityView];
    //initThumbnail
    _img= [[UIImageView alloc] initWithFrame:CGRectMake(search_cell_margin_left, 10, 40, 60)];
    _img.image = [UIImage imageNamed:@""];
    [self.contentView addSubview:_img];
    _indicator = [[UIActivityIndicatorView alloc]
                                                               initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    _indicator.frame = _img.frame;
    _indicator.center=_img.center;
//    _indicator.backgroundColor = [UIColor grayColor];
    [_indicator startAnimating];
    _indicator.hidesWhenStopped = YES;
    [self.contentView addSubview:_indicator];
    //initNameView
    _name = [[UILabel alloc] initWithFrame:CGRectMake(search_cell_margin_left+50, 15, viewWidth - 70, 20)];
    [_name setText:@"name"];
    _name.adjustsFontSizeToFitWidth = NO;
    _name.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_name ];
    
    _subname = [[UILabel alloc] initWithFrame:CGRectMake(search_cell_margin_left+50, viewHeight/2+5, viewWidth - 70, 20)];
    _subname.adjustsFontSizeToFitWidth = NO;
    _subname.lineBreakMode = NSLineBreakByTruncatingTail;
    [_subname setText:@"subname"];
    [self.contentView addSubview:_subname ];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setContentView:(SearchResultItem *)value atIndex:(NSInteger)index{
    [_name setText:value.name];
    [_subname setText:value.subname];
    if(value.thumbnail==nil){
        NSURL *imageURL = [NSURL URLWithString:value.img];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                [_indicator stopAnimating];
                [_indicator removeFromSuperview];
                _img.image = [UIImage imageWithData:imageData];
                [searchCellDelegate setImageAtIndex:index image: _img.image];

            });
        });
    }else{
        [_indicator stopAnimating];
//        [_indicator removeFromSuperview];
        _img.image = value.thumbnail;
    
    }

}
-(void)setContentView:(SearchResultItem *)value{
    [_name setText:value.name];
    [_subname setText:value.subname];
    if(value.hasData){
        _img.image = value.thumbnail;
    }else{
        NSURL *imageURL = [NSURL URLWithString:value.img];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                [_indicator stopAnimating];
                [_indicator removeFromSuperview];
                UIImage *img =[UIImage imageWithData:imageData];
                _img.image = img;
                [searchCellDelegate setImageAtIndex:1 image:img];
            });
        });
    }
}

@end
