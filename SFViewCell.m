//
//  SFViewCell.m
//  SlideMenu
//
//  Created by Apple on 5/31/15.
//  Copyright (c) 2015 Aryan Ghassemi. All rights reserved.
//

#import "SFViewCell.h"
@interface SFViewCell(){
    CGFloat viewSize;

}
@end
@implementation SFViewCell
-(id)initWithFrame:(CGRect)frame{
    self= [super initWithFrame:frame];
    if(self){
        viewSize = frame.size.width;
        [self _init];
        
    }
    
    return self;

}
-(void)_init{
    self.ftitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewSize , viewSize)];
    self.ftitle.text = @"1";
    self.ftitle.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.ftitle];
    
}
-(void)updateTitle : (NSString *)title{
    self.ftitle.text = title;
}
@end
